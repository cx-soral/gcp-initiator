module "github" {
  source = "../../modules/github"
  project_prefix = var.project_prefix
  env_list = var.env_list
  repository_owner = var.repository_owner
  repository_name = var.repository_name
}
