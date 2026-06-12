# Data Reliability Skill

## Purpose

This skill performs a data readiness review for one or more source Excel workbooks or delimited text files in a single job folder.

The skill creates factual, inspectable review artifacts that help a human understand parsing issues, missing requested fields, blank values, duplicate rows, parse failures, unnamed columns, and other bounded data reliability observations that may affect later review or sampling work.

The output is not a final audit conclusion, compliance conclusion, legal conclusion, financial conclusion, or data-quality verdict.

## Operating Model

Treat each immediate subdirectory under `inbox/` as one job-specific intake folder.

Create a timestamped run folder under `runs/`, such as:

```text
runs/2026-06-01_{job_id}/
```

Each run processes exactly one inbox job folder. Do not aggregate, compare, or merge results across job folders. Within one job folder, process all source files needed by the requested workflow as part of the same data reliability stage.

Prefer straightforward, inspectable generated logic over abstraction-heavy framework design. Record the method used in `data_reliability_metadata.json`.

## Input Contract

Expected single-file intake:

```text
inbox/
  <job_id>/
    request.md
    source/
      <dataset>.xlsx
      key_fields.yaml
```

CSV and TSV source files are also supported:

```text
inbox/
  <job_id>/
    request.md
    source/
      <dataset>.csv
      key_fields.yaml
```

Expected multi-file intake, such as trial balance variance analysis:

```text
inbox/
  <job_id>/
    request.md
    source/
      FY25 TB.csv
      FY26 TB.csv
      optional_config.yaml
```

Required behavior:

- The inbox directory name is the `job_id`.
- The job folder must contain exactly one `request.md` file.
- The job folder must contain one `source/` folder.
- The `source/` folder must contain one or more non-hidden source datasets: `.xlsx`, `.csv`, or `.tsv`.
- A `.yaml` or `.yml` key-fields config is required for sampling workflows unless the request explicitly provides equivalent key-field instructions. It is optional for variance workflows where the next stage needs reviewed prior-year and current-year tables rather than sampling key fields.
- Hidden or system files such as `.DS_Store` must be ignored for intake validation.
- Do not modify files in `inbox/`.

Current implementation scope:

- Excel `.xlsx`, CSV `.csv`, and TSV `.tsv` datasets.
- YAML key-fields config.
- For Excel files, one workbook sheet by default, or one selected sheet if the config explicitly names it.
- For CSV and TSV files, one parsed table named `Source File`; ignore `sheet_name` if it is omitted, and document a limitation if `sheet_name` is supplied because delimited files do not have workbook sheets.
- Requested key-field profiling when key fields are supplied. For variance workflows without key fields, profile source shape, parse status, row count, column count, duplicate rows, blank headers, and expected variance columns when identifiable.

Out of scope:

- Multi-file joins or variance calculations.
- Final audit conclusions.
- Cross-field validation.
- Full non-key-field profiling.
- Data reliability scoring.
- Severity assignments.
- Reliable/unreliable conclusions.

## Key-Fields Config

Expected shape:

```yaml
dataset_file: example.xlsx
sheet_name: Sheet1
key_fields:
  - Vendor
  - Amount
```

For CSV:

```yaml
dataset_file: example.csv
key_fields:
  - Vendor
  - Amount
```

`sheet_name` is optional for Excel. If omitted and the workbook has one sheet, use that sheet. If omitted and the workbook has multiple sheets, stop and write blocked metadata that asks the user to identify the sheet.

For CSV or TSV, `sheet_name` is not required. Treat the parsed table as `Source File` for downstream handoff.

For multi-file jobs, use the request text and file names to assign stable `input_id` values such as `prior_year`, `current_year`, or `population`. If the roles cannot be inferred safely, write blocked metadata asking the user to identify each file's role.

## Required Output Folder

Write outputs to:

```text
runs/<run_id>/01_data_reliability/
```

Required artifacts:

