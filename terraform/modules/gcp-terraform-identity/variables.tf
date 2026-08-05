variable "project_id" {
  description = "Project containing the service account and workload identity pool."
  type        = string
}

variable "service_account_id" {
  description = "Account ID for the Terraform service account."
  type        = string
  default     = "terraform-dev"
}

variable "project_roles" {
  description = "Project roles required by the approved Terraform root."
  type        = set(string)
  default     = ["roles/compute.networkAdmin"]
}

variable "workload_identity_pool_id" {
  description = "GitHub Actions workload identity pool ID."
  type        = string
  default     = "github-actions"
}

variable "provider_id" {
  description = "GitHub OIDC provider ID."
  type        = string
  default     = "github"
}

variable "github_repository" {
  description = "Allowed GitHub repository in owner/name form."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$", var.github_repository))
    error_message = "github_repository must use owner/name form."
  }
}

variable "github_environment" {
  description = "Protected GitHub environment required in the OIDC token."
  type        = string
  default     = "gcp-dev"
}

