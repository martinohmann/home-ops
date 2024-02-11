<div align="center">

<img src="https://github.com/martinohmann/home-ops/blob/main/assets/logo.png?raw=true" align="center" width="144px" height="144px"/>

### Kubernetes at Home

_... managed with Terraform, Ansible, Flux, Renovate, and GitHub Actions_

</div>

<div align="center">

[![Kubernetes](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fquery%3Fformat%3Dendpoint%26metric%3Dkubernetes_version&style=for-the-badge&label=Kubernetes&logo=kubernetes&color=orange)](https://k3s.io/)&nbsp;
[![Flux](https://img.shields.io/badge/GitOps-Flux-blue?style=for-the-badge&logo=git)](https://fluxcd.io/)&nbsp;
[![Renovate](https://img.shields.io/badge/renovate-enabled-brightgreen?style=for-the-badge&logo=renovatebot)](https://github.com/renovatebot/renovate)&nbsp;

</div>

<div align="center">

[![Age-Days](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_age_days&style=flat-square&label=Age)](https://github.com/kashalls/kromgo/)&nbsp;
[![Uptime-Days](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_uptime_days&style=flat-square&label=Uptime)](https://github.com/kashalls/kromgo/)&nbsp;
[![Node-Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_node_count&style=flat-square&label=Nodes&color=blue)](https://github.com/kashalls/kromgo/)&nbsp;
[![Pod-Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_pod_count&style=flat-square&label=Pods&color=blue)](https://github.com/kashalls/kromgo/)&nbsp;
[![CPU-Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_cpu_usage&style=flat-square&label=CPU)](https://github.com/kashalls/kromgo/)&nbsp;
[![Memory-Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_memory_usage&style=flat-square&label=Memory)](https://github.com/kashalls/kromgo/)&nbsp;

</div>

---

## 📖 Overview

This is a mono repository for my home infrastructure and Kubernetes cluster. I
try to adhere to Infrastructure as Code (IaC) and GitOps practices using tools
like [Ansible](https://www.ansible.com/),
[Terraform](https://www.terraform.io/), [Kubernetes](https://kubernetes.io/),
[Flux](https://github.com/fluxcd/flux2),
[Renovate](https://github.com/renovatebot/renovate), and [GitHub
Actions](https://github.com/features/actions).

---

## ⛵ Kubernetes

There is a template over at
[onedr0p/flux-cluster-template](https://github.com/onedr0p/flux-cluster-template)
if you want to try and follow along with some of the practices I use here.

### Installation

My cluster is [k3s](https://k3s.io/) provisioned over
[Proxmox](https://www.proxmox.com/) Ubuntu VMs using the
[Ansible](https://www.ansible.com/) galaxy role
[ansible-role-k3s](https://github.com/PyratLabs/ansible-role-k3s). The VMs are
managed via [Terraform](./terraform/proxmox).

This is a semi-hyper-converged cluster, workloads and block storage are sharing
the same available resources on my nodes while I have a separate server for NFS
shares, bulk file storage and backups.

### Core Components

- [actions-runner-controller](https://github.com/actions/actions-runner-controller): self-hosted Github runners
- [cilium](https://github.com/cilium/cilium): internal Kubernetes networking plugin
- [cert-manager](https://cert-manager.io/docs/): creates SSL certificates for services in my cluster
- [external-dns](https://github.com/kubernetes-sigs/external-dns): automatically syncs DNS records from my cluster ingresses to a DNS provider
- [ingress-nginx](https://github.com/kubernetes/ingress-nginx/): ingress controller for Kubernetes using NGINX as a reverse proxy and load balancer
- [longhorn](https://github.com/longhorn/longhorn): distributed block storage for persistent storage
- [sops](https://toolkit.fluxcd.io/guides/mozilla-sops/): managed secrets for Kubernetes, Ansible, and Terraform which are committed to Git
- [system-upgrade-controller](https://github.com/rancher/system-upgrade-controller): automate K3s server and agent updates
- [volsync](https://github.com/backube/volsync): backup and recovery of persistent volume claims

### GitOps

[Flux](https://github.com/fluxcd/flux2) watches the clusters in my
[kubernetes](./kubernetes/) folder (see Directories below) and makes the
changes to my clusters based on the state of my Git repository.

The way Flux works for me here is it will recursively search the
`kubernetes/apps` folder until it finds the most top level `kustomization.yaml`
per directory and then apply all the resources listed in it. That
aforementioned `kustomization.yaml` will generally only have a namespace
resource and one or many Flux kustomizations (`ks.yaml`). Under the control of
those Flux kustomizations there will be a `HelmRelease` or other resources
related to the application which will be applied.

[Renovate](https://github.com/renovatebot/renovate) watches my **entire**
repository looking for dependency updates, when they are found a PR is
automatically created. When some PRs are merged Flux applies the changes to my
cluster.

### Directories

This Git repository contains the following directories under [Kubernetes](./kubernetes/).

```sh
📁 kubernetes      # Kubernetes cluster defined as code
├─📁 bootstrap     # Flux installation (not tracked by Flux)
├─📁 flux          # Main Flux configuration of repository
├─📁 apps          # Apps deployed into the cluster grouped by namespace
└─📁 templates     # Re-usable component templates
```

---

## 🔧 Hardware

<details>
  <summary>Click to see the tiny rack!</summary>

  <img src="https://github.com/martinohmann/home-ops/blob/main/assets/rack.jpg?raw=true" align="center" alt="rack" />
</details>

| Device                         | Count | Disk Size | Ram  | Operating System | Purpose                           |
| ------------------------------ | ----- | --------- | ---- | ---------------- | --------------------------------- |
| ThinkCentre M900 Tiny i5-6500T | 2     | 1TB NVMe  | 32GB | Proxmox VE 8     | Kubernetes VMs                    |
| ThinkCentre M900 Tiny i7-6700T | 1     | 1TB NVMe  | 32GB | Proxmox VE 8     | Kubernetes VMs + UniFi Controller |
| STRHIGP Mini J4125             | 1     | 128GB SSD | 8GB  | OPNsense         | Router                            |
| Synology DiskStation           | 1     | 3TB HDD   | 2GB  | DSM              | NFS + Backup Server               |
| UniFi USW-24-PoE               | 1     | -         | -    | -                | Core Switch                       |

---

## 🤝 Gratitude and Thanks

Thanks to all the people who donate their time to the [Home
Operations](https://discord.gg/home-operations) Discord community. Be sure to
check out [kubesearch.dev](https://kubesearch.dev/) for ideas on how to deploy
applications or get ideas on what you may deploy.

---

## 📜 Changelog

See my _awful_ [commit history](https://github.com/martinohmann/home-ops/commits/main)

---

## 📜 License

See [LICENSE](./LICENSE)
