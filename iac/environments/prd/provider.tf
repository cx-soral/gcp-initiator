terraform {
  required_providers {
    github = {
      source  = "integrations/github"
    }
  }
}

provider "google" {
  project = var.project_id
}

provider "google-beta" {
  project = var.project_id
}
