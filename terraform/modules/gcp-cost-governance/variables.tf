variable "billing_account_id" {
  description = "Cloud Billing account ID without the billingAccounts/ prefix."
  type        = string
}

variable "project_number" {
  description = "Numeric project number used by the budget filter."
  type        = string
}

variable "display_name" {
  description = "Budget display name."
  type        = string
}

variable "currency_code" {
  description = "Billing-account currency. Confirm it matches the billing account."
  type        = string
  default     = "NOK"
}

variable "monthly_budget_units" {
  description = "Whole currency units for the monthly budget."
  type        = number
  default     = 1000

  validation {
    condition     = var.monthly_budget_units > 0 && floor(var.monthly_budget_units) == var.monthly_budget_units
    error_message = "monthly_budget_units must be a positive whole number."
  }
}

variable "thresholds" {
  description = "Actual-spend ratios that trigger alerts."
  type        = set(number)
  default     = [0.50, 0.75, 0.90]

  validation {
    condition     = alltrue([for threshold in var.thresholds : threshold > 0 && threshold <= 1])
    error_message = "Every threshold must be greater than zero and no greater than one."
  }
}

variable "monitoring_notification_channels" {
  description = "Existing Cloud Monitoring notification channel resource names. Empty retains default billing email behaviour."
  type        = list(string)
  default     = []
}

