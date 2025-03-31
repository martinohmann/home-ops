<div align="center">

<img src="https://github.com/martinohmann/home-ops/blob/main/assets/logo.png?raw=true" align="center" width="144px" height="144px"/>

### Kubernetes at Home

_... managed with Terraform, Ansible, Flux, Renovate, and GitHub Actions_

</div>

<div align="center">

[![Kubernetes](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fkubernetes_version%3Fformat%3Dendpoint&style=for-the-badge&label=Kubernetes&logo=kubernetes&color=orange)](https://k3s.io/)&nbsp;
[![Flux](https://img.shields.io/badge/GitOps-Flux-blue?style=for-the-badge&logo=git)](https://fluxcd.io/)&nbsp;
[![Renovate](https://img.shields.io/badge/renovate-enabled-brightgreen?style=for-the-badge&logo=renovatebot)](https://github.com/renovatebot/renovate)&nbsp;

</div>

<div align="center">

[![Age-Days](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fcluster_age_days%3Fformat%3Dendpoint&style=flat-square&label=Age)](https://github.com/kashalls/kromgo/)&nbsp;
[![Uptime-Days](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fcluster_uptime_days%3Fformat%3Dendpoint&style=flat-square&label=Uptime)](https://github.com/kashalls/kromgo/)&nbsp;
[![Node-Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fcluster_node_count%3Fformat%3Dendpoint&style=flat-square&label=Nodes&color=blue)](https://github.com/kashalls/kromgo/)&nbsp;
[![Pod-Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fcluster_pod_count%3Fformat%3Dendpoint&style=flat-square&label=Pods&color=blue)](https://github.com/kashalls/kromgo/)&nbsp;
[![CPU-Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fcluster_cpu_usage%3Fformat%3Dendpoint&style=flat-square&label=CPU)](https://github.com/kashalls/kromgo/)&nbsp;
[![Memory-Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fcluster_memory_usage%3Fformat%3Dendpoint&style=flat-square&label=Memory)](https://github.com/kashalls/kromgo/)&nbsp;

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
`kubernetes/${cluster}/apps` folder until it finds the most top level `kustomization.yaml`
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

This Git repository contains the following directories under [Kubernetes](./kubernetes).

```sh
📁 kubernetes
├── 📁 main            # main cluster
│   ├── 📁 apps           # applications
│   ├── 📁 bootstrap      # bootstrap procedures
│   ├── 📁 components     # re-useable components
│   └── 📁 flux           # core flux configuration
└── 📁 storage         # storage cluster
    ├── 📁 apps           # applications
    ├── 📁 bootstrap      # bootstrap procedures
    ├── 📁 components     # re-useable components
    └── 📁 flux           # core flux configuration
```

---

## 🔧 Hardware

<details>
  <summary>Click to see the rack!</summary>

  <img src="https://static.18b.haus/img/rack.jpg" align="center" alt="rack" />
</details>

| Device                         | Count | Disk Size                                   | Ram  | Operating System | Purpose                 |
| ------------------------------ | ----- | ------------------------------------------- | ---- | ---------------- | ----------------------- |
| ThinkCentre M900 Tiny i5-6500T | 2     | 1TB NVMe                                    | 32GB | Proxmox VE 8     | Kubernetes VMs          |
| ThinkCentre M900 Tiny i7-6700T | 1     | 1TB NVMe                                    | 32GB | Proxmox VE 8     | Kubernetes VMs          |
| STRHIGP Mini J4125             | 1     | 128GB SSD                                   | 8GB  | OPNsense         | Router                  |
| Topton N5105 DIY NAS           | 1     | 240GB SSD + 2x 6TB HDD ZFS (mirrored vdevs) | 32GB | Debian 12        | NFS + Backup Server     |
| PiKVM (Raspberry Pi 4)         | 1     | 16GB (SD)                                   | 4GB  | PiKVM (Arch)     | KVM                     |
| TESmart 8 Port KVM Switch      | 1     | -                                           | -    | -                | Network KVM (for PiKVM) |
| UniFi USW-24-PoE               | 1     | -                                           | -    | -                | Core Switch             |

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
