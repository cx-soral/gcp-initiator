resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = "github-pool"
  project  = var.project_id

  # Workload Identity Pool configuration
  display_name = "GitHub Actions Pool"
  description  = "Pool for GitHub Actions"

  # Make sure the pool is in a state to be used
  disabled = false
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id     = "github-provider"
  project  = var.project_id

  # Provider configuration specific to GitHub
  display_name = "GitHub Provider"
  description  = "Provider for GitHub Actions"

   # Attribute mapping / condition from the OIDC token to Google Cloud attributes
  attribute_condition = "assertion.repository_owner == 'cx-soral'"

  attribute_mapping = {
    "google.subject" = "assertion.sub",
    "attribute.actor" = "assertion.actor",
    "attribute.repository" = "assertion.repository",
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "github_provider_sa" {
  project      = var.project_id
  account_id   = "github-provider-sa"
  display_name = "Service Account for Identity Pool provider of GitHub Provider"
}

resource "google_service_account_iam_binding" "service_account_binding" {
  service_account_id = google_service_account.github_provider_sa.id
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/cx-soral/keyless-github-cloudbuild"
  ]
}

resource "google_project_iam_member" "git_mirroring_sa_binding" {
  project = var.project_id
  # role    = "roles/source.admin"
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.github_provider_sa.email}"
}