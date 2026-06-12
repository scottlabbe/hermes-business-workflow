# Report Specification

This file defines the default structure and writing rules for `outputs/reliability_report.md`.

## Required Top-Level Sections

The report must contain exactly five top-level sections in this exact order:

1. `Source`
2. `Purpose`
3. `Procedures`
4. `Results`
5. `Conclusion`

No additional top-level sections are allowed.

## Section Requirements

### Source
Must include:
- run identifier from the input folder name
- source dataset filename
- run timestamp
- parser used
- parse success or failure
- row count when available
- column count when available
- requested key fields

### Purpose
Must state:
- that this run analyzed the provided dataset using requested key fields
- that outputs are factual artifacts for reviewer interpretation, with one bounded evidence-based `Model judgment` note in `Notable findings`

### Procedures
Must describe, factually:
- parsing approach used
- dataset-level checks performed
- requested key-field profiling performed
- handling approach for ambiguity and parse limitations

### Results
Must include all of the following:
- a human-readable summary of dataset-level checks
- dataset-level summary entries must be rendered as readable bullets; nested structures must be expanded into bullets or table rows (no raw object dumps)
- the complete `field_results.csv` table in markdown form, including all requested key-field rows with no truncation, no sampling, and no aggregation; preserve the contract column order
- issue flags and ambiguity notes in the table
- a `Notable findings` subsection that highlights substantive anomalies
- `Notable findings` must prioritize anomalies that materially affect interpretation: missing requested key fields, parsing issues, value parse failures, high blank rates, no nonblank values, duplicate rows, and unnamed or blank-header columns that contain data
- routine `duplicate_nonblank_values_present` alone is not sufficient for `Notable findings` unless accompanied by a materially impactful condition or explicit context for why it is anomalous
- `Notable findings` must include a clearly labeled `Model judgment` note
- the `Model judgment` note must synthesize what does not look right or what deserves closer review based on computed evidence from the run
- the `Model judgment` note must cite or clearly refer to concrete field names, metric values, and/or dataset-level checks
- the `Model judgment` note must use bounded language such as `suggests`, `may indicate`, `appears inconsistent`, or `worth review`
- the `Model judgment` note must not assign severity, score quality, or declare the dataset reliable or unreliable

If no substantive anomalies are detected, `Notable findings` must explicitly state that none were observed, and the `Model judgment` note must say that the computed evidence does not show a clear anomaly requiring emphasis.

### Conclusion
Must include:
- short synthesis of what was analyzed
- most notable observations from the run
- at least two concrete observations tied to specific field names and/or dataset-level checks with supporting metric values from run artifacts
- run limitations and what a reviewer should examine next

Must not include:
- severity labels
- quality scores
- final verdict that the dataset is reliable or unreliable
- a pointer to another section as a substitute for concrete observations in the conclusion

## Writing Rules

The report must:
- be based only on computed facts from run artifacts, except that the labeled `Model judgment` note may provide a bounded interpretation of those facts
- avoid invented findings, implied certainty, or unsupported claims
- stay reproducible and audit-friendly