```text
data_reliability.xlsx
data_reliability_metadata.json
```

`data_reliability.xlsx` is the human review aid. `data_reliability_metadata.json` is the supporting machine-readable file for run metadata, artifact metadata, checks, limitations, and downstream handoff.

Do not create any other durable files in `01_data_reliability/`.

## Workbook Contract

For a single source file, create `data_reliability.xlsx` with these sheets in this order:

1. `Summary`
2. `Source File`
3. `Key Field Profile`

For a multi-source job, create one set of source/profile sheets per input using stable short sheet names, plus a consolidated `Summary` and `Handoff` sheet. Example:

1. `Summary`
2. `Handoff`
3. `prior_year_Source`
4. `prior_year_Profile`
5. `current_year_Source`
6. `current_year_Profile`

Keep Excel sheet names at or below 31 characters.

### `Summary`

Include:

- source file
- source sheet/table
- row count
- column count
- requested key fields
- missing requested key fields
- duplicate row count
- checks performed
- data reliability observations
- limitations
- human review needed
- downstream handoff file and sheet

Use review-aid language. Do not conclude the data is reliable or unreliable.

Include one clearly labeled `Model judgment` note. The note must be bounded, evidence-based, and tied to computed facts.

### Source Sheets

Include each source sheet or parsed delimited table used for review.

Default: preserve the full parsed source sheet or table. If the source would be too large for a practical demo artifact, include the first practical set of source rows and document that limitation in `Summary` and `data_reliability_metadata.json`.

### Profile Sheets

Include one row per requested key field, including missing fields. If no key fields were provided for a variance workflow, include one row per expected variance-analysis field when identifiable, or one row per source column for basic shape profiling.

Required columns:

1. `field_name`
2. `field_present`
3. `inferred_type`
4. `inference_confidence`
5. `nonblank_count`
6. `blank_count`
7. `blank_percent`
8. `distinct_count`
9. `duplicate_value_count`
10. `parse_failure_count`
11. `min_value`
12. `max_value`
13. `sample_values`
14. `issue_flags`
15. `ambiguity_notes`

`sample_values` should be a JSON array encoded as text.

## Metadata Contract

Create `data_reliability_metadata.json` with this shape:

```json
{
  "run_id": "2026-06-01_la_checkbook",
  "stage_id": "01_data_reliability",
  "skill": "data-reliability",
  "status": "completed_with_limitations",
  "inputs": [
    {
      "input_id": "population",
      "source_file": "00_source/example.xlsx",
      "source_format": "xlsx",
      "source_sheet_or_table": "Sheet1",
      "reviewed_output_file": "01_data_reliability/data_reliability.xlsx",
      "reviewed_output_sheet": "Source File",
      "row_count": 0,
      "column_count": 0,
      "requested_key_fields": [],
      "missing_requested_key_fields": [],
      "duplicate_row_count": 0,
      "unnamed_or_blank_header_columns": {
        "present": false,
        "columns": []
      },
      "field_results": []
    }
  ],
  "parser_used": "pandas/openpyxl",
  "method": "generated Python analysis run from project virtual environment",
  "artifacts_written": [
    "01_data_reliability/data_reliability.xlsx",
    "01_data_reliability/data_reliability_metadata.json"
  ],
  "parsing_succeeded": true,
  "checks_performed": [],
  "limitations": [],
  "human_review_needed": [],
  "downstream_handoffs": {
    "expense_sample": {
      "ready_for_sampling": true,
      "file": "01_data_reliability/data_reliability.xlsx",
      "sheet": "Source File",
      "record_count": 0,
      "key_fields": [],
      "limitations": []
    },
    "r_and_d_expense_sample": {
      "ready_for_sampling": true,
      "file": "01_data_reliability/data_reliability.xlsx",
      "sheet": "Source File",
      "record_count": 0,
      "key_fields": [],
      "limitations": []
    },
    "variance_analysis": {
      "ready_for_variance_analysis": false,
      "prior_year": null,
      "current_year": null,
      "limitations": []
    }
  },
  "workflow_stages": [
    {
      "stage_id": "01_data_reliability",
      "skill": "data-reliability",
      "status": "completed_with_limitations",
      "output": "01_data_reliability/data_reliability.xlsx",
      "metadata": "01_data_reliability/data_reliability_metadata.json"
    }
  ]
}
```

