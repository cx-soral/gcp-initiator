module "github" {
  source = "../../modules/github"
  repository_name = var.repository_name
}

module "gcp-git" {
  source = "../../modules/gcp-git"
  project_id = var.project_id
  repository_name = var.repository_name
}

module "gcp-wip" {
  source = "../../modules/gcp-wip"
  project_id = var.project_id
}

module "gcp-cbd" {
  source = "../../modules/gcp-cbd"
  project_id = var.project_id
  repository_name = module.gcp-git.repository_name
}