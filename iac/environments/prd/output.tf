output "bucket_name" {
  value = module.gcp-git.repository_url
}

output "secret_wip_name" {
  value = module.gcp-wip.secret_wip_name
}