# ADR-001: Connect Azure and GCP with HA VPN

**Status:** Proposed  
**Date:** 2026-08-05  
**Deciders:** Repository owner

## Context

Azure contains `10.10.0.0/16` and `10.20.0.0/16`. GCP needs private, routed
connectivity without treating Azure VNet peering as a cross-cloud mechanism. Cost
and approval constraints prohibit deploying always-on VPN resources in the baseline.

## Decision

After a separate approval, use redundant Azure VPN Gateway and GCP HA VPN with
Cloud Router and BGP. Keep the first foundation milestone network-only.

## Options considered

| Option | Resilience | Cost | Operational fit |
|---|---:|---:|---|
| HA VPN with BGP | High | Always-on | Preferred production-shaped design |
| Single classic tunnel | Low | Lower | Useful only for a disposable test |
| Public endpoints | Low | Variable | Conflicts with the private-access objective |

## Consequences

- Routing can fail over and advertise only approved prefixes.
- VPN gateways create continuous charges and need a later cost review.
- Azure requires a gateway subnet and both clouds need tested route and firewall policy.

## Action items

1. Confirm Azure gateway constraints and GCP VPN region.
2. Define BGP ASN and advertised prefixes.
3. Approve cost before creating either gateway.

