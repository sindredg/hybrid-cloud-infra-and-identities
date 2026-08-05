# GCP foundation runbook

Architecture: [GCP architecture](architecture/gcp.md).  
Troubleshooting: [Phase 0 GCP foundation](troubleshooting/00-gcp-foundation.md).

The bootstrap foundation was deployed from a reviewed plan. This runbook remains the
rebuild and operational procedure. Run each plan separately and review it before
applying anything.

## Prerequisites

- Terraform 1.8 or later
- Google Cloud CLI with Application Default Credentials for the one-time bootstrap
- An existing billing-enabled GCP project
- Permission to manage project services, IAM, the billing budget and storage
- The project ID, project number, billing account ID and notification channel IDs
- The final GitHub `owner/repository` and protected environment name

Copy each `.tfvars.example` file to a non-committed `.tfvars` file and replace all
placeholders. Notification channels must already exist in Cloud Monitoring. When
the channel list is empty, Cloud Billing uses its default email-recipient behaviour.

## Bootstrap

```powershell
Set-Location terraform/bootstrap/gcp-foundation
terraform init
terraform fmt -check
terraform validate
terraform plan -out bootstrap.tfplan
terraform show bootstrap.tfplan
```

Only apply after confirming the plan contains the approved APIs, budget, state
bucket, service account, IAM bindings and GitHub federation resources.

After apply, migrate bootstrap state into its own prefix in the new bucket:

```powershell
terraform init -migrate-state -backend-config="bucket=REPLACE_STATE_BUCKET" -backend-config="prefix=bootstrap/gcp-foundation"
```

Verify `terraform state list` and a fresh `terraform plan` before removing any
remaining local state copy.

## Development network

Copy `backend.hcl.example` to the ignored `backend.hcl`, fill in the bucket name,
then run:

```powershell
Set-Location terraform/environments/dev
terraform init -backend-config=backend.hcl
terraform fmt -check
terraform validate
terraform plan -out dev.tfplan
terraform show dev.tfplan
```

The plan must contain one custom VPC and one subnet only. It must not contain
compute, NAT, VPN, GKE, external IP or load-balancer resources.

## Cleanup

Destroy the dev root first. Review the destroy plan before approval. Remove
bootstrap IAM and federation only after no workflow depends on them. Retain the
budget until billing reports show no unintended resources.

The bucket deliberately has `force_destroy = false`. Terraform cannot delete it
while state objects or historical versions exist. State deletion is a separate
manual recovery-impact procedure and is not part of routine cleanup.
