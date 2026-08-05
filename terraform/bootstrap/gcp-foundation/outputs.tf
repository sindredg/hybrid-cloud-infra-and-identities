output "state_bucket_name" {
  description = "Bucket to configure as the GCS backend."
  value       = google_storage_bucket.terraform_state.name
}

output "terraform_service_account_email" {
  description = "Service account impersonated by GitHub Actions."
  value       = module.terraform_identity.service_account_email
}

output "workload_identity_provider" {
  description = "Provider name supplied to google-github-actions/auth."
  value       = module.terraform_identity.workload_identity_provider_name
}

output "budget_id" {
  description = "Cloud Billing budget resource ID."
  value       = module.cost_governance.budget_id
}

