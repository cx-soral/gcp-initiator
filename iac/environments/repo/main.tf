module "github" {
  source = "../../modules/github"
  project_id = var.project_id
  repository_owner = var.repository_owner
  repository_name = var.repository_name
  secret_wip_name = module.gcp-wip.secret_wip_name
  provider_sa_email = module.gcp-wip.provider_sa_email
}
