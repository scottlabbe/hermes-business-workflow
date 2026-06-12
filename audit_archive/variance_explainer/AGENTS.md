# AGENTS.md — Trial Balance Prior-Year vs Current-Year Variance Analyzer

## Project Purpose

Take two trial balance files — one prior-year, one current-year — and produce a single Excel workbook with:

1. Normalized prior-year and current-year TB tabs.
2. A `Comparison` tab showing account-level variances, ranked by size and significance.
3. Client follow-up questions for accounts that exceed user-supplied materiality thresholds.

The goal is an auditor- or controller-ready variance review workbook, not a raw spreadsheet comparison.

Computational rules (schema, matching, math, ranking, question templates, formatting) live in SKILL.md. This file covers what to ask the user and what to deliver. This is a project-local skill. Read it by path.

Outputs are review aids, not final audit, compliance, legal, financial, or management conclusions.

---

## Mandatory Read Order

Before running analysis, read instructions in this order:

1. `AGENTS.md`
2. `variance_explainer/skills/tb-variance-analysis/SKILL.md`

Do not create the workbook until the threshold intake rules below are satisfied.

---

## Implementation

Python only. The standard library plus `pandas` and `openpyxl`. Do not create `.js`, `.mjs`, `.ts`, or other non-Python source files for the core analysis. 

---

## Expected Inputs

The user will provide two trial balance files in `.csv`, `.xlsx`, or `.xls` format.

If the filenames clearly indicate year/status (e.g., `prior_year_tb.xlsx`, `2024_trial_balance.csv`, `PY_TB.xlsx`), accept either order. Otherwise, ask the user to identify which file is prior-year and which is current-year.

---

## Threshold Intake Before Analysis

Before analysis, determine the threshold configuration from the user's request.

If the user's request does not include thresholds and does not explicitly say to use defaults, stop and ask:

1. Dollar threshold for generating client questions.
2. Percent-change threshold for generating client questions.
3. If both are provided, whether questions trigger when either threshold is met (`OR`) or only when both are met (`AND`).

Do not treat omission as permission to use defaults.

The user may provide:

- both a dollar threshold and a percent-change threshold
- only a dollar threshold
- only a percent-change threshold
- an explicit instruction to use defaults

Use defaults only when the user explicitly says to use defaults, says they have no threshold preference, or says to proceed with the default thresholds. Defaults are: absolute dollar change ≥ $10,000 `OR` absolute percent change ≥ 20% (with the trivial-balance guardrail in SKILL.md).

If the prompt includes a complete threshold configuration, parse it and continue. Do not ask again.

### Trigger logic precedence

If the user provides `AND` or `OR` anywhere in the threshold response, treat that as the selected trigger logic. This explicit user instruction overrides the default `OR` behavior, even when thresholds and trigger logic appear across separate sentences or lines.

If the user provides both a dollar threshold and a percent-change threshold but does not provide `AND` or `OR`, stop and ask them to choose `AND` or `OR` before running.

If the user provides only one threshold, trigger logic is not applicable and no `AND`/`OR` question is required.

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

If threshold information is incomplete or ambiguous, stop after asking the needed clarification and do not create the workbook.

### Examples

- User says: `Run the variance analysis.`
  - Action: ask for threshold preferences before analysis.
- User says: `Run with defaults.`
  - Action: use `$10,000 OR 20%`, restate the configuration, then run.
- User says: `Use a $25,000 threshold.`
  - Action: use dollar-only threshold, trigger logic `Not applicable`, restate the configuration, then run.
- User says: `Use $25,000 and 15%.`
  - Action: ask whether to use `AND` or `OR` before analysis.
- User says: `Use $25,000 or 15%.`
  - Action: use both thresholds with `OR`, restate the configuration, then run.

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
8. `runs/<run_id>/run_summary.md` documents the task, inputs, threshold configuration used, outputs, checks, limitations, human review needed, and suggested improvements.
