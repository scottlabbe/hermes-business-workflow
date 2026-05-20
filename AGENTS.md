# Hermes Business Workflow — Project Instructions

This repository contains public-safe, role-based Hermes workspaces for document-heavy business workflows.

## Scope

Use this file for project-wide behavior only. Role-specific task instructions live in:

- `audit/AGENTS.md`
- `audit/data-reliability/AGENTS.md`
- `audit/variance_explainer/AGENTS.md`
- `program_management/AGENTS.md`

## Public Repo Safety

Do not create, store, or commit secrets, credentials, private client data, confidential employer data, private emails, or production databases.

Use synthetic data or public data that is appropriate to redistribute.

## File Handling

Durable files:
- `README.md`
- `AGENTS.md`
- `.gitignore`
- `docs/`
- `audit/`
- `program_management/`
- `shared/`
- `examples/`

Disposable files:
- `audit/*/runs/`
- `audit/*/workpapers/`
- `program_management/*/runs/`
- `program_management/*/workpapers/`
- `tmp/`
- `cache/`

Do not delete durable files unless explicitly asked.

## Output Rules

For meaningful workflow runs, save outputs under the active role workspace’s `runs/` folder.

Each meaningful run should include `run_summary.md` covering:

- task attempted
- inputs used
- outputs created
- checks performed
- limitations
- human review needed
- suggested improvements

## Human Review

Do not present outputs as final audit, compliance, legal, financial, or management conclusions. Flag uncertainty and identify what a human should review.

## Role Selection

If a task is audit-related, use `audit/`.

For data reliability checks, use `audit/data-reliability/`.

For trial balance variance explanation, use `audit/variance_explainer/`.

If a task is program management, monitoring, reporting, or operations-related, use `program_management/`.

If the task is repo maintenance, operate from the project root.

## Python Execution Rule

For workflow runs in this project, use the terminal tool from the project root.

Do not use `execute_code` for workflow execution.

Reason: `execute_code` runs in a separate sandbox Python environment and does not use this project’s `.venv`, so project dependencies such as `pandas` and `openpyxl` may not be available.

Before running any workflow, run:

```bash
cd /home/hermes/projects/hermes-business-workflow
./scripts/preflight.sh
```

If preflight fails, stop immediately and report:
- the command that failed
- the error message
- the proposed fix

For Python execution, use the project virtual environment explicitly:

```bash
cd /home/hermes/projects/hermes-business-workflow
.venv/bin/python path/to/script.py
```

Do not use bare `python`, bare `python3`, or `execute_code` for workflow runs unless Scott explicitly approves.

Do not search .venv, site-packages, caches

## Demo Readiness

This project is intended to demonstrate real business workflows with public-safe inputs, visible instructions, reproducible artifacts, and human review checkpoints.

Prefer small, inspectable workflows over broad automation. Do not imply Hermes has produced final professional conclusions. Present outputs as drafts, workpapers, analyses, or review aids.
