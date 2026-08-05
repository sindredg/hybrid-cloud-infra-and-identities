# gcp-cost-governance

Creates one project-filtered monthly Cloud Billing budget. The default is NOK
1,000 with actual-spend thresholds at 50, 75 and 90 percent. A budget is a warning
mechanism, not a spending cap.

The billing account currency must be confirmed before apply. Optional notification
channels must already exist; creating communication channels is intentionally
outside this module.

