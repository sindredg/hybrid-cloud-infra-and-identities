output "network_id" {
  description = "Fully qualified VPC resource ID."
  value       = google_compute_network.this.id
}

output "network_name" {
  description = "VPC name."
  value       = google_compute_network.this.name
}

output "subnet_ids" {
  description = "Fully qualified subnet IDs keyed by subnet name."
  value       = { for name, subnet in google_compute_subnetwork.this : name => subnet.id }
}

output "subnet_cidrs" {
  description = "Effective subnet CIDRs keyed by subnet name."
  value       = { for name, subnet in google_compute_subnetwork.this : name => subnet.ip_cidr_range }
}

