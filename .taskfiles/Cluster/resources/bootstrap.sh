#!/usr/bin/env bash

set -euo pipefail

cluster_dir=
cluster=
dry_run=1

function log() {
    gum log --time=rfc3339 --formatter=text --structured --level "$@"
}

# Wait for all nodes to be ready
function wait_for_nodes() {
    log debug "Waiting for nodes to be available"

    # Skip waiting if all nodes are 'Ready=True'
    if kubectl --context "${cluster}" wait nodes --for=condition=Ready=True --all --timeout=10s &>/dev/null; then
        log info "Nodes are available and ready, skipping wait for nodes"
        return
    fi

    # Wait for all nodes to be 'Ready=False'
    until kubectl --context "${cluster}" wait nodes --for=condition=Ready=False --all --timeout=10s &>/dev/null; do
        log info "Nodes are not available, waiting for nodes to be available. Retrying in 10 seconds..."
        sleep 10
    done
}

# Applications in the helmfile require Prometheus custom resources (e.g. servicemonitors)
function apply_prometheus_crds() {
    log debug "Applying Prometheus CRDs"

    # renovate: datasource=github-releases depName=prometheus-operator/prometheus-operator
    local -r version=v0.86.0
    local resources crds

    # Fetch resources using kustomize build
    if ! resources=$(kustomize build "https://github.com/prometheus-operator/prometheus-operator/?ref=${version}" 2>/dev/null) || [[ -z "${resources}" ]]; then
        log fatal "Failed to fetch Prometheus CRDs, check the version or the repository URL"
    fi

    # Extract only CustomResourceDefinitions
    if ! crds=$(echo "${resources}" | yq '. | select(.kind == "CustomResourceDefinition")' 2>/dev/null) || [[ -z "${crds}" ]]; then
        log fatal "No CustomResourceDefinitions found in the fetched resources"
    fi

    # Check if the CRDs are up-to-date
    if echo "${crds}" | kubectl --context "${cluster}" diff --filename - &>/dev/null; then
        log info "Prometheus CRDs are up-to-date"
        return
    fi

    if [[ $dry_run == 1 ]]; then
        log info "Would apply Prometheus CRDs"
        return
    fi

    # Apply the CRDs
    if echo "${crds}" | kubectl --context "${cluster}" apply --server-side --filename - &>/dev/null; then
        log info "Prometheus CRDs applied successfully"
    else
        log fatal "Failed to apply Prometheus CRDs"
    fi
}

# Cilium requires Gateway API CRDs.
function apply_gateway_api_crds() {
    log debug "Applying Gateway API CRDs"

    # renovate: datasource=github-releases depName=kubernetes-sigs/gateway-api
    local -r version=v1.4.0
    local url="https://github.com/kubernetes-sigs/gateway-api/releases/download/${version}/experimental-install.yaml"

    # Check if the CRDs are up-to-date
    if kubectl --context "${cluster}" diff --filename "${url}" &>/dev/null; then
        log info "Gateway API CRDs are up-to-date"
        return
    fi

    if [[ $dry_run == 1 ]]; then
        log info "Would apply Gateway API CRDs"
        return
    fi

    # Apply the CRDs
    if kubectl --context "${cluster}" apply --server-side --filename "${url}" &>/dev/null; then
        log info "Gateway API CRDs applied successfully"
    else
        log fatal "Failed to apply Gateway API CRDs"
    fi
}

