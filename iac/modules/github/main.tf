terraform {
  required_providers {
    github = {
      source  = "integrations/github"
    }
  }
}

resource "github_repository" "app-repository" {
  name        = var.repository_name
  description = "GCP Application: ${var.repository_name}"

  visibility = "public"

  template {
    owner                = "cx-soral"
    repository           = "gcp-framework"
    include_all_branches = true
  }
}

resource "github_actions_secret" "project_id" {
  repository       = var.repository_name
  secret_name      = "PROJECT_ID"
  plaintext_value  = var.project_id
}

resource "github_actions_secret" "secret_wip_name" {
  repository       = var.repository_name
  secret_name      = "SECRET_WIP_NAME"
  plaintext_value  = var.secret_wip_name
}

resource "github_actions_secret" "provider_sa_email" {
  repository       = var.repository_name
  secret_name      = "PROVIDER_SA_EMAIL"
  plaintext_value  = var.provider_sa_email
}