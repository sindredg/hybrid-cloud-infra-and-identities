# gcp-network

Creates one custom-mode VPC and an explicit set of subnets. It creates no firewall
rules, routes, NAT, VPN, compute or external addresses.

`network_cidr` is a policy boundary rather than a GCP VPC property. Validation
keeps every subnet inside the reservation and blocks overlap with the known Azure
`10.10.0.0/16` and `10.20.0.0/16` networks.

```hcl
module "network" {
  source       = "../../modules/gcp-network"
  project_id   = var.project_id
  network_name = "vpc-hybrid-dev"
  network_cidr = "10.30.0.0/16"
  subnets = {
    snet-hybrid-dev-eun1 = {
      region        = "europe-north1"
      ip_cidr_range = "10.30.1.0/24"
    }
  }
}
```

