output "network_id" {
  description = "Development VPC resource ID."
  value       = module.network.network_id
}

output "subnet_ids" {
  description = "Development subnet resource IDs."
  value       = module.network.subnet_ids
}

output "address_plan" {
  description = "Reserved VPC range and allocated subnet ranges."
  value = {
    reservation = var.network_cidr
    subnets     = module.network.subnet_cidrs
  }
}

