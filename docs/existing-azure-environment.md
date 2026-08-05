# Existing Azure environment

This document records facts found in the local copy of the existing Azure
repository. The implementation and its detailed evidence remain in the
[two-site hybrid identity repository](https://github.com/sindredg/two-site-hybrid-identity-).

See the [end-to-end hybrid architecture](architecture/hybrid.md) for how these
Azure and Microsoft Entra components relate to the GCP foundation and proposed
cross-cloud controls.

## Evidence summary

| Area | Repository evidence | Cross-cloud constraint |
|---|---|---|
| HQ network | Sweden Central, `vnet-hybridid`, `10.10.0.0/16` | GCP must not overlap this range. |
| HQ subnets | Workload `10.10.1.0/24`; Bastion `10.10.2.0/26` | A later VPN design needs a separately approved Azure gateway subnet. |
| Branch network | Denmark East, `vnet-branch`, `10.20.0.0/16`; workload subnet `10.20.1.0/24` | GCP must not overlap this range. |
| Azure connectivity | Bidirectional global VNet peering | Peering is Azure-internal and cannot provide cross-cloud connectivity. |
| Directory services | `DC01` at `10.10.1.4` provides AD DS and DNS | Domain-dependent GCP workloads need approved routes and DNS forwarding. |
| Synchronisation | `CS01` at `10.10.1.5` runs Entra Connect Sync | Entra ID remains the central human identity provider. |
| Endpoints | `CL01` and `CL02` at `10.20.1.4` and `.5` | They demonstrate hybrid join, policy and separate LAPS backends. |
| Administration | Azure Bastion Basic; no VM public IPs | Do not introduce public management endpoints in GCP. |
| Network security | RDP allowed from Azure's `VirtualNetwork` service tag | Future cross-cloud rules must use explicit CIDRs and workload targets. |
| Cost controls | HQ shutdown schedules; branch deallocated manually | GCP compute must use explicit lifecycle controls when introduced. |

The Terraform state inspected during discovery recorded four
`Standard_B2ls_v2` Windows VMs, static private addresses, no VM public IPs, and
Secure Boot and vTPM disabled. Local state is not part of this repository and must
not be published.

## Identity boundary

The environment uses Active Directory architecture patterns normally found in an
enterprise datacentre, but the directory servers are hosted in Azure. It must not
be described as physically on-premises.

The Azure documentation records Entra Connect password-hash synchronisation,
hybrid Entra join, Group Policy, Microsoft security baselines and Windows LAPS.
These are operational documentation claims rather than resources managed by the
Azure Terraform roots. Live verification is required before using them as rollout
evidence.

## Missing live confirmations

- Entra tenant ID, verified domain and groups intended for GCP access
- Current Azure and Entra health and drift from local Terraform state
- Azure gateway subnet, VPN SKU, availability-zone support and throughput target
- Final cross-cloud DNS forwarding and failure behaviour
- Routes and ports required by the first real GCP workload
- Recovery objectives and authoritative backup locations

The GCP reservation is `10.30.0.0/16`, beginning with `10.30.1.0/24`. It does not
overlap either recorded Azure VNet.
