# ADR-004: Use keyless platform identities

**Status:** Proposed  
**Date:** 2026-08-05  
**Deciders:** Repository owner

## Context

Automation and applications must not use human identities or long-lived service
account keys.

## Decision

Use GitHub OIDC federation to impersonate a dedicated GCP Terraform service
account. Use attached GCP service accounts for GCP workloads and Azure managed
identities for Azure workloads. Introduce cross-cloud workload federation only for
a demonstrated use case.

## Options considered

| Option | Secret exposure | Auditability | Maintenance |
|---|---:|---:|---:|
| OIDC and platform identities | Low | High | Moderate initial setup |
| Downloaded service-account keys | High | Moderate | Rotation burden |
| Human credentials | High | Poor separation | Not acceptable |

## Consequences

- CI credentials are short-lived and repository-restricted.
- IAM roles must expand deliberately as approved modules are added.
- Initial bootstrap still requires an authorised human principal.

## Action items

1. Confirm GitHub repository and protected environment.
2. Review every Terraform service-account role before apply.
3. Test rejection from unapproved repositories and environments.

