# ADR-005: Separate infrastructure state from workload recovery

**Status:** Proposed  
**Date:** 2026-08-05  
**Deciders:** Repository owner

## Context

Terraform needs recoverable state immediately. Workload backup requirements and
recovery objectives are not yet known.

## Decision

Store Terraform state in a versioned, access-controlled regional GCS bucket with
30-day noncurrent-version retention and deletion protection. Choose workload
backup products only after workload RPO, RTO and data residency are defined.

## Options considered

| Option | Recovery | Cost | Scope fit |
|---|---:|---:|---:|
| Versioned GCS state | Strong for IaC state | Low | Required now |
| Local state | Machine-dependent | Low | Not suitable for CI |
| Premature backup platform | Unknown | Potentially high | Requirements missing |

## Consequences

- Accidental state changes can be recovered from older object generations.
- Routine destroy cannot remove a non-empty bucket.
- State protection does not back up application data.

## Action items

1. Test state recovery after backend migration.
2. Define workload RPO and RTO before selecting backup services.

