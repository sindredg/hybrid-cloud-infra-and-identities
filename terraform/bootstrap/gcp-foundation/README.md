# GCP foundation bootstrap

Creates the APIs, protected state bucket, monthly budget, Terraform service
account, its state access, and repository-restricted GitHub OIDC federation.

The first run uses local state because the bucket does not exist yet. After apply,
copy `backend.tf.example` to the ignored `backend.tf`, then run the migration command
in the foundation runbook. Never commit local state or the populated variable file.

The bootstrap uses an authorised human's Application Default Credentials. The
Terraform service account is deliberately limited to network administration and
objects in this one state bucket. It cannot administer project IAM or billing.

