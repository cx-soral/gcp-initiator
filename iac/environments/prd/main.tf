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
}

module "github" {
  source = "../../modules/github"
  project_id = var.project_id
  repository_owner = var.repository_owner
  repository_name = var.repository_name
  secret_wip_name = module.gcp-wip.secret_wip_name
  provider_sa_email = module.gcp-wip.provider_sa_email
}
