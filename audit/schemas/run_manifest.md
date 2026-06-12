# Stage Metadata Handoff Schema

This file replaces the older standalone `manifest.json` workflow-memory pattern.

By default, do not create a separate run manifest. Each numbered stage writes exactly two durable output files in its stage folder:

```text
<primary_workbook>.xlsx
<stage_metadata>.json
```

The metadata JSON is the workflow memory for that stage. Later stages read the prior stage metadata and use its `downstream_handoffs` object.

## Required Stage Metadata Fields

Every stage metadata JSON should include:

```json
{
  "run_id": "2026-06-01_la_checkbook",
  "stage_id": "01_data_reliability",
  "skill": "data-reliability",
  "status": "completed_with_limitations",
  "artifacts_written": [
    "01_data_reliability/data_reliability.xlsx",
    "01_data_reliability/data_reliability_metadata.json"
  ],
  "checks_performed": [],
  "limitations": [],
  "human_review_needed": [],
  "downstream_handoffs": {},
  "workflow_stages": []
}
```

Allowed `status` values:

- `completed`
- `completed_with_limitations`
- `blocked`
- `failed_but_artifacts_written`

## Workflow Stage Pointers

Use `workflow_stages` to preserve a compact run index without a separate manifest:

```json
[
  {
    "stage_id": "01_data_reliability",
    "skill": "data-reliability",
    "status": "completed_with_limitations",
    "output": "01_data_reliability/data_reliability.xlsx",
    "metadata": "01_data_reliability/data_reliability_metadata.json"
  },
  {
    "stage_id": "02_expense-sample",
    "skill": "expense-sample",
    "status": "completed_with_limitations",
    "output": "02_expense-sample/sample_selection.xlsx",
    "metadata": "02_expense-sample/sample_metadata.json"
  }
]
```

Each later stage should carry forward prior stage pointers and append itself.

## Transaction Sampling Handoff

Data reliability metadata should expose transaction sampling input as:

```json
{
  "downstream_handoffs": {
    "expense_sample": {
      "ready_for_sampling": true,
      "file": "01_data_reliability/data_reliability.xlsx",
      "sheet": "Source File",
      "record_count": 38951,
      "key_fields": ["Vendor", "Amount"],
      "limitations": [
        "Outputs are data reliability observations and do not conclude the data is reliable."
      ]
    }
  }
}
```

For R&D-specific sampling, use `r_and_d_expense_sample` when useful. The R&D sampling skill may fall back to `expense_sample`.

## Trial Balance Variance Handoff

Data reliability metadata should expose variance analysis input as:

```json
{
  "downstream_handoffs": {
    "variance_analysis": {
      "ready_for_variance_analysis": true,
      "prior_year": {
        "input_id": "prior_year",
        "file": "01_data_reliability/data_reliability.xlsx",
        "sheet": "prior_year_Source",
        "record_count": 247,
        "source_file": "00_source/FY25 TB.csv"
      },
      "current_year": {
        "input_id": "current_year",
        "file": "01_data_reliability/data_reliability.xlsx",
        "sheet": "current_year_Source",
        "record_count": 247,
        "source_file": "00_source/FY26 TB.csv"
      },
      "limitations": []
    }
  }
}
```

The variance stage must use these exact file and sheet pointers unless the user explicitly overrides them.

## Summary Location

Do not write a separate `run_summary.md` by default. Human-readable summaries belong in the workbook `Summary` sheet. Machine-readable summaries, checks, limitations, human review items, and handoffs belong in the stage metadata JSON.
