output "bucket_name" {
  value = module.gcp-git.repository_url
}

output "secret_wip_name" {
  value = module.gcp-wip.secret_wip_name
}

output "provider_sa_email" {
  value = module.gcp-wip.provider_sa_email
}
