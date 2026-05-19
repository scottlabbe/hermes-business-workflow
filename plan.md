# Hermes Business Workflow Readiness Checklist

This checklist tracks the durable project shape after aligning the repo around the existing `audit/` and `program_management/` workspaces.

## Current Structure

```text
hermes-business-workflow/
  README.md
  AGENTS.md
  .gitignore
  docs/
  shared/templates/
  audit/
    AGENTS.md
    data-reliability/
    variance_explainer/
  program_management/
    AGENTS.md
    cost-reports/
```

## Completed Cleanup

- Root instructions point to `audit/...` and `program_management/...`.
- Root README explains the public-safe Hermes demo purpose.
- Root `.gitignore` protects secrets, local junk, caches, and generated run/workpaper outputs.
- Audit workspace has workspace-level instructions and README.
- Data Reliability docs use `runs/<run_id>/` and require `run_summary.md`.
- Variance Explainer docs use `runs/<run_id>/outputs/tb_variance_analysis.xlsx` and require `run_summary.md`.
- Program Management workspace has starter instructions and README.
- Shared `run_summary.md` template exists.
- Copied nested git metadata and local generated-output residue have been removed.

## Remaining Before Public Release

- Confirm whether each included dataset is synthetic or public-source data that is appropriate to redistribute.
- Add source URLs, licenses, and retrieval dates in `docs/data_sources.md` for retained public datasets.
- Add a dedicated `program_management/cost-reports/AGENTS.md` before demonstrating the cost-report workflow.
- Run one fresh Data Reliability example and one fresh Variance Explainer example so each has a current `run_summary.md`.
