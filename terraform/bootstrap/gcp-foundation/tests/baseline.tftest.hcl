mock_provider "google" {}

run "approved_bootstrap_baseline" {
  command = plan

  variables {
    project_id         = "example-project"
    project_number     = "123456789012"
    billing_account_id = "000000-000000-000000"
    state_bucket_name  = "example-project-terraform-state"
    github_repository  = "sindredg/hybrid-infra"
    github_environment = "gcp-dev"
  }

  assert {
    condition     = google_storage_bucket.terraform_state.public_access_prevention == "enforced"
    error_message = "Terraform state must enforce public access prevention."
  }

  assert {
    condition     = google_storage_bucket.terraform_state.force_destroy == false
    error_message = "Routine destroy must not erase versioned Terraform state."
  }

}
