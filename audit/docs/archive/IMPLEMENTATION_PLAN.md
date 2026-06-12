# Archived Implementation Plan

Archived because the active workflow contracts now live in `AGENTS.md`, `schemas/run_manifest.md`, `workflows/`, and `skills/`.

---

# Implementation Plan

## Purpose

Build a standalone `single_audit` demo folder that shows professionals how Codex can automate an R&D-style single audit task using plain folders, visible instructions, generated workpapers, Excel outputs, and human review checkpoints.

The demo should show a repeatable operating model, not a final audit conclusion.

## Demo Goal

Given a source Excel workbook and a key-fields configuration, Codex should:

1. Intake the request from `inbox/<job_id>/`.
2. Create a timestamped run folder.
3. Copy source files into `00_source/`.
4. Produce data readiness observations and a data reliability review workbook.
5. Identify transactions from the 15 largest vendors by total `Amount`.
6. Select a documented random sample from the filtered population.
7. Create reviewer-ready Excel and markdown artifacts.
8. Record exact downstream handoffs in `manifest.json`.

## Scope

In scope:

- Excel workbook intake.
- One workbook and one key-fields YAML file per job.
- Single-sheet Excel datasets by default.
- Requested key-field profiling.
- Basic dataset-level readiness checks.
- Vendor concentration by total `Amount`.
- Random sample selection with a documented seed.
- Human-readable summaries and machine-readable metadata.

Out of scope for this first implementation:

- Final audit conclusions.
- Allowability determinations.
- Compliance opinions.
- Statistical sampling conclusions.
- Multi-file joins.
- Production workflow orchestration.
- Private client data.

## Folder Structure To Implement

```text
single_audit/
  AGENTS.md
  IMPLEMENTATION_PLAN.md
  PLAN.md
  schemas/
    run_manifest.md
  workflows/
    r-and-d-single-audit-sampling.md
  skills/
    data-reliability/
      SKILL.md
    r-and-d-expense-sample/
      SKILL.md
  templates/
    key_fields.yaml
  inbox/
    <job_id>/
      request.md
      source/
        <dataset>.xlsx
        key_fields.yaml
  runs/
```

## Standard Workflow

1. Select one `inbox/<job_id>/` folder.
2. Read `request.md`.
3. Validate `source/` contains exactly one Excel workbook and one key-fields YAML file.
4. Create `runs/YYYY-MM-DD_<job_id>/`.
5. Copy the source workbook and key-fields YAML into `00_source/`.
6. Create initial `manifest.json`.
7. Run data reliability.
8. Update `manifest.json` with the data reliability downstream handoff.
9. Run R&D expense sampling from the handoff file and sheet/table.
10. Update `manifest.json` with sampling outputs.
11. Write final `run_summary.md`.

## Data Reliability Stage

The data reliability stage should create:

- `01_data_reliability/data_reliability_summary.md`
- `01_data_reliability/data_reliability.xlsx`
- `01_data_reliability/data_profile.json`
- `01_data_reliability/stage_metadata.json`

The Excel workbook should include:

- `Summary`
- `Source Preview`
- `Key Field Profile`
- `Data Readiness Observations`
- `Downstream Data`
- `Downstream Handoff`

The stage must not conclude that data is reliable or unreliable. It should state data readiness observations, limitations, and human review items.

## Sampling Stage

The sampling stage should create:

- `02_r-and-d-expense-sample/sampling_summary.md`
- `02_r-and-d-expense-sample/sample_selection.xlsx`
- `02_r-and-d-expense-sample/sample_metadata.json`
- `02_r-and-d-expense-sample/stage_metadata.json`

The Excel workbook should include:

- `Summary`
- `Input Data`
- `Vendor Totals`
- `Filtered Population`
- `Sampled Records`
- `Sampling Metadata`

The sampling stage should determine the top 15 vendors by total `Amount`, filter the population to those vendors, and select a random sample using a documented sample size and seed.

## Run Manifest

Use `schemas/run_manifest.md` as the durable schema for `runs/<run_id>/manifest.json`.

The manifest is the workflow memory. It should identify:

- source files
- completed stages
- status and limitations
- artifacts written
- exact downstream file paths
- exact downstream sheet/table names
- human review checkpoints

## Implementation Order

1. Confirm the standalone folder structure and instruction files.
2. Finalize `AGENTS.md`.
3. Finalize `schemas/run_manifest.md`.
4. Finalize `skills/data-reliability/SKILL.md` with Excel intake.
5. Finalize `skills/r-and-d-expense-sample/SKILL.md`.
6. Finalize `workflows/r-and-d-single-audit-sampling.md`.
7. Update `templates/key_fields.yaml`.
8. Run one demo using the example inbox folder.
9. Review generated artifacts for public-safe wording and demo clarity.
10. Copy reviewed example outputs into an examples folder only if desired later.

## Open Decisions

- Whether sampling should default to a fixed count, such as 25 records, or require the user to specify sample size.
- Whether top vendors should be ranked by absolute total `Amount` or positive total `Amount`. The default contract uses descending total `Amount`.
- Whether the data reliability workbook should preserve the full source table or only a preview plus downstream standardized data.
- Whether to add a separate `02_vendor_concentration/` stage or keep vendor concentration inside the sampling skill.

## Demo Script

Suggested live prompt:

```text
We received a new file in inbox/la_checkbook. Please run the R&D single audit sampling workflow.
```

Expected Codex behavior:

1. Read `AGENTS.md`.
2. Read `workflows/r-and-d-single-audit-sampling.md`.
3. Read the applicable skill files.
4. Create a run folder.
5. Generate and run inspectable analysis code.
6. Produce Excel and markdown review aids.
7. Explain limitations and human review needed.
