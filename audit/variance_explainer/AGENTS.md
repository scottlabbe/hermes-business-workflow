# AGENTS.md — Trial Balance Prior-Year vs Current-Year Variance Analyzer

## Project Purpose

Take two trial balance files — one prior-year, one current-year — and produce a single Excel workbook with:

1. Normalized prior-year and current-year TB tabs.
2. A `Comparison` tab showing account-level variances, ranked by size and significance.
3. Client follow-up questions for accounts that exceed user-supplied materiality thresholds.

The goal is an auditor- or controller-ready variance review workbook, not a raw spreadsheet comparison.

Computational rules (schema, matching, math, ranking, question templates, formatting) live in SKILL.md. This file covers what to ask the user and what to deliver.

Outputs are review aids, not final audit, compliance, legal, financial, or management conclusions.

---

## Implementation

Python only. The standard library plus `pandas` and `openpyxl`. Do not create `.js`, `.mjs`, `.ts`, or other non-Python source files for the core analysis. 

---

## Expected Inputs

The user will provide two trial balance files in `.csv`, `.xlsx`, or `.xls` format.

If the filenames clearly indicate year/status (e.g., `prior_year_tb.xlsx`, `2024_trial_balance.csv`, `PY_TB.xlsx`), accept either order. Otherwise, ask the user to identify which file is prior-year and which is current-year.

---

## Required User Questions Before Analysis

Ask the user for optional thresholds:

1. Dollar threshold for generating client questions.
2. Percent-change threshold for generating client questions.
3. If both are provided, whether questions trigger when either threshold is met (`OR`) or only when both are met (`AND`).

The user may provide both, only dollar, only percent, or neither. If neither, use defaults: absolute dollar change ≥ $10,000 `OR` absolute percent change ≥ 20% (with the trivial-balance guardrail in SKILL.md).

### Trigger logic precedence

If the user provides `AND` or `OR` anywhere in the threshold response, treat that as the selected trigger logic. This explicit user instruction overrides the default `OR` behavior, even when thresholds and trigger logic appear across separate sentences or lines.

### Malformed thresholds

If a threshold value has malformed or ambiguous punctuation, stop and ask the user to clarify. Do not silently strip punctuation and infer the amount.

Examples that require clarification:

- `$200,00`
- `$10.000`
- `20 percent` when it is unclear whether the intended value is `20%` or `0.20%`

### Threshold restatement

Before running analysis, restate the parsed threshold configuration in this exact structure:

- Dollar threshold: `$X`, or `None`
- Percent-change threshold: `Y%`, or `None`
- Trigger logic: `AND`, `OR`, or `Not applicable`
- Interpretation: Plain-English explanation of which accounts will receive questions

If both thresholds are provided and the trigger logic is unclear, ask the user to choose `AND` or `OR` before running.

---

## Output Requirements

Save one Excel workbook to:

```text
runs/<run_id>/outputs/tb_variance_analysis.xlsx
```

If the user does not provide a run identifier, create one using a timestamp such as `tb_variance_YYYYMMDD_HHMMSS`.

Required tabs, in order:

1. `Prior_Year_TB`
2. `Current_Year_TB`
3. `Comparison`
4. `README`

---

## Definition of Done

The task is complete when:

1. A single Excel workbook is created at the path above.
2. The workbook includes the four required tabs.
3. The Comparison tab includes every account from either year and all required columns (see SKILL.md). No materiality score column exists.
4. The Comparison tab's `Prior Year Balance`, `Current Year Balance`, `Dollar Change`, and `Percent Change` columns are Excel formulas referencing the source tabs, not static values.
5. Questions are populated only for accounts exceeding the chosen threshold logic.
6. The workbook is formatted for review per SKILL.md.
7. README documents thresholds, column mappings, aggregation, balance convention, and any exceptions.
8. `runs/<run_id>/run_summary.md` documents the task, inputs, outputs, checks, limitations, human review needed, and suggested improvements.
