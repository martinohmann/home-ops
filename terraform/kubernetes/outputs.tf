output "master_nodes" {
  value = module.kubernetes.master_nodes
}

output "worker_nodes" {
  value = module.kubernetes.worker_nodes
}
