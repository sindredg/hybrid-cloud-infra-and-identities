module "network" {
  source = "../../modules/gcp-network"

  project_id   = var.project_id
  network_name = var.network_name
  network_cidr = var.network_cidr
  description  = "Development network for the Azure-to-GCP hybrid identity lab"

  subnets = {
    (var.subnet_name) = {
      region                   = var.region
      ip_cidr_range            = var.subnet_cidr
      private_ip_google_access = true
      flow_logs_enabled        = false
    }
  }
}

