# Troubleshooting log

Problems encountered during the build, their causes and their fixes. Error strings
are kept verbatim where available so they are searchable.

The phase documents describe the path that worked. Troubleshooting files record
what went wrong and how to investigate likely future failures, so the two serve
different purposes: one to follow, one to search when something breaks.

| Phase | File | Theme |
|---|---|---|
| 0 | [00-gcp-foundation.md](00-gcp-foundation.md) | WSL browser authentication, a wrong identity page, a no-op budget diff and remote-state migration |
| 1 | `01-gcp-network.md` | Add when the development VPC phase begins |

## Recurring themes

**Similar product names can lead to the wrong control plane.** Workforce Identity
Federation is for people; Workload Identity Federation is for GitHub automation.
An empty Workforce page did not mean the Terraform deployment had failed.

**A successful apply does not guarantee a no-change plan.** Provider and API
normalization can remove an empty optional block when state is refreshed. Always
run a post-apply plan and diagnose the exact diff.

**Bootstrap has an intentional state transition.** The state bucket cannot be used
before it exists. The first bootstrap apply uses local state, followed by a
controlled backup and `terraform init -migrate-state` into GCS.

**Authentication success and authorization success are different checks.** ADC,
GitHub OIDC, service-account impersonation, project IAM and bucket IAM form separate
links. Test them in order rather than granting a broad role when the final request
is denied.

## Recording future issues

Keep the Azure repository's pattern:

1. Use the exact error text in the heading or symptom.
2. Record the command and working directory that produced it.
3. Separate the observed symptom from the proven cause.
4. State the resolution actually applied, not every attempted command.
5. End with a reusable rule, trap or trade-off when one exists.

Do not publish tokens, Terraform state contents, billing identifiers or personal
account details with an error report.
