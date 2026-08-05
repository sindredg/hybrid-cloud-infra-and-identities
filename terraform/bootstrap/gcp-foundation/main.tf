locals {
  required_services = toset([
    "billingbudgets.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "serviceusage.googleapis.com",
    "sts.googleapis.com",
    "storage.googleapis.com",
  ])
}

resource "google_project_service" "required" {
  for_each = local.required_services

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

resource "google_storage_bucket" "terraform_state" {
  project                     = var.project_id
  name                        = var.state_bucket_name
  location                    = var.region
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false
  labels                      = var.labels

  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      days_since_noncurrent_time = var.state_version_retention_days
    }
    action {
      type = "Delete"
    }
  }

  depends_on = [google_project_service.required]
}

module "cost_governance" {
  source = "../../modules/gcp-cost-governance"

  billing_account_id               = var.billing_account_id
  project_number                   = var.project_number
  display_name                     = "Hybrid infrastructure monthly budget"
  currency_code                    = var.budget_currency_code
  monthly_budget_units             = var.monthly_budget_units
  monitoring_notification_channels = var.monitoring_notification_channels

  depends_on = [google_project_service.required]
}

module "terraform_identity" {
  source = "../../modules/gcp-terraform-identity"

  project_id         = var.project_id
  github_repository  = var.github_repository
  github_environment = var.github_environment
  project_roles      = ["roles/compute.networkAdmin"]

  depends_on = [google_project_service.required]
}

resource "google_storage_bucket_iam_member" "terraform_state" {
  bucket = google_storage_bucket.terraform_state.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${module.terraform_identity.service_account_email}"
}

