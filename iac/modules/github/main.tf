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
}