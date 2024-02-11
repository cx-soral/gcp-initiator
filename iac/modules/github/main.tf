terraform {
  required_providers {
    github = {
      source  = "integrations/github"
    }
  }
}

data "google_iam_workload_identity_pool_provider" "pool_provider" {
  provider = google-beta
  project = var.project_id
  workload_identity_pool_id          = "github-pool-${var.repository_name}"
  workload_identity_pool_provider_id = "github-provider-${var.repository_name}"
}

data "google_service_account" "github_provider_sa" {
  project      = var.project_id
  account_id   = "wip-${var.repository_name}-sa"
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

  depends_on = [github_repository.app-repository]
}

resource "github_actions_secret" "secret_wip_name" {
  repository       = var.repository_name
  secret_name      = "SECRET_WIP_NAME"
  plaintext_value  = data.google_iam_workload_identity_pool_provider.pool_provider.name

  depends_on = [github_repository.app-repository]
}

resource "github_actions_secret" "provider_sa_email" {
  repository       = var.repository_name
  secret_name      = "PROVIDER_SA_EMAIL"
  plaintext_value  = data.google_service_account.github_provider_sa.email

  depends_on = [github_repository.app-repository]
}