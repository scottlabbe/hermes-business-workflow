# Audit Instructions

This folder is a standalone Codex workspace for audit task automation.

The folder should be copyable into a new location and updated for a new source file, key-fields configuration, and request without depending on the parent repository.

## Operating Model

- Treat files in `inbox/` as source intake files.
- Never modify original inbox files.
- Treat each immediate subfolder under `inbox/` as one requested job.
- Each job should contain a `request.md` file and a `source/` folder.
- For each requested job, create a timestamped run folder under `runs/`.
- Copy original source files into the run folder's `00_source/` folder.
- Each skill writes outputs into its own numbered stage folder.
- Each numbered stage folder should contain exactly two durable output files: one primary workbook and one supporting metadata JSON file.
- Put human-readable stage summaries inside the primary workbook's `Summary` sheet instead of separate stage markdown files.
- Each stage must record the exact file and sheet/table the next stage should use in its metadata JSON when a later stage depends on its output.
- Prefer reproducible generated logic over manual spreadsheet edits, and record the method in the stage metadata file.
- Preserve enough evidence for a reviewer to understand what happened.
- Do not write separate stage markdown summaries, validation logs, CSV exports, copied scripts, or standalone manifest files unless the user explicitly asks for them.

## Expected Intake Shape

```text
inbox/
  <job_id>/
    request.md
    source/
      <dataset>.xlsx
      <optional_config>.yaml
```

Excel or CSV is supported for this demo. A job may contain one source file or multiple source files when the requested workflow needs them, such as prior-year and current-year trial balances. The output default contract is Excel-first because the use case is spreadsheet-heavy.

## Standard Run Shape

```text
runs/
  YYYY-MM-DD_<job_id>/
    00_source/
      <dataset>.xlsx
      <optional_config>.yaml
    01_data_reliability/
      data_reliability.xlsx
      data_reliability_metadata.json
    02_<next_stage>/
      sample_selection.xlsx
      sample_metadata.json
```

Additional stages may be inserted when useful. Stage numbers represent logical processing steps, not individual source files. For example, two trial balance files should both be processed in `01_data_reliability/`, then passed to `02_variance_analysis/`.

## Workflow Handoffs

Do not use a separate `manifest.json` as the default workflow memory. The next stage should read the prior stage's metadata JSON and use its `downstream_handoffs` object.

For a transaction sampling workflow, `01_data_reliability/data_reliability_metadata.json` should include a sampling handoff that identifies the reviewed source table.

For a trial balance variance workflow, `01_data_reliability/data_reliability_metadata.json` should include a variance handoff that identifies the prior-year and current-year reviewed source tables.

Each stage metadata file should also include a compact `workflow_stages` array or equivalent stage pointer information when useful, so a reviewer can see the run sequence without opening a separate manifest.

## Required Summaries

Each meaningful stage must include these headings or equivalent fields in the workbook `Summary` sheet and supporting metadata JSON:

- `Task Attempted`
- `Inputs Used`
- `Outputs Created`
- `Checks Performed`
- `Limitations`
- `Human Review Needed`
- `Suggested Improvements`

## Human Review Boundary

Outputs are review aids, workpapers, data reliability observations, and draft analysis artifacts.

Do not present outputs as final audit, compliance, legal, financial, or management conclusions. Do not state that data is reliable, valid, allowable, or suitable for final audit conclusions. Use bounded language and identify what a human reviewer should inspect.

## Skill Order

Use the SKILL.md files as directed. 
