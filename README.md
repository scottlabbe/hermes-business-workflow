# Hermes Business Workflow

Public-safe Hermes workspaces for document-heavy business workflows.

This project is a demo environment for showing that agents can do real professional work without a custom enterprise integration for every process. The pattern is intentionally lightweight: plain folders, `AGENTS.md` files, workflow instructions, templates, generated artifacts, and human review checkpoints.

The goal is not full automation. The goal is faster, more structured, and more reviewable work.

## Project Theme

Many business workflows are difficult to automate because they involve:

- PDFs, spreadsheets, emails, and shared-drive files
- inconsistent formats
- extraction from semi-structured documents
- validation against rules or expectations
- judgment-heavy review
- evidence and documentation requirements
- human sign-off before action

This repo demonstrates a repeatable agent workflow pattern:

```text
raw files
→ extraction
→ normalized data
→ validation checks
→ exceptions, findings, or follow-up questions
→ draft report, workbook, or workpaper
→ run_summary.md with human review needed
```

## Repository Structure

```text
hermes-business-workflow/
  README.md
  AGENTS.md
  .gitignore
  docs/
    data_sources.md
  shared/
    templates/
      run_summary.md
  audit/
    AGENTS.md
    README.md
    data-reliability/
    variance_explainer/
  program_management/
    AGENTS.md
    README.md
    cost-reports/
```

## Current Workspaces

### Audit

`audit/` contains audit-style review workflows.

Implemented or scaffolded workflows:

- `audit/data-reliability/`: profile CSV datasets against requested key fields, write generated code, structured artifacts, and a reliability report.
- `audit/variance_explainer/`: compare prior-year and current-year trial balances and produce a variance review workbook.

Planned audit workflow extensions:

- sampling support after data reliability profiling
- reconciliation review
- evidence extraction from PDFs and spreadsheets
- finding development from exceptions
- audit workpaper support

### Program Management

`program_management/` contains program management, monitoring, reporting, and operations workflows.

Current scaffold:

- `program_management/cost-reports/`: demo salary-report inputs for a future cost report desk review workflow.

Planned program management workflows:

- cost report desk review
- contract obligation tracking
- grant reporting review
- weekly status briefing
- meeting-to-action tracking
- operational reporting

## Workflow Portfolio

The strongest demos should be end-to-end workflows, not isolated prompts.

### Cost Report Desk Review

Planned flow:

1. Extract data from entity or district workbooks.
2. Normalize salaries, benefits, funding splits, and totals.
3. Validate math, missing fields, unusual percentages, duplicate employees, and inconsistent periods.
4. Identify exceptions and follow-up questions.
5. Produce an exception log, review memo, source trace, and `run_summary.md`.

### Data Reliability Plus Sampling

Planned flow:

1. Profile a dataset and requested key fields.
2. Validate completeness, duplicates, blanks, parse failures, and unusual values.
3. Generate a sampling plan using a documented method.
4. Select sample items.
5. Create a testing worksheet and sample rationale.
6. Produce human review notes and `run_summary.md`.

### Trial Balance Variance Review

Current flow:

1. Load prior-year and current-year trial balances.
2. Normalize chart of account fields and balances.
3. Aggregate duplicate account keys.
4. Calculate dollar and percent variance.
5. Rank accounts by variance.
6. Generate follow-up questions.
7. Produce a workbook and `run_summary.md`.

## Operating Model

Durable project files live in Git.

Generated workflow outputs should live under each workflow's `runs/` folder and include `run_summary.md`.

Disposable analysis workpapers should live under each workflow's `workpapers/` folder when that folder exists.

Reviewed sample outputs can be copied into an `examples/` folder later, after public-safety review.

```text
Instructions, templates, schemas, and docs = durable
Runs, scratch files, and temporary workpapers = disposable
Reviewed sample outputs = examples
```

## Using With Hermes

Run Hermes from the project root or from the specific workflow folder.

Project root:

```bash
cd ~/hermes/projects/hermes-business-workflow
hermes chat
```

Data reliability workflow:

```bash
cd ~/hermes/projects/hermes-business-workflow/audit/data-reliability
hermes chat
```

Trial balance variance workflow:

```bash
cd ~/hermes/projects/hermes-business-workflow/audit/variance_explainer
hermes chat
```

Hermes should read the root `AGENTS.md`, then the relevant workspace `AGENTS.md`, then any workflow-specific schemas, templates, or skill files.
