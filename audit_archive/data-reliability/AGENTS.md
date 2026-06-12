# Data Reliability Workflow

## Purpose

This workflow is a public-safe Hermes workspace for dataset-specific reliability analysis.

Each run must produce inspectable generated code and explicit artifacts so results are easy to audit, review, and revise.

## Mandatory Read Order

When running analysis tasks in this repository, read instructions in this exact order:

1. `AGENTS.md`
2. `schemas/artifact_contracts.md`
3. `schemas/profiling_rules.md`
4. `schemas/report_spec.md`

## Precedence

If guidance is duplicated:

1. `schemas/*` files override `AGENTS.md`.
2. `AGENTS.md` overrides `README.md`.

## Operating Model

Treat each immediate subdirectory under `inbox/` as a run-specific task.

For each new analysis run, the agent must:
- inspect the dataset and key-field config
- generate run-specific analysis code
- save generated code in the run folder
- save run artifacts for review

Reusable abstractions are optional and not the default for this phase.

## Core Workflow

1. Select one run folder from `inbox/`.
2. Read the dataset and key-field config from `inbox/<run_id>/`.
3. Create or overwrite `runs/<run_id>/`.
4. Generate analysis code for that dataset.
5. Save generated analysis code in `work/`.
6. Parse the dataset.
7. Compute dataset-level checks.
8. Profile only requested key fields.
9. Write structured outputs to `outputs/`.
10. Write markdown report from computed facts plus a clearly labeled evidence-based model judgment note under `Notable findings`.
11. Write `run_summary.md` at the run folder root.

## Inputs and Scope

Expected input structure in `inbox/`:
- one immediate subdirectory per run, such as `inbox/run_001/`
- exactly one dataset file in each run folder
- exactly one key-fields config file in each run folder

Current implementation scope:
- CSV datasets only
- YAML key-fields config only

Run folder rules:
- the run folder name is the `run_id`
- hidden or system files such as `.DS_Store` must be ignored for intake validation
- do not aggregate or compare results across run folders
- if `runs/<run_id>/` already exists, overwrite its generated `work/` and `outputs/` contents for the new run
- do not modify files in `inbox/<run_id>/`

## Hard Constraints

The agent must not:
- assign severity levels
- score dataset quality
- declare the dataset reliable or unreliable
- perform cross-field validation
- analyze non-key fields except for dataset parsing, duplicate-row checks, and unnamed or blank-header column summary
- invent unsupported findings in prose

The agent must:
- continue and record missing requested key fields
- write the run folder and required artifacts even when parsing fails
- use explicit placeholders when values are unavailable
- include one clearly labeled evidence-based model judgment note under `Notable findings` in the final report

## Definition of Done

A run is complete only when it contains required artifacts defined in `schemas/artifact_contracts.md`, including:
- `work/generated_analysis.py`
- `outputs/field_results.csv`
- `outputs/dataset_summary.json`
- `outputs/reliability_report.md`
- `outputs/run_manifest.json`
- `run_summary.md`

## Coding Guidance

When generating implementation code for a run:
- prefer plain Python
- prefer readable, auditable logic over abstraction-heavy designs
- keep deterministic analysis logic, artifact writing, and report generation clearly separated when practical
- parse `key_fields.yaml` with a standards-compliant YAML parser when available in the run environment; avoid ad-hoc line parsing for general YAML

## Human Review

Do not present outputs as final audit, compliance, legal, financial, or data-quality conclusions. Present them as review aids, state limitations, and identify what a human should inspect.
