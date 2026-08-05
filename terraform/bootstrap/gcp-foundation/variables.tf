variable "project_id" {
  description = "Existing billing-enabled GCP project ID."
  type        = string
}

variable "project_number" {
  description = "Numeric GCP project number."
  type        = string

  validation {
    condition     = can(regex("^[0-9]+$", var.project_number))
    error_message = "project_number must contain digits only."
  }
}

variable "billing_account_id" {
  description = "Cloud Billing account ID without the billingAccounts/ prefix."
  type        = string
}

variable "region" {
  description = "Region for the state bucket and initial GCP footprint."
  type        = string
  default     = "europe-north1"
}

variable "state_bucket_name" {
  description = "Globally unique GCS state bucket name."
  type        = string
}

variable "state_version_retention_days" {
  description = "Days to retain noncurrent state object versions."
  type        = number
  default     = 30

  validation {
    condition     = var.state_version_retention_days >= 7
    error_message = "Retain noncurrent state versions for at least seven days."
  }
}

variable "budget_currency_code" {
  description = "Billing currency. Confirm this against the billing account before apply."
  type        = string
  default     = "NOK"
}

variable "monthly_budget_units" {
  description = "Monthly budget in whole currency units."
  type        = number
  default     = 1000
}

variable "monitoring_notification_channels" {
  description = "Existing Cloud Monitoring notification channel resource names."
  type        = list(string)
  default     = []
}

variable "github_repository" {
  description = "Hybrid-Infra GitHub repository in owner/name form."
  type        = string
}

variable "github_environment" {
  description = "Protected GitHub environment allowed to deploy the GCP dev foundation."
  type        = string
  default     = "gcp-dev"
}

variable "labels" {
  description = "Labels applied to resources that support them."
  type        = map(string)
  default = {
    environment = "foundation"
    managed_by  = "terraform"
    project     = "hybrid-infra"
  }
}

