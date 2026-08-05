mock_provider "google" {}

run "approved_address_plan" {
  command = plan

  variables {
    project_id   = "example-project"
    network_name = "vpc-hybrid-dev"
    network_cidr = "10.30.0.0/16"
    subnets = {
      snet-hybrid-dev-eun1 = {
        region        = "europe-north1"
        ip_cidr_range = "10.30.1.0/24"
      }
    }
  }

  assert {
    condition     = google_compute_network.this.auto_create_subnetworks == false
    error_message = "The VPC must remain custom mode."
  }
}

run "reject_azure_hq_overlap" {
  command = plan

  variables {
    project_id   = "example-project"
    network_name = "vpc-invalid"
    network_cidr = "10.10.40.0/24"
    subnets      = {}
  }

  expect_failures = [var.network_cidr]
}

run "reject_azure_branch_overlap" {
  command = plan

  variables {
    project_id   = "example-project"
    network_name = "vpc-invalid"
    network_cidr = "10.20.40.0/24"
    subnets      = {}
  }

  expect_failures = [var.network_cidr]
}

