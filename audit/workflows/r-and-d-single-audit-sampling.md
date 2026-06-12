# R&D Single Audit Sampling Workflow

Use this workflow when the user asks Codex to process one source Excel workbook, CSV, or TSV file for R&D-expense-style single audit sampling support.

The workflow produces review aids and data reliability observations. It does not produce final audit conclusions.

## Required Instructions

Read these files before running the workflow:

1. `AGENTS.md`
2. `schemas/run_manifest.md`
3. `skills/data-reliability/SKILL.md`
4. `skills/r-and-d-expense-sample/SKILL.md`

## Intake

Expected job folder:

```text
inbox/<job_id>/
  request.md
  source/
    <dataset>.xlsx
    key_fields.yaml
```

The source dataset may also be `.csv` or `.tsv`. The key-fields config should identify the dataset file and the key fields to profile.

## Workflow Steps

1. Select the requested `inbox/<job_id>/` folder. If the user says to process the newest inbox item and there are multiple jobs, select the most recently modified job folder.
2. Validate the intake folder.
3. Create `runs/YYYY-MM-DD_<job_id>/`.
4. Copy source files to `00_source/`.
5. Run the data reliability skill into `01_data_reliability/`.
6. Confirm `01_data_reliability/data_reliability_metadata.json` includes `downstream_handoffs.r_and_d_expense_sample` or `downstream_handoffs.expense_sample`.
7. Run the R&D expense sample skill into `02_r-and-d-expense-sample/` using that metadata handoff.
8. Confirm `02_r-and-d-expense-sample/sample_metadata.json` includes the final workbook handoff, checks performed, limitations, human review needed, and workflow stage pointers.

## Data Reliability Sampling Input Requirement

The data reliability stage must identify the exact generated workbook file and sheet for sampling use. For CSV and TSV sources, the parsed source table is written to the generated `Source File` sheet.

The sampling stage must not guess among sheets. It must read `downstream_handoffs.r_and_d_expense_sample` or `downstream_handoffs.expense_sample` from `01_data_reliability/data_reliability_metadata.json` unless the user explicitly overrides it.

## Default Sampling Parameters

If the user does not specify sampling parameters, use:

- population: all rows in the input sheet
- sample size: `60`
- random seed: `20260601`
- selection method: Python standard-library random sample without replacement
- selection algorithm: `random.Random(random_seed).sample(range(1, input_record_count + 1), sample_size_selected)`

Do not apply vendor, amount, funding, category, department, program, or description filters unless the user explicitly requests them.

If the input population contains fewer records than the requested sample size, select all records and document the limitation.

The sampling stage must preserve source row numbers, population sequences, selected population sequences, and the Python sampling method in `sample_selection.xlsx` and `sample_metadata.json` so a reviewer can recreate the sample from the same input file and parameters.

## Final Outputs

The completed run should contain:

```text
runs/YYYY-MM-DD_<job_id>/
  00_source/
  01_data_reliability/
    data_reliability.xlsx
    data_reliability_metadata.json
  02_r-and-d-expense-sample/
    sample_selection.xlsx
    sample_metadata.json
```

The final response to the user should identify:

- run folder created
- Excel workbooks created
- metadata files created
- checks performed
- limitations
- human review needed

Do not state that the selected sample is sufficient for audit purposes. State that it is a documented sample selection review aid.
