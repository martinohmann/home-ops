#!/usr/bin/env bash

JOB=$1
CLUSTER=$2
NAMESPACE="${3:-default}"

[[ -z "${JOB}" ]] && echo "Job name not specified" && exit 1
while true; do
    STATUS="$(kubectl --context "${CLUSTER}" -n "${NAMESPACE}" get pod -l job-name="${JOB}" -o jsonpath='{.items[*].status.phase}')"
    if [ "${STATUS}" == "Pending" ]; then
        break
    fi
    sleep 1
done
