# gcp-terraform-identity

Creates a dedicated Terraform service account, its explicit project roles, a
GitHub workload identity pool and an OIDC provider. Trust is restricted to one
repository and one protected GitHub environment.

The module creates no service account keys. Keep `project_roles` limited to the
resources managed by the approved environment root. The baseline grants only
`roles/compute.networkAdmin` for the VPC and subnet.

