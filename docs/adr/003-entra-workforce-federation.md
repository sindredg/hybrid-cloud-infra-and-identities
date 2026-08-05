# ADR-003: Use Entra ID for human access to GCP

**Status:** Proposed  
**Date:** 2026-08-05  
**Deciders:** Repository owner

## Context

Entra ID is the existing central human identity provider. Creating separate Google
users would duplicate lifecycle, access review and sign-in controls.

## Decision

Use GCP Workforce Identity Federation with Entra ID for human console and CLI
access. Map approved Entra groups to least-privilege GCP roles.

## Options considered

| Option | Identity lifecycle | Licensing dependency | Administration |
|---|---:|---:|---:|
| Workforce federation | Centralised | Must be confirmed | Moderate setup |
| Cloud Identity users | Duplicated | Separate service | Higher ongoing effort |
| Service accounts for people | Unsafe | None | Not acceptable |

## Consequences

- Joiner, mover and leaver controls stay centred on Entra.
- Group claims, tenant details and sign-in policy need validation.
- Workforce federation remains separate from GitHub workload federation.

## Action items

1. Confirm tenant, domain, licences and approved groups.
2. Define break-glass and access-review procedures.
3. Test console and CLI sign-in before wider assignment.

