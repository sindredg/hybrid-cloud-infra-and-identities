# Architecture documentation

These documents separate the implemented GCP foundation from the intended
multi-cloud end state.

| View | Purpose |
|---|---|
| [GCP architecture](gcp.md) | GCP project boundaries, Terraform state, automation identity, cost controls and the prepared network layer |
| [Hybrid architecture](hybrid.md) | End-to-end identity, network, DNS and automation boundaries across Azure, Microsoft Entra ID, GitHub and GCP |

Status language is deliberate:

- **Deployed** means the component was created and validated in the environment.
- **Prepared** means Terraform exists and passes repository checks but has not been applied.
- **Proposed** means the design is documented but no implementation should be inferred.

The [ADRs](../adr/README.md) hold individual decisions and trade-offs. These
architecture views explain how those decisions fit together.
