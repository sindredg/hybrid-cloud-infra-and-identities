output "service_account_email" {
  description = "Terraform service account email used by GitHub authentication."
  value       = google_service_account.terraform.email
}

output "service_account_name" {
  description = "Fully qualified Terraform service account resource name."
  value       = google_service_account.terraform.name
}

output "workload_identity_provider_name" {
  description = "Provider resource name supplied to google-github-actions/auth."
  value       = google_iam_workload_identity_pool_provider.github.name
}

