resource "google_project_service" "cloudbuild_api" {
  service = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

resource "google_cloudbuild_trigger" "main_trigger" {
  project = var.project_id
  name = "${var.repository_name}-main-trigger"
  description = "Trigger for ${var.repository_name} main branch"

  included_files = [
    "**",
  ]

  filename = "cicd/cloudbuild.yaml"

  trigger_template {
    project_id  = var.project_id
    repo_name   = var.repository_name
    branch_name = "main"
  }

  depends_on = [google_project_service.cloudbuild_api]
}