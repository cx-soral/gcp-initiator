module "gcp-git" {
  source = "../../modules/gcp-git"
  project_id = var.project_id
  repository_name = var.repository_name
}

module "gcp-wip" {
  source = "../../modules/gcp-wip"
  project_id = var.project_id
  repository_owner = var.repository_owner
  repository_name = var.repository_name
}

module "gcp-cbd" {
  source = "../../modules/gcp-cbd"
  project_id = var.project_id
  repository_name = module.gcp-git.repository_name
  cloudbuild_filename = "cicd/cloudbuild-tag.yaml"
  tag_name = "^v[0-9]+\\.[0-9]+\\.[0-9]+$"
}
