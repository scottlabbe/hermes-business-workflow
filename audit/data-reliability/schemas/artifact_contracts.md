# Artifact Contracts

This file defines strict output contracts for each analysis run.

## Run Intake Contract

The intake unit for one analysis run is one immediate subdirectory under `inbox/`.

Required behavior:
- the inbox directory name is the `run_id`
- each run folder must contain exactly one CSV dataset file
- each run folder must contain exactly one YAML key-fields config file
- hidden or system files such as `.DS_Store` must be ignored for intake validation
- one analysis run processes one run folder
- do not aggregate, compare, or merge results across run folders

## Run Folder Contract

Each run must write artifacts to `runs/<run_id>/`.

Required layout:

```text
runs/
  <run_id>/
    run_summary.md
    work/
      generated_analysis.py
    outputs/
      field_results.csv
      dataset_summary.json
      reliability_report.md
      run_manifest.json
```

Required behavior:
- `run_id` must exactly match the source run folder name from `inbox/`.
- `work/` must contain the generated analysis code used by the run.
- `outputs/` must contain all required output artifacts, including `run_manifest.json`.
- `run_summary.md` must summarize the task, inputs, outputs, checks, limitations, human review needed, and suggested improvements.
- if `runs/<run_id>/` already exists, the run must overwrite prior generated contents under `work/` and `outputs/`.
- the run must not copy source input files into `runs/<run_id>/`.

## `outputs/field_results.csv`

### Row contract
- One row per requested key field from the config.
- Missing requested fields must still receive a row.
- Parse-failure runs must still emit one row per requested field with placeholders.

### Fixed column order

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

### Column rules
- `inferred_type` must be one of: `identifier`, `numeric`, `date`, `categorical`, `boolean`, `text`, `mixed`, `unknown`.
- `inference_confidence` must be a numeric value from `0` to `1` when available.
- Count columns must be non-negative integers when available.
- `sample_values` must be a JSON array encoded as text.
- `issue_flags` must be a delimiter-separated list or empty.
- `ambiguity_notes` must explain unknown, unavailable, or non-applicable values.
- Missing or non-applicable values must be represented as empty values plus explanation in `ambiguity_notes`.

## `outputs/dataset_summary.json`

Required top-level keys:
- `parsing_succeeded`
- `parser_used`
- `row_count`
- `column_count`
- `missing_requested_key_columns`
- `duplicate_row_count`
- `parsing_issues`
- `unnamed_or_blank_header_columns`

Type and value rules:
- `parsing_succeeded`: boolean.
- `parser_used`: string.
- `row_count`: integer or `null`.
- `column_count`: integer or `null`.
- `missing_requested_key_columns`: array of strings.
- `duplicate_row_count`: integer or `null`.
- `parsing_issues`: array of strings, empty array when none.
- `unnamed_or_blank_header_columns`: object with required keys:
  - `present` (boolean)
  - `summary` (string)
  - `columns` (array)

`unnamed_or_blank_header_columns.columns` entries must be objects with:
- `column_label` (string)
- `has_data` (boolean)
- `nonblank_count` (integer)
- `sample_values` (array)

Parse-failure rule:
- `row_count`, `column_count`, and `duplicate_row_count` must be `null` when unavailable due to parse failure.

## `outputs/run_manifest.json`

Required top-level keys:
- `run_id`
- `run_timestamp`
- `dataset_file`
- `key_fields_file`
- `artifacts_written`
- `analysis_code_path`
- `overwrote_existing_run`
- `status`

Type and value rules:
- `run_id`: source inbox folder name as a string.
- `run_timestamp`: ISO-like timestamp string used by the run.
- `dataset_file`: source dataset filename read from `inbox/<run_id>/`.
- `key_fields_file`: source key-fields filename read from `inbox/<run_id>/`.
- `artifacts_written`: array of relative artifact paths written by the run, including paths under `work/` and `outputs/`.
- `analysis_code_path`: relative path to generated analysis code under `work/`.
- `overwrote_existing_run`: boolean indicating whether a previous `runs/<run_id>/` directory existed and was overwritten.
- `status`: one of `completed`, `completed_with_limitations`, `failed_to_parse_but_artifacts_written`.

## `run_summary.md`

The run summary must include these headings:
- `Task Attempted`
- `Inputs Used`
- `Outputs Created`
- `Checks Performed`
- `Limitations`
- `Human Review Needed`
- `Suggested Improvements`

## Parse-Failure Artifact Requirements

When parsing fails, the run must still write:
- `outputs/field_results.csv` with one placeholder row per requested key field
- `outputs/dataset_summary.json` with parse failure facts and required null placeholders
- `outputs/reliability_report.md` with factual failure description and limitations
- `outputs/run_manifest.json` with `status=failed_to_parse_but_artifacts_written`
- `run_summary.md` documenting the failure, limitations, and human review needed
