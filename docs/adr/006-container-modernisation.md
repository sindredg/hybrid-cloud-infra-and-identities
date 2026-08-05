# ADR-006: Defer the container platform

**Status:** Proposed  
**Date:** 2026-08-05  
**Deciders:** Repository owner

## Context

The target architecture must cover containers, but no workload assessment yet
justifies an always-on cluster or defines orchestration requirements.

## Decision

Deploy no container platform in the foundation. Prefer Cloud Run for suitable
stateless services. Consider GKE only when a workload requires Kubernetes APIs,
cluster-level controls or portability that outweighs its operational cost.

## Options considered

| Option | Operations | Capability | Baseline cost |
|---|---:|---:|---:|
| Cloud Run later | Low | Managed stateless workloads | Usage-based |
| GKE later | High | Full Kubernetes | Higher |
| GKE in foundation | High | Unused capacity | Not justified |

## Consequences

- The baseline remains cheap and understandable.
- Container-specific network ranges are reserved only when requirements exist.
- Modernisation decisions depend on an application assessment.

## Action items

1. Inventory candidate workloads and dependencies.
2. Compare Cloud Run and GKE against measurable requirements.

