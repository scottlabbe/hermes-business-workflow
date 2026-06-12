# Expense Sample Skill

## Purpose

This skill creates a documented expense transaction sample review aid from the source table identified by the data reliability stage.

The skill is designed for general expense populations. It does not assume an R&D program, grant type, vendor concentration filter, or other audit scope filter unless the user explicitly provides one.

The output is not a final audit conclusion, statistical sampling conclusion, compliance conclusion, legal conclusion, financial conclusion, or management conclusion.

## Input Contract

Read the prior stage metadata JSON, normally `runs/<run_id>/01_data_reliability/data_reliability_metadata.json`, and use `downstream_handoffs.expense_sample`. If the request explicitly identifies another metadata file or input workbook, use that override and document it.

Required sampling handoff fields:

- `ready_for_sampling`
- `file`
- `sheet`
- `record_count`
- `key_fields`
- `limitations`

Default file:

```text
01_data_reliability/data_reliability.xlsx
```

Default sheet:

```text
Source File
```

If `ready_for_sampling` is not `true`, stop and write the metadata file with status `blocked` and a plain-English reason.

If the input workbook or input sheet is missing, stop and write the metadata file with status `blocked` and a plain-English reason.

The input table must contain at least one row and one column. No expense category, vendor, program, or amount field is required unless the user has requested a filter or stratification that depends on that field.

Optional fields to preserve when available:

- `Department`
- `Agency`
- `Category`
- `Type`
- `Vendor`
- `Funding Type`
- `Invoice`
- `Posting Date/FiscalYear`
- `Amount`

## Default Parameters

Use these defaults unless the user specifies otherwise:

- sample size: `60`
- random seed: `20260601`
- population: all rows in the input sheet
- selection method: Python standard-library random sample without replacement

Do not filter the population by vendor, amount, category, funding type, program, or description unless the user explicitly requests that filter.

If the input population contains fewer records than the requested sample size, select all records and document the limitation in the metadata file.

## Reproducibility Contract

A reviewer must be able to recreate the same sample from the same input workbook, sheet, and sampling parameters.

Use this default method unless the user explicitly requests another method:

1. Read the input sheet while preserving workbook row order.
2. Add `Source Row Number`, using the worksheet row number for each data record. If the source format does not expose worksheet row numbers, use the 1-based data row position and document that choice.
3. Add `Population Sequence`, numbered `1` through `N` after applying the population definition. For the default unfiltered population, this is the original input row order.
4. Set `sample_size_selected` to the smaller of the requested sample size and the input record count.
5. Use Python standard-library sampling exactly as:

```python
import random

rng = random.Random(random_seed)
selected_population_sequences = rng.sample(
    range(1, input_record_count + 1),
    sample_size_selected
)
```

6. Select records whose `Population Sequence` appears in `selected_population_sequences`.
7. Assign `Sample Sequence` as `1` through `sample_size_selected` in the draw order returned by `rng.sample(...)`.

Do not use `pandas.DataFrame.sample`, `numpy.random`, spreadsheet volatile random functions, manual row picking, or an undocumented random method.

The workbook and metadata must preserve enough information to recreate the sample:

- source workbook and sheet
- source file hash when practical
- sample size requested and selected
- random seed
- Python sampling method
- population definition
- source row number
- population sequence
- sample sequence
- selected population sequences

## Required Output Folder

Write outputs to:

```text
runs/<run_id>/02_expense-sample/
```

The stage id used in output paths must match the workflow sequence and the `stage_id` recorded in `sample_metadata.json`.

## Required Artifacts

Create only:

```text
sample_selection.xlsx
sample_metadata.json
```

`sample_selection.xlsx` is the human review aid. `sample_metadata.json` is the supporting machine-readable file for run metadata, artifact metadata, checks, limitations, and downstream handoff.

## Workbook Contract

Create `sample_selection.xlsx` with these sheets in this order:

1. `Summary`
2. `Input Data`
3. `Sampled Records`

### `Summary`

Include:

- source workbook and sheet
- input record count
- sample size requested
- sample size selected
- random seed
- population definition
- selection method
- reproducibility method
- selected population sequences
- checks performed
- limitations
- human review needed

Use review-aid language. Do not state that the sample is sufficient for audit purposes.

### `Input Data`

Include the exact input table used for sampling, with helper columns clearly labeled if any are added.

If the table is too large for a practical workbook, include the first practical set of source rows and document that limitation in `Summary` and `sample_metadata.json`.

### `Sampled Records`

Include the sampled rows from the full input population.

Add:

- `Source Row Number`
- `Population Sequence`
- `Sample Sequence`
- `Selection Method`
- `Random Seed`
- `Sampling Notes`

The default selection method is Python standard-library random sampling using the documented seed and population sequence.

## Metadata Contract

Create `sample_metadata.json` with this shape:

```json
{
  "run_id": "2026-06-01_la_checkbook",
  "stage_id": "02_expense-sample",
  "skill": "expense-sample",
  "status": "completed_with_limitations",
  "source_input": {
    "file": "01_data_reliability/data_reliability.xlsx",
    "sheet": "Source File",
    "sha256": null,
    "metadata_file": "01_data_reliability/data_reliability_metadata.json",
    "handoff_key": "expense_sample"
  },
  "artifacts_written": [
    "02_expense-sample/sample_selection.xlsx",
    "02_expense-sample/sample_metadata.json"
  ],
  "parameters": {
    "sample_size_requested": 60,
    "random_seed": 20260601,
    "population_definition": "all rows in source sheet",
    "selection_method": "python_random_sample_without_replacement",
    "selection_algorithm": "random.Random(random_seed).sample(range(1, input_record_count + 1), sample_size_selected)"
  },
  "counts": {
    "input_record_count": 0,
    "sample_size_selected": 0
  },
  "reproducibility": {
    "source_order_basis": "workbook row order",
    "source_row_number_basis": "worksheet row number",
    "population_sequence_basis": "1-based order after applying population definition",
    "selected_population_sequences": [],
    "selected_source_row_numbers": []
  },
  "checks_performed": [],
  "limitations": [],
  "human_review_needed": [],
  "downstream_handoffs": {
    "sample_review": {
      "file": "02_expense-sample/sample_selection.xlsx",
      "sheet": "Sampled Records"
    }
  },
  "workflow_stages": [
    {
      "stage_id": "01_data_reliability",
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
}
```

## Required Checks

Before writing final outputs, perform and document:

- prior stage metadata exists
- `downstream_handoffs.expense_sample` is present, unless the user explicitly supplied another input
- `ready_for_sampling` is `true`
- input file exists
- input sheet exists
- input row count is greater than zero
- selected records come from the input population
- selected sample count equals requested sample size unless the population is smaller
- random seed is recorded
- Python standard-library random sample method is recorded
- output workbook contains all required sheets
- metadata records the output workbook and downstream handoff

If a required check fails, still write `sample_metadata.json` when practical and mark the stage `blocked` or `failed_but_artifacts_written` with clear human review guidance.

## Writing Rules

- Use `review aid`, `sample selection support`, and `human review needed`.
- Do not use `final sample`, `audit conclusion`, `statistically valid`, or `sufficient appropriate evidence`.
- Do not imply selected records are representative of the population unless a statistical sampling method was explicitly requested and implemented.
- Preserve relevant limitations from the data reliability stage.
