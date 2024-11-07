data "github_repository" "home-ops" {
  full_name = "martinohmann/home-ops"
}

provider "kubernetes" {
  alias          = "main"
  config_context = "main"
}

provider "kubernetes" {
  alias          = "storage"
  config_context = "storage"
}
