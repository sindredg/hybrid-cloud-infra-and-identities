# Development environment

Thin root that creates the first custom VPC and `europe-north1` subnet through the
`gcp-network` module. The root intentionally has no firewall, route, NAT, VPN,
compute, GKE, load-balancer or external-address resource.

Copy `backend.hcl.example` to `backend.hcl` and `terraform.tfvars.example` to a
`.tfvars` file. Both populated files remain local. Follow the repository foundation
runbook and review the saved plan before apply.

