variable "project_id" {
  description = "Existing billing-enabled GCP project ID."
  type        = string
}

variable "region" {
  description = "Region for the initial subnet."
  type        = string
  default     = "europe-north1"
}

variable "network_name" {
  description = "Development VPC name."
  type        = string
  default     = "vpc-hybrid-dev"
}

variable "network_cidr" {
  description = "Reserved GCP development address space."
  type        = string
  default     = "10.30.0.0/16"
}

variable "subnet_name" {
  description = "Initial development subnet name."
  type        = string
  default     = "snet-hybrid-dev-eun1"
}

variable "subnet_cidr" {
  description = "Initial development subnet CIDR."
  type        = string
  default     = "10.30.1.0/24"
}

