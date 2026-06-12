# Trial Balance Variance Analysis Workflow

Use this workflow when the user provides prior-year and current-year trial balance files and wants variance analysis support.

The workflow produces review aids and data reliability observations. It does not produce final audit, compliance, legal, financial, or management conclusions.

## Required Instructions

Read these files before running the workflow:

1. `AGENTS.md`
2. `schemas/run_manifest.md`
3. `skills/data-reliability/SKILL.md`
4. `skills/variance-explainer/SKILL.md`

## Intake

Expected job folder:

```text
inbox/<job_id>/
  request.md
  source/
    <prior_year_trial_balance>.xlsx
    <current_year_trial_balance>.xlsx
```

CSV and TSV files are also supported when the columns can be detected by the skills. A key-fields config is optional for this workflow.

## Workflow Steps

1. Select the requested `inbox/<job_id>/` folder.
2. Validate that `request.md` and the two source trial balance files exist.
3. Create `runs/YYYY-MM-DD_<job_id>/`.
4. Copy source files to `00_source/`.
5. Run the data reliability skill into `01_data_reliability/`, processing both trial balance files in the same stage.
6. Confirm `01_data_reliability/data_reliability_metadata.json` includes `downstream_handoffs.variance_analysis` with `prior_year` and `current_year` pointers.
7. Run the variance explainer skill into `02_variance_analysis/` using those metadata handoffs.
8. Confirm `02_variance_analysis/variance_analysis_metadata.json` includes the final workbook handoff, checks performed, limitations, human review needed, and workflow stage pointers.

## Data Reliability Handoff Requirement

The data reliability stage must identify the exact generated workbook file and sheet for each trial balance. The variance stage must not guess among sheets. It must read `downstream_handoffs.variance_analysis` from `01_data_reliability/data_reliability_metadata.json` unless the user explicitly overrides it.

Use stable input ids:

- `prior_year`
- `current_year`

If the file roles cannot be inferred safely from request text or file names, stop and write blocked metadata asking the user to identify the prior-year and current-year files.

## Final Outputs

The completed run should contain:

```text
runs/YYYY-MM-DD_<job_id>/
  00_source/
  01_data_reliability/
    data_reliability.xlsx
    data_reliability_metadata.json
  02_variance_analysis/
    variance_analysis.xlsx
    variance_analysis_metadata.json
```

The final response to the user should identify:

- run folder created
- Excel workbooks created
- metadata files created
- checks performed
- limitations
- human review needed

Do not state that the variance explanations are final audit conclusions. State that they are draft variance-analysis review aids and follow-up question support.
