mock_provider "google" {}

run "approved_network_baseline" {
  command = plan

  variables {
    project_id = "example-project"
  }

  assert {
    condition     = module.network.network_name == "vpc-hybrid-dev"
    error_message = "The development root must create the approved custom VPC."
  }

  assert {
    condition     = module.network.subnet_cidrs["snet-hybrid-dev-eun1"] == "10.30.1.0/24"
    error_message = "The development root must use the approved initial subnet."
  }
}

