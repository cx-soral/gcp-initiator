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

resource "github_repository_environment" "environments" {
  for_each = toset(var.env_list)

  environment         = each.value
  repository          = var.repository_name

  depends_on = [github_repository.app-repository]
}

data "google_iam_workload_identity_pool_provider" "pool_provider" {
  for_each = toset(var.env_list)

  provider = google-beta
  project = "${var.project_prefix}${each.value}"
  workload_identity_pool_id          = "github-pool-${var.repository_name}"
  workload_identity_pool_provider_id = "github-provider-${var.repository_name}"
}

data "google_service_account" "github_provider_sa" {
  for_each = toset(var.env_list)

  project      = "${var.project_prefix}${each.value}"
  account_id   = "wip-${var.repository_name}-sa"
}

resource "github_actions_environment_secret" "project_id" {
  for_each = toset(var.env_list)

  repository       = var.repository_name
  environment      = each.value
  secret_name      = "PROJECT_ID"
  plaintext_value  = "${var.project_prefix}${each.value}"

  depends_on = [github_repository.app-repository, github_repository_environment.environments]
}

resource "github_actions_environment_secret" "secret_wip_name" {
  for_each = toset(var.env_list)

  repository       = var.repository_name
  environment      = each.value
  secret_name      = "SECRET_WIP_NAME"
  plaintext_value  = data.google_iam_workload_identity_pool_provider.pool_provider[each.key].name

  depends_on = [github_repository.app-repository, github_repository_environment.environments]
}

resource "github_actions_environment_secret" "provider_sa_email" {
  for_each = toset(var.env_list)

  repository       = var.repository_name
  environment      = each.value
  secret_name      = "PROVIDER_SA_EMAIL"
  plaintext_value  = data.google_service_account.github_provider_sa[each.key].email

  depends_on = [github_repository.app-repository, github_repository_environment.environments]
}