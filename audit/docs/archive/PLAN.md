# Archived Planning Notes

Archived because the active workflow contracts now live in `AGENTS.md`, `schemas/run_manifest.md`, `workflows/`, and `skills/`.

---

# Single audit testing automation


## R&D expense transactions

## /data-reliability skill - Needs to be downsized. 
Is the data valid and reflect our expectations? 

If no, do we need new data or can we manipulate the data to fix data cleaning issues or should we isolate the records with validation issues or outside our scope? 

Output:
Excel file ({filename}_data_reliability) with tabs:
1) Summary - Source data, table with key fields analysis, procedures applied to the data, summary of each tab, conclusion about the validity of the data. 
2) Exact file (imported with errors, if applicable)
3) Manipulated or cleaned data (if applicable)

## /r&d-expense-sample

Once data is determined to be reliable and suitable for strong audit conclusions, determine how data will filtered or manipulated for sampling. 

Sample should be randomly selected transactions filtered for the transactions from the 15 largest vendors in total "Amount" column. 

Determine the top 15 vendors.


Input: 
{filename}_data_reliability

Output: 
Excel file with tabs:
1) Summary - Source data, summary and record counts for each tab, summary of procedures applied
2) Exact tab used from the data reliability steps. 
3) Filtered data (transactions from the 15 largest vendors).
4) Sampled records.



## Overall idea

Get a file via email. 
Upload it to a folder with the instructions. 
Model reads the files, performs work, produces output

## Example #1 - LACheckbookData-3.xlsx

Example message: 

We received a new file (LACheckbookData-3.xlsx). Please perform the /data-reliability and /r&d-expense-sample skills on the file. 


> **Inbox → Run folder → staged outputs → reusable downstream inputs → final deliverables**

## The key design principle

Do **not** think of each skill as “a report.”

Think of each skill as a **transformation contract**:

```text
input files + assumptions + skill instructions
        ↓
standardized output folder
        ↓
machine-readable artifacts + human-readable summary
        ↓
next skill can use the result
```

That means every skill should answer:

1. **What input does this skill accept?**
2. **What does it produce?**
3. **What folder should the result live in?**
4. **What file should the next skill read?**
5. **What summary should the human review?**

---

# Recommended folder structure

I would use something like this:

```text
single_audit/
  AGENTS.md

  skills/
    data-reliability/
      SKILL.md
      examples/
        good_output_structure.md
        data_reliability_checklist.md

    r-and-d-expense-sample/
      SKILL.md

    variance_explainer/
      SKILL.md

  test_data/
    LACheckbookData-3.xlsx

  runs/
    2026-06-01_LACheckbookData-3/
      run_request.md
      manifest.json

      00_source/
        LACheckbookData-3.xlsx

      01_data_reliability/
        data_reliability_summary.md
        data_reliability.xlsx
        cleaned_data.xlsx
        data_profile.json

      02_r-and-d-expense-sample/
        sampling_summary.md
        sample_selection.xlsx
        sample_metadata.json


  templates/
    key_fields.yaml.md

```

The important move here is that `inbox/` stays clean, and every job gets copied into a timestamped `runs/` folder. That avoids the common agentic-workflow mess where the model keeps modifying the original file or overwriting prior work.

---

# What belongs in `AGENTS.md`?

Your `AGENTS.md` should be thin. It should not contain the full audit methodology.

It should define the **operating rules** for the whole project:

```md
# AGENTS.md

This project demonstrates audit workflow automation using Codex.

## Operating model

- Treat files in `inbox/` as source files.
- Never modify original inbox files.
- For each requested job, create a new folder under `runs/`.
- Copy source files into `00_source/`.
- Each skill must write outputs into its own numbered stage folder.
- Each stage must include:
  - a human-readable summary `.md`
  - one or more Excel outputs
  - a machine-readable `.json` metadata file when useful
- Do not skip earlier stages unless the user explicitly says the prerequisite has already been completed.
- Prefer reproducible scripts over manual spreadsheet edits.
- Preserve enough evidence for a reviewer to understand what happened.

## Example workflow

1. Intake source file.
2. Run data reliability.
3. If reliable enough, run filters for sampling.
4. If appropriate, run transaction sampling.
5. Produce requested file in SKILL.md.

Other workflows will be added and might use some of none of these steps but can be invoked as necessary. 

## Safety / audit judgment

- Do not conclude data is reliable merely because a script ran successfully.
- Identify limitations, missing fields, unusual values, and scope issues.
- Flag judgment calls for user review.
```

Your instinct from prior notes — “thin AGENTS.md, thicker skills/examples” — is exactly right for this kind of demo.

