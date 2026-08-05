# ADR-002: Reserve a dedicated GCP address block

**Status:** Proposed  
**Date:** 2026-08-05  
**Deciders:** Repository owner

## Context

Azure already uses `10.10.0.0/16` and `10.20.0.0/16`. GCP needs room for later
workload, management, container and private-service segments.

## Decision

Reserve `10.30.0.0/16` for GCP. Create only `10.30.1.0/24` in `europe-north1`
during the first milestone. Use a custom-mode VPC.

## Options considered

| Option | Simplicity | Growth | Risk |
|---|---:|---:|---:|
| `10.30.0.0/16` reservation | High | High | Low |
| Small isolated `/24` only | High | Low | Future renumbering |
| Auto-mode VPC | High initially | Poor control | Unwanted subnets and overlap risk |

## Consequences

- The address sequence is easy to document and route.
- Unallocated space must remain reserved rather than reused casually.
- Additional subnets require explicit approval and documented purpose.

## Action items

1. Validate all future subnet requests against Azure and GCP reservations.
2. Record allocations in this ADR before deployment.

