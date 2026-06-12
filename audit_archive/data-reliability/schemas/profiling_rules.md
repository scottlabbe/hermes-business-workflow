# Profiling Rules

This file defines dataset-level checks and requested-key-field profiling rules.

## Run Scope

- Treat each immediate subdirectory under `inbox/` as a separate run.
- The input folder name becomes the `run_id`.
- Each run folder must contain exactly one CSV dataset and one YAML key-fields config.
- Hidden or system files do not count toward the run intake contract.
- Do not aggregate, compare, or merge results across run folders.

## Scope Rules

The analysis must:
- analyze one run folder at a time
- profile only requested key fields
- run dataset parsing checks and duplicate-row checks
- summarize unnamed or blank-header columns when present

The analysis must not:
- profile non-key fields beyond scope above
- perform cross-field validation
- assign severity levels
- score dataset quality
- declare reliable or unreliable status

## Evidence-Based Judgment Note

- The report must include one clearly labeled `Model judgment` note under `Notable findings`.
- The note must be based only on computed artifacts from the current run.
- The note must cite or clearly refer to specific fields, metrics, or dataset-level checks.
- The note may describe patterns as suspicious, inconsistent, incomplete, or worth review.
- The note must use bounded language such as `suggests`, `may indicate`, `appears inconsistent`, or `worth review`.
- The note must not introduce new facts, assign severity, score quality, or declare the dataset reliable or unreliable.

## Dataset-Level Checks

Compute only these dataset-level checks:
- parse success or failure
- parser used
- exact row count when available
- exact column count when available
- missing requested key columns
- duplicate row count when available
- parsing issues that may limit interpretation

## Requested Key-Field Profiling

For each requested key field, record:
- `field_name`
- `field_present`
- `inferred_type`
- `inference_confidence`
- `nonblank_count`
- `blank_count`
- `blank_percent`
- `distinct_count`
- `duplicate_value_count`
- `parse_failure_count` where relevant
- `min_value` and `max_value` where relevant
- `sample_values`
- `issue_flags`
- `ambiguity_notes`

## Allowed Inferred Types

Use only:
- `identifier`
- `numeric`
- `date`
- `categorical`
- `boolean`
- `text`
- `mixed`
- `unknown`

## Inference and Metric Rules

- `inferred_type` must reflect observed values from the field only.
- `inference_confidence` must be a bounded value in `[0, 1]` when available.
- `blank_percent` must be computed from observed blank and nonblank counts when available.
- `duplicate_value_count` applies to repeated nonblank values.
- `parse_failure_count` applies when value-level parsing is attempted for numeric or date-like interpretation.
- `min_value` and `max_value` are only populated when numeric or date-like parsing supports them.
- `sample_values` must show representative observed values, not invented examples.

## Missing and Failure Handling

- If a requested key field is missing, continue the run and record the missing field explicitly.
- If parsing fails, continue the run and write placeholders for unavailable metrics.
- Unavailable or non-applicable values must remain empty and be explained in `ambiguity_notes`.

## Unnamed or Blank-Header Columns

When unnamed or blank-header columns are present, dataset summary must report:
- whether each such column contains data
- brief data summary when practical

This exception does not authorize full profiling of non-key fields.
