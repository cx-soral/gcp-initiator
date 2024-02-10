resource "google_project_service" "sourcerepo_api" {
  service = "sourcerepo.googleapis.com"
  disable_on_destroy = false
}

resource "google_sourcerepo_repository" "git_repository" {
  project  = var.project_id
  name     = var.repository_name

  depends_on = [google_project_service.sourcerepo_api]
}

