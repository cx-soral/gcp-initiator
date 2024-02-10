output "secret_wip_name" {
  value = google_iam_workload_identity_pool_provider.github_provider.name
}

output "provider_sa_email" {
  value = google_service_account.github_provider_sa.email
}