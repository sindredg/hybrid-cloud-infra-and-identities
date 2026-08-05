# Phase 0. GCP foundation

Deployment record: [00-gcp-foundation.md](../00-gcp-foundation.md).  
Runbook: [foundation-runbook.md](../foundation-runbook.md).

The phase completed cleanly overall. The useful problems were an unsupported WSL
browser launch, navigation to the wrong identity product, a persistent no-op budget
diff and the one-time state-backend transition.

---

## 1. WSL could not launch the Application Default Credentials browser

**Symptom.** `gcloud auth application-default login` tried to launch a browser
through `gio`, which WSL reported as unsupported.

**Cause.** Google Cloud CLI was running inside WSL while the interactive browser
lived in Windows. The Linux environment did not have a supported desktop URL
handler.

**Resolution applied.** Used the console-assisted flow:

```bash
gcloud auth application-default login --no-launch-browser
```

The printed URL was opened in Windows and the returned authorization code was
pasted into WSL. The quota project was then set to the target GCP project.

**Rule.** In a headless shell or WSL session, use `--no-launch-browser`. Do not copy
ADC JSON into the repository or substitute a service-account key.

---

## 2. The deployed GitHub pool was missing from the Console

**Symptom.** The Console showed an empty **Workforce Identity Pools** page with a
**Create pool** button after Terraform had created a GitHub identity pool.

**Cause.** The wrong product page was open. Workforce Identity Federation is for
human users from an external identity provider. Terraform created a **Workload
Identity Federation** pool for GitHub automation.

**Resolution applied.** Opened **IAM & Admin > Workload Identity Federation** and
confirmed the active **GitHub Actions** pool and **GitHub OIDC** provider.

**Rule.** Workforce equals people; Workload equals software and automation. Do not
create a second pool to compensate for looking at the wrong page.

---

## 3. `Plan: 0 to add, 1 to change, 0 to destroy` after a successful apply

**Symptom.** Every refreshed plan proposed an in-place update to the billing budget:

```text
Plan: 0 to add, 1 to change, 0 to destroy.

+ all_updates_rule {
    disable_default_iam_recipients   = false
    enable_project_level_recipients  = false
    monitoring_notification_channels = []
    schema_version                   = "1.0"
  }
```

**Cause.** The configuration requested an optional `all_updates_rule` containing
only default values and an empty Monitoring channel list. The Google API omitted
that no-op block when returning the budget, so refreshed state could never converge
with the configuration.

**Resolution applied.** Removed only the empty `all_updates_rule` from the cost
governance module. The separate 50%, 75% and 90% threshold rules remained. The next
plan reported:

```text
No changes. Your infrastructure matches the configuration.
```

**Rule.** Do not configure an optional notification block until it contains a real
Monitoring notification channel. Reapplying an API-normalized empty block does not
fix drift.

---

## 4. Bootstrap state starts locally even though remote state is required

**Not an error: an intentional bootstrap sequence.** Terraform cannot use a GCS
bucket as its backend before that bucket exists.

**Sequence applied.** The bootstrap root was initialized with the local backend,
planned and applied. Before migration, the local state was copied outside the
repository with owner-only permissions. The ignored backend file was then enabled
and state migrated:

```bash
terraform init -migrate-state \
  -backend-config="bucket=<state-bucket>" \
  -backend-config="prefix=bootstrap/gcp-foundation"
```

Terraform found the existing local state and asked whether to copy it into GCS. The
answer was `yes`. `terraform state list`, the GCS object view and a final no-change
plan confirmed the transition.

**Trap.** Answering `no` starts with an empty remote state. The resources still
exist, but Terraform no longer knows it manages them and may plan duplicates.

**Recovery.** Stop before applying. Restore the private local backup or rerun backend
migration from a directory still holding the correct state. Never repair this by
manually editing or publishing the state JSON.

---

## Future diagnostic playbook

The following failures were not encountered in Phase 0. They are recorded so later
operators have a safe first response.

### `Error acquiring the state lock`

1. Confirm no Terraform process or GitHub job is currently running.
2. Inspect the lock information and identify its owner and creation time.
3. Retry after the legitimate operation finishes.
4. Use `terraform force-unlock <LOCK_ID>` only when the recorded owner is certainly
   gone. A forced unlock during an active write can corrupt state.

### `403` or `PermissionDenied` during Terraform

Test the chain in order:

1. Confirm the active ADC identity for local work, or the GitHub OIDC claims for CI.
2. Confirm the token repository and environment match the provider condition.
3. Confirm the federated principal may impersonate the Terraform service account.
4. Confirm the service account holds the role required by the failing resource.
5. For state operations, confirm bucket-level `roles/storage.objectAdmin` separately.

Do not grant Owner or Editor as a diagnostic shortcut. A broad grant hides which
link is actually broken and weakens the portfolio design.

### GitHub OIDC authentication fails

Confirm the workflow declares:

```yaml
permissions:
  contents: read
  id-token: write

jobs:
  terraform:
    environment: gcp-dev
```

The repository and environment names are part of the trust condition. A renamed
repository, fork, pull-request context or missing `environment:` changes the token
claims and should be denied.

### Budget email does not arrive immediately

Budgets are not real-time and are not hard spending caps. Confirm the billing scope,
threshold basis, default billing recipients and recipient permissions. Do not claim
delivery was validated until a real threshold event produces a notification.

### A plan proposes replacement or deletion of a foundation resource

Stop. Save the plan output privately and identify why the address or immutable
argument changed. Pay particular attention to the state bucket, service-account ID,
workload pool ID and provider ID. Use Terraform `moved` blocks for address-only
refactors where appropriate; never approve a destructive foundation plan merely to
make configuration and state agree.
