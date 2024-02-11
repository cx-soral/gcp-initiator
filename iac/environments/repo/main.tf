module "github" {
  source = "../../modules/github"
  project_id = var.project_id
  repository_owner = var.repository_owner
  repository_name = var.repository_name
}
