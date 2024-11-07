module "secrets" {
  for_each = toset(["main", "storage"])
  source   = "../kubernetes/secrets"

  cluster = "main"

  secrets = {
    webhook = {
      path = "apps/flux-system/addons/webhooks/github/secret.sops.yaml"
      name = "github-webhook-token-secret"
    }
  }
}

data "kubernetes_resource" "receiver-main" {
  provider    = kubernetes.main
  api_version = "notification.toolkit.fluxcd.io/v1"
  kind        = "Receiver"

  metadata {
    name      = "github-receiver"
    namespace = "flux-system"
  }
}

data "kubernetes_resource" "receiver-storage" {
  provider    = kubernetes.storage
  api_version = "notification.toolkit.fluxcd.io/v1"
  kind        = "Receiver"

  metadata {
    name      = "github-receiver"
    namespace = "flux-system"
  }
}

locals {
  webhookPaths = {
    main    = data.kubernetes_resource.receiver-main.object.status.webhookPath
    storage = data.kubernetes_resource.receiver-storage.object.status.webhookPath
  }
}

resource "github_repository_webhook" "webhook" {
  for_each   = local.webhookPaths
  repository = data.github_repository.home-ops.name

  configuration {
    url          = format("https://flux-webhook.18b.haus/%s%s", each.key, each.value)
    content_type = "form"
    insecure_ssl = false
    secret       = module.secrets[each.key].data.webhook["token"]
  }

  active = false

  events = ["push"]
}
