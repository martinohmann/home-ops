<div align="center">

<img src="https://camo.githubusercontent.com/5b298bf6b0596795602bd771c5bddbb963e83e0f/68747470733a2f2f692e696d6775722e636f6d2f7031527a586a512e706e67" align="center" width="144px" height="144px"/>

### Kubernetes at Home

_... managed with Terraform, Ansible, Flux, Renovate, and GitHub Actions_

</div>

<div align="center">

[//]: # "renovate: datasource=github-releases depName=k3s-io/k3s"
[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.29.0+k3s1-orange?style=for-the-badge&logo=kubernetes)](https://k3s.io/)&nbsp;
[![Flux](https://img.shields.io/badge/GitOps-Flux-blue?style=for-the-badge&logo=git)](https://fluxcd.io/)&nbsp;
[![Renovate](https://img.shields.io/badge/renovate-enabled-brightgreen?style=for-the-badge&logo=renovatebot)](https://github.com/renovatebot/renovate)&nbsp;

</div>

<div align="center">

[![Age-Days](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_age_days&style=flat-square&label=Age)](https://github.com/kashalls/kromgo/)&nbsp;
[![Uptime-Days](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_uptime_days&style=flat-square&label=Uptime)](https://github.com/kashalls/kromgo/)&nbsp;
[![Node-Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_node_count&style=flat-square&label=Nodes)](https://github.com/kashalls/kromgo/)&nbsp;
[![Pod-Count](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_pod_count&style=flat-square&label=Pods)](https://github.com/kashalls/kromgo/)&nbsp;
[![CPU-Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_cpu_usage&style=flat-square&label=CPU)](https://github.com/kashalls/kromgo/)&nbsp;
[![Memory-Usage](https://img.shields.io/endpoint?url=https%3A%2F%2Fkromgo.18b.haus%2Fquery%3Fformat%3Dendpoint%26metric%3Dcluster_memory_usage&style=flat-square&label=Memory)](https://github.com/kashalls/kromgo/)&nbsp;

</div>

---

## Overview

This project was created using the absolutely great
[`flux-cluster-template`](https://github.com/onedr0p/flux-cluster-template).

---

## Features

- Terraform managed Kubernetes nodes based on Proxmox VMs
- Nodes provisioned via Ansible
- Git-ops managed cluster resources via Flux
- Renovate and GitHub Actions keep everything up-to-date
