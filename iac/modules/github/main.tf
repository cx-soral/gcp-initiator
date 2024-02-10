terraform {
  required_providers {
    github = {
      source  = "integrations/github"
    }
  }
}

resource "github_repository" "app-repository" {
  name        = var.repository_name
  description = "My awesome codebase"

  visibility = "public"

  template {
    owner                = "cx-soral"
    repository           = "gcp-framework"
    include_all_branches = true
  }
}

resource "github_actions_secret" "secret_wip_name" {
  repository       = var.repository_name
  secret_name      = "secret_wip_name"
  plaintext_value  = var.secret_wip_name
}

resource "github_actions_secret" "provider_sa_email" {
  repository       = var.repository_name
  secret_name      = "provider_sa_email"
  plaintext_value  = var.provider_sa_email
}