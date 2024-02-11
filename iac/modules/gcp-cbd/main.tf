resource "google_project_service" "cloudbuild_api" {
  service = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}

resource "google_cloudbuild_trigger" "main_trigger" {
  project = var.project_id
  name = "${var.repository_name}-repo-trigger"
  description = "Trigger for ${var.repository_name}"

  included_files = [
    "**",
  ]

  filename = var.cloudbuild_filename

  trigger_template {
    project_id  = var.project_id
    repo_name   = var.repository_name
    branch_name = var.branch_name
    tag_name = var.tag_name
  }

  depends_on = [google_project_service.cloudbuild_api]
}