# Hermes Business Workflow

This project contains public-safe, role-based Hermes workspaces for document-heavy business workflows.

The demo goal is not full automation. The goal is to show how an agent can complete structured work that looks like real audit, compliance, program management, and operations support: reading inputs, following written instructions, producing reviewable artifacts, and leaving clear human review checkpoints.

## What Is Here

```text
hermes-business-workflow/
  AGENTS.md
  README.md
  docs/
  shared/
  audit/
    AGENTS.md
    data-reliability/
    variance_explainer/
  program_management/
    AGENTS.md
    cost-reports/
```

## Workspaces

`audit/data-reliability/` profiles CSV datasets against a requested list of key fields. It writes generated code and structured outputs so the analysis can be inspected.

`audit/variance_explainer/` turns prior-year and current-year trial balance files into a variance review workbook with formulas, rankings, analysis notes, and suggested follow-up questions.

`program_management/` is reserved for program management, monitoring, reporting, and operations workflows. The current cost-report sample data should be treated as demo input until that workflow is fully documented.

## Public-Safe Boundary

Do not add secrets, credentials, private client data, confidential employer data, private emails, or production databases.

Inputs should be synthetic, public, or otherwise appropriate to redistribute. When public data is used, document the source and any redistribution assumptions in `docs/data_sources.md` or in the relevant workspace README.

## Expected Run Pattern

For a meaningful workflow run, Hermes should:

1. Read the root `AGENTS.md`.
2. Select the active workspace under `audit/` or `program_management/`.
3. Read the workspace `AGENTS.md` and any referenced skill or schema files.
4. Write generated artifacts under the active workspace's `runs/` folder.
5. Include a `run_summary.md` that states inputs used, outputs created, checks performed, limitations, and human review needed.

## Human Review

Outputs are review aids, not final audit, compliance, legal, financial, or management conclusions. A human should review assumptions, inputs, generated code, calculations, and any judgmental language before using an output.

## What Is Intentionally Not Included

This repo does not include private client materials, production databases, credentials, unattended production automation, or claims that an agent can replace professional review.