# The application namespaces are created before applying the resources
function apply_namespaces() {
    log debug "Applying namespaces"

    local -r apps_dir="${cluster_dir}/apps"

    if [[ ! -d "${apps_dir}" ]]; then
        log fatal "Directory does not exist" directory "${apps_dir}"
    fi

    for app in "${apps_dir}"/*/; do
        namespace=$(basename "${app}")

        # Check if the namespace resources are up-to-date
        if kubectl --context "${cluster}" get namespace "${namespace}" &>/dev/null; then
            log info "Namespace resource is up-to-date" resource "${namespace}"
            continue
        fi

        if [[ $dry_run == 1 ]]; then
            log info "Would apply namespace resource" resource "${namespace}"
            continue
        fi

        # Apply the namespace resources
        if kubectl --context "${cluster}" create namespace "${namespace}" --dry-run=client --output=yaml \
            | kubectl --context "${cluster}" apply --server-side --filename - &>/dev/null;
        then
            log info "Namespace resource applied" resource "${namespace}"
        else
            log fatal "Failed to apply namespace resource" resource "${namespace}"
        fi
    done
}

# SOPS secrets to be applied before flux is installed
function apply_sops_secrets() {
    log debug "Applying secrets"

    local -r secrets=(
        "${cluster_dir}/bootstrap/secrets/github-deploy-key.sops.yaml"
        "${cluster_dir}/components/common/secrets/cluster-secrets.sops.yaml"
        "${cluster_dir}/components/common/secrets/dockerhub-auth.sops.yaml"
        "${cluster_dir}/components/common/secrets/sops-age.sops.yaml"
    )

    for secret in "${secrets[@]}"; do
        if [ ! -f "${secret}" ]; then
            log warn "File does not exist" file "${secret}"
            continue
        fi

        # Check if the secret resources are up-to-date
        if sops exec-file "${secret}" "kubectl --context ${cluster} --namespace flux-system diff --filename {}" &>/dev/null; then
            log info "Secret resource is up-to-date" resource "$(basename "${secret}" ".sops.yaml")"
            continue
        fi

        if [[ $dry_run == 1 ]]; then
            log info "Would apply secret resource" resource "$(basename "${secret}" ".sops.yaml")"
            continue
        fi

        # Apply secret resources
        if sops exec-file "${secret}" "kubectl --context ${cluster} --namespace flux-system apply --server-side --filename {}" &>/dev/null; then
            log info "Secret resource applied successfully" resource "$(basename "${secret}" ".sops.yaml")"
        else
            log fatal "Failed to apply secret resource" resource "$(basename "${secret}" ".sops.yaml")"
        fi
    done
}

# Bootstrap Flux into the cluster
function apply_flux_bootstrap() {
    log debug "Applying Flux bootstrap"

    # Check if Flux is already installed
    if kubectl --context "${cluster}" --namespace flux-system get deployment kustomize-controller &>/dev/null; then
        log info "Flux is already installed"
        return
    fi

    if [[ $dry_run == 1 ]]; then
        log info "Would install flux"
        return
    fi

    # Install Flux
    kubectl --context "${cluster}" apply --kustomize "${cluster_dir}/bootstrap"
}

# Apply the Flux config to the cluster
function apply_flux_config() {
    log debug "Applying Flux config"

    # Check if Flux config is already applied
    if kubectl --context "${cluster}" --namespace flux-system get kustomization cluster &>/dev/null; then
        log info "Flux config is already installed"
        return
    fi

    if [[ $dry_run == 1 ]]; then
        log info "Would apply flux config"
        return
    fi

    # Apply Flux config
    kubectl --context "${cluster}" apply --kustomize "${cluster_dir}/flux/config"
}

function usage() {
    cat <<-EOS
usage: $(basename "$0") [cluster]

Bootstrap a cluster.

options:
  -h|--help         Show this help and exit.
     --no-dry-run   Apply modifications instead of logging them.
EOS
}

function parse_args() {
    while [[ "$#" -ge 1 ]]; do
        case "$1" in
            -h|--help|help)
                usage; exit ;;
            --no-dry-run)
                dry_run=0 ;;
            -*)
                log fatal "Unknown flag $1" ;;
            *)
                if [[ -n "${cluster}" ]]; then
                    usage
                    exit 1
                fi

                cluster="$1" ;;
        esac
        shift
    done

    if [[ -z "${cluster}" ]]; then
        usage
        exit 1
    fi

    cluster_dir="${KUBERNETES_DIR:-kubernetes}/${cluster}"

    if [[ ! -d "${cluster_dir}" ]]; then
        log fatal "Directory does not exist" directory "${cluster_dir}"
    fi
}

function main() {
    if [[ $dry_run == 1 ]]; then
        log info "Running in dry-run mode, pass --no-dry-run to apply modifications"
    fi

    wait_for_nodes
    apply_gateway_api_crds
    apply_prometheus_crds
    apply_namespaces
    apply_sops_secrets
    apply_flux_bootstrap
    apply_flux_config
}

parse_args "$@"
main
