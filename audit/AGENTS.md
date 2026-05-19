# Audit Workspace Instructions

This workspace contains public-safe Hermes workflows for audit-style review work.

## Scope

Use this workspace for:
- data reliability checks
- trial balance variance explanation
- reconciliation support
- sampling support
- evidence extraction
- finding development

Use the most specific workflow folder available:
- `audit/data-reliability/` for CSV key-field reliability profiling
- `audit/variance_explainer/` for prior-year vs current-year trial balance variance workbooks

## Public-Safe Audit Boundary

Do not use private client data, confidential employer records, private emails, credentials, or production databases.

Use synthetic data or public data that is appropriate to redistribute. Document public data sources and synthetic-data assumptions.

## Output Rules

Save meaningful workflow outputs under the selected audit workflow's `runs/` folder unless that workflow defines a more specific subfolder inside `runs/`.

Each meaningful run must include `run_summary.md` covering:
- task attempted
- inputs used
- outputs created
- checks performed
- limitations
- human review needed
- suggested improvements

## Human Review

Do not present outputs as final audit, compliance, legal, financial, or management conclusions. Use bounded language and identify what a qualified human should review.