Allowed stage statuses:

- `completed`
- `completed_with_limitations`
- `blocked`
- `failed_but_artifacts_written`

## Downstream Handoffs

Do not create or update a separate `manifest.json` by default. Write downstream handoff information to `data_reliability_metadata.json`.

For transaction sampling, use this shape under `downstream_handoffs.expense_sample` or `downstream_handoffs.r_and_d_expense_sample`:

```json
{
  "ready_for_sampling": true,
  "file": "01_data_reliability/data_reliability.xlsx",
  "sheet": "Source File",
  "record_count": 38951,
  "key_fields": ["Vendor", "Amount"],
  "limitations": [
    "Outputs are data reliability observations and do not conclude the data is reliable."
  ]
}
```

If parsing fails or required sampling fields are missing, set:

```json
{
  "ready_for_sampling": false,
  "file": null,
  "sheet": null,
  "record_count": null,
  "key_fields": [],
  "limitations": []
}
```

For trial balance variance analysis, use this shape under `downstream_handoffs.variance_analysis`:

```json
{
  "ready_for_variance_analysis": true,
  "prior_year": {
    "input_id": "prior_year",
    "file": "01_data_reliability/data_reliability.xlsx",
    "sheet": "prior_year_Source",
    "record_count": 0,
    "source_file": "00_source/FY25 TB.csv"
  },
  "current_year": {
    "input_id": "current_year",
    "file": "01_data_reliability/data_reliability.xlsx",
    "sheet": "current_year_Source",
    "record_count": 0,
    "source_file": "00_source/FY26 TB.csv"
  },
  "limitations": []
}
```

## Required Checks

Perform and document:

- intake folder shape
- source datasets exist
- key-fields config exists when required by the requested workflow
- source dataset parse success or failure for each input
- source format for each input
- selected sheet for Excel, or parsed table name for CSV/TSV, for each input
- row count for each input
- column count for each input
- requested key fields present or missing when supplied
- duplicate row count for each input
- unnamed or blank-header columns for each input
- blank counts for requested key fields when supplied
- duplicate nonblank values for requested key fields when supplied
- numeric parse failures for amount-like fields when supplied or identifiable
- date parse failures for date-like fields when supplied or identifiable
- output workbook contains all required sheets
- metadata records the output workbook and downstream handoff

For CSV and TSV files, perform and document:

- delimiter used
- encoding used or inferred
- whether a UTF-8 BOM was present
- malformed row handling, if any rows could not be parsed cleanly
- whether all requested key fields matched the parsed header exactly, including case

Missing requested fields must still receive a row in `Key Field Profile`.

If parsing fails, write available artifacts where practical and mark the stage `failed_but_artifacts_written`.

## Writing Rules

- Use `review aid`, `data reliability observations`, `source data used for review`, and `human review needed`.
- Do not use `valid`, `invalid`, `reliable`, `unreliable`, or `audit conclusion` except to say those conclusions are not being made.
- Do not assign severity levels.
- Do not score dataset quality.
- Do not invent unsupported findings in prose.
- Base factual statements on computed artifacts.
- Preserve uncertainty and ambiguity.

## Human Review Needed

The workbook `Summary` sheet and metadata file must identify what a human should inspect before relying on later review or sampling outputs, including:

- missing or blank-heavy key fields
- amount/date parsing issues
- source parsing limitations
- limitations a reviewer should consider
- whether the source data used for review is appropriate for the intended sampling purpose
