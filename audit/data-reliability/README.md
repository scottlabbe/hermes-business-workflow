# Data Reliability Workflow

Data Reliability is a public-safe Hermes audit workflow for profiling a CSV dataset against a user-provided list of key fields.

The workflow is intentionally lightweight: `AGENTS.md` and the schema files define the operating contract, while Hermes generates dataset-specific analysis code and writes inspectable artifacts for each run.

## Why this exists

The workflow shows how little custom orchestration code is needed for a structured, artifact-driven data review task. The durable harness is plain text:

- `AGENTS.md` explains the operating model and hard constraints.
- `schemas/artifact_contracts.md` defines the required files each run must produce.
- `schemas/profiling_rules.md` defines the allowed dataset-level and key-field checks.
- `schemas/report_spec.md` defines the required markdown report structure.

The generated analysis code is saved under each run so reviewers can inspect what Hermes executed.

## Instruction and Contract Sources

Use these files as the authoritative guide:

1. `AGENTS.md` for operating workflow and hard constraints
2. `schemas/artifact_contracts.md` for required output artifact contracts
3. `schemas/profiling_rules.md` for allowed analysis and profiling behavior
4. `schemas/report_spec.md` for markdown report structure and writing rules

`README.md` is onboarding context, not the operational source of truth.

## What the project does

Given one dataset file and one YAML key-fields config in `inbox/`, the workflow:

1. treats one immediate `inbox/<run_id>/` folder as one run
2. creates or overwrites `runs/<run_id>/`
3. generates run-specific analysis code in `work/`
4. computes dataset-level checks
5. profiles requested key fields only
6. writes required artifacts and report under `outputs/`

The workflow does not copy source input files into `runs/<run_id>/`; the run manifest records which source dataset and key-field config were used.

## Current Scope

In scope:
- CSV datasets
- YAML key-fields configs
- dataset-level checks
- requested key-field profiling
- reproducible output artifacts

Out of scope:
- severity labels
- quality scoring
- reliable or unreliable verdicts
- cross-field validation
- full profiling of all non-key columns
- web UI or dashboard

## Project Layout

```text
audit/data-reliability/
├── AGENTS.md
├── README.md
├── inbox/
│   └── run_*/
│       ├── dataset.csv
│       └── key_fields.yaml
├── runs/
│   └── run_*/
│       ├── run_summary.md
│       ├── work/generated_analysis.py
│       └── outputs/
│           ├── dataset_summary.json
│           ├── field_results.csv
│           ├── reliability_report.md
│           └── run_manifest.json
├── templates/
└── schemas/
```

## Included Inputs

The repository includes example input folders in `inbox/`:

- `run_001`: small cost-report style sample with intentional mixed values and negative numeric values.
- `run_002`: music tour data with blank-heavy ranking fields.
- `run_003`: Audible catalog data with numeric parse failures in `price`.
- `run_004`: WARN notice data with duplicate rows and missing values.

These examples are meant to make the workflow inspectable. Generated artifacts should be written under `runs/<run_id>/` when Hermes performs a run.

## Running It In Hermes

Open this folder in Hermes and ask it to run one inbox folder, for example:

```text
Run the data reliability analysis for inbox/run_002.
```

Hermes should follow `AGENTS.md`, read the schema files in the required order, generate run-specific Python code, and write the required artifacts to `runs/run_002/`.

No project API keys are required. Authentication for Hermes happens outside this repository.

## Adding a new dataset

Create a new immediate subdirectory under `inbox/`:

```text
inbox/my_run_id/
├── my_dataset.csv
└── key_fields.yaml
```

The `key_fields.yaml` file should name the dataset file and list only the fields you want profiled:

## Example key-fields config

```yaml
dataset_file: customers.csv
key_fields:
  - customer_id
  - signup_date
  - state
  - account_balance
```

Then ask Hermes to run the analysis for `inbox/my_run_id/`. The generated code and outputs will be written to `runs/my_run_id/`.

## Public-Safe Data Notes

Inputs must be synthetic, public, or otherwise appropriate to redistribute. Source and public-safety assumptions are tracked at the project root in `docs/data_sources.md`.

## Important limitations

This project profiles data for reviewer interpretation. It does not declare a dataset reliable or unreliable, assign severity, score quality, or perform cross-field validation. The final report includes one bounded `Model judgment` note, but that note must be based only on computed run artifacts.
