# ADR-007: Put cost controls before workloads

**Status:** Proposed  
**Date:** 2026-08-05  
**Deciders:** Repository owner

## Context

The project has NOK 2,900 in trial credits. Budgets provide warnings but do not
stop consumption. Paid always-on services require explicit review.

## Decision

Create a NOK 1,000 monthly budget with 50, 75 and 90 percent actual-spend alerts.
Deploy only state, identity and an empty custom VPC in the baseline. Require cost
and cleanup notes for every later module.

## Options considered

| Option | Warning time | Experiment room | Credit risk |
|---|---:|---:|---:|
| NOK 1,000 | Moderate | High | Moderate |
| NOK 500 | Earlier | Moderate | Lower |
| No budget | None | Unbounded | High |

## Consequences

- Spending becomes visible before workload rollout.
- Alerts require monitored recipients and still need human response.
- Compute must be stopped or deleted when tests finish.

## Action items

1. Verify billing currency and notification delivery.
2. Review actual spend after each experiment.
3. Keep VPN, NAT, GKE and managed security behind approval gates.