# Use numbered stage folders for runs

This matters more than it seems.

```text
01_data_reliability/
02_vendor_concentration/
03_transaction_sampling/
```



```text
output/
  data_reliability/
  sample/
  variance/
```

because the sequence is implicit and easier to confuse.

---

# Every run should have a `manifest.json`

This is the glue that lets skills stack.

Example:

```json
{
  "run_id": "2026-06-01_LACheckbookData-3",
  "source_files": [
    "00_source/LACheckbookData-3.xlsx"
  ],
  "stages": {
    "data_reliability": {
      "status": "complete",
      "output_folder": "01_data_reliability",
      "approved_downstream_file": "01_data_reliability/data_reliability.xlsx",
      "approved_downstream_tab": "Cleaned Data",
      "limitations": [
        "12 records excluded due to missing vendor name"
      ]
    },
    "vendor_concentration": {
      "status": "complete",
      "output_folder": "02_vendor_concentration"
    }
  }
}
```

This is not mainly for the user. It is for the agent.

The agent should not have to infer which file to use next. The prior skill should declare it.

---

# Separate “human outputs” from “agent outputs”

For each stage, produce both:

## Human-readable

```text
data_reliability_summary.md
sampling_summary.md
reviewer_summary.md
```

These explain what happened.

## Agent-readable

```text
manifest.json
data_profile.json
sampling_metadata.json
```

These let the next step continue without re-reading everything from scratch.

## User-downloadable

```text
data_reliability.xlsx
sample_selection.xlsx
audit_workpaper_package.xlsx
```

These are the files a normal person actually wants.

This split is very important. A lot of AI workflow demos fail because they only optimize for the final Excel file, not the intermediate state needed for a reliable process.

---

# I would avoid “manipulated data” as a folder concept

In your notes, you have:

> Manipulated or cleaned data

I would be careful with the word “manipulated” in an audit demo. It can sound like the data was changed in a way that affects evidence.

Use:

```text
cleaned_data
standardized_data
excluded_records
normalization_log
```

And require the skill to explain every change:

```text
Original field: "Check Amount"
Standardized field: "Amount"
Change type: column rename
Records affected: all
```

This is a small wording issue, but in an audit context it matters.

---

# Inbox design

```text
inbox/
  LACheckbookData-3/
    source/
      LACheckbookData-3.xlsx
    request.md
```

Instead of placing loose files directly in `inbox/`, use one folder per job.

Example:

```text
inbox/
  LACheckbookData-3/
    request.md
    source/
      LACheckbookData-3.xlsx
      key_fields.yaml
```

`request.md` might say:

```md
# Request
Please perform the /data-reliability and /r-and-d-expense-sample skills on the file.

## Source file

source/LACheckbookData-3.xlsx

## Parameters

Key fields are listed in the key_fields.yaml file. 
 
```

Then Codex can be told:

> “Process the newest folder in `inbox/`.”

That is more realistic than uploading one file and writing a new long prompt every time.

---

# Better flow for your demo

I’d design the demo like this:

```text
1. User drops file + request.md into inbox/LACheckbookData-3/
2. Codex creates runs/2026-06-01_LACheckbookData-3/
3. Codex copies original source into 00_source/
4. Codex runs data reliability skill
5. Codex updates manifest.json
6. Codex runs vendor concentration skill
7. Codex updates manifest.json
8. Codex runs sampling skill
9. Codex creates final reviewer summary and final Excel package
```

That lets you demo a real-world pattern:

> “The inbox is the work queue. The run folder is the audit trail. The skills are reusable work programs. The outputs are both reviewer-ready and agent-ready.”

That framing is strong.
---

# The most important design rule

Every skill should end with this sentence, basically:

> “For downstream use, use `{file}` and `{tab/table}`.”

That one line solves a huge amount of agent confusion.

For example:

```md
## Downstream handoff

Use:
- File: `01_data_reliability/data_reliability.xlsx`
- Tab: `Cleaned Data`
- Reason: This tab preserves all in-scope records after excluding invalid rows documented in `Validation Issues`.
```

Without that, the next agent step may use the wrong sheet, the original dirty data, or the final summary tab.

---

# My opinionated recommendation

Build this as **small composable skills + workflow recipes + run manifests**.

Do not make one giant audit-agent prompt.

The shape should be:

```text
AGENTS.md = operating rules
SKILL.md = reusable procedure
workflow.md = ordered skill recipe
request.md = user’s specific job
manifest.json = state and handoff memory
run folders = audit trail
```

That is the cleanest way to demo real-world audit work with Codex because it shows more than “AI made an Excel file.” It shows a repeatable operating model.
