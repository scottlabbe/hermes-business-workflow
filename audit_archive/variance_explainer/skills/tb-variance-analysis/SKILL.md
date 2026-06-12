# SKILL.md — Trial Balance Variance Analysis Workbook

## Skill Purpose

Use this skill when the user provides two trial balance files and wants a prior-year vs current-year variance analysis workbook. The skill produces a single Excel workbook combining both inputs with a ranked Comparison tab, variance notes, and client follow-up questions.

Do not create a materiality score.

User-facing prompts and the deliverable shape are defined in AGENTS.md. This file covers the computation.

---

## Normalized Trial Balance Schema

Normalize each input TB into this schema:

| Field | Required | Notes |
|---|---:|---|
| `Account Number` | Preferred | Use account code/number if available |
| `Account Name` | Required | Use account description/name |
| `Account Category` | Preferred | Infer from name if missing |
| `Department` | Optional | Preserve if present |
| `Balance` | Required | Signed ending balance |
| `Source File` | Required | Original file name |
| `Source Year` | Required | `Prior Year` or `Current Year` |

If the input has separate debit and credit columns: `Balance = Debit − Credit`. If the input has one balance column, preserve its sign convention, including parenthetical negatives like `(1,234.56)`.

Document the balance-convention assumption in the README tab.

---

## Column Detection

Normalize source column names by lowercasing, trimming whitespace, and removing non-alphanumeric characters before matching. Recognize these aliases:

- **Account number**: `account`, `account number`, `account no`, `account code`, `gl account`, `acct`
- **Account name**: `account name`, `description`, `account description`, `name`
- **Account category**: `category`, `type`, `account type`, `financial statement area`, `class`
- **Balance**: `balance`, `ending balance`, `amount`, `current balance`, `cy balance`, `py balance`
- **Debit**: `debit`, `debits`, `dr`
- **Credit**: `credit`, `credits`, `cr`
- **Department**: `department`, `dept`, `fund`, `division`, `location`

If account name and balance (or debit + credit) cannot be identified, stop and ask the user, or write an `Input_Mapping` tab listing the guessed mappings and unresolved fields.

If `Account Category` is missing, infer from the account name (cash/receivable/inventory → Asset; payable/accrual/debt → Liability; equity/capital/retained earnings → Equity; revenue/sales/income → Revenue; expense/payroll/rent → Expense). Default to `Unknown`.

---

## Account Matching

Build a stable `match_key` for joining prior to current. Preferred order:

1. Account number, lowercased and trimmed.
2. Normalized account name (lowercased, repeated whitespace collapsed) when account number is blank.

If duplicate match keys exist within a single year, aggregate balances by key. Preserve the first nonblank account number, name, and category. Document the duplicate-aggregation count in README.

Write `match_key` as a column on `Prior_Year_TB`, `Current_Year_TB`, and `Comparison` so the formula joins in the Comparison tab work for accounts without numbers. Hide the column on each sheet.

---

## Comparison Calculations

Compute these values in Python for every account appearing in either year. These numeric values drive ranking, threshold evaluation, and validation. The cells written to the Comparison sheet for the four balance and change columns are Excel formulas (see next section); the in-memory row dict still holds the numeric result.

```text
Prior Year Balance     = aggregated prior-year balance for match_key (0 if missing)
Current Year Balance   = aggregated current-year balance for match_key (0 if missing)
Dollar Change          = Current Year Balance − Prior Year Balance
Percent Change         = Dollar Change / abs(Prior Year Balance)
```

Use a half-cent tolerance (`abs_tol=0.004`) when testing whether a balance is zero, to avoid floating-point and rounding noise.

If `Prior Year Balance` is zero (within tolerance), `Percent Change` is `N/A` (blank). Do not divide by zero.

---

## Comparison Tab Formulas

Write the following four Comparison columns as Excel formulas referencing the source tabs, not as static values. The numeric values computed above are still used internally; only the cell value written to the sheet changes.

Derive column letters at write time from each column's position in `COMPARISON_COLUMNS` (and from the position of `Account Number`, `Balance`, and `match_key` on the source tabs). Do not hardcode letters.

- **`Prior Year Balance`** (row 2 example):
  ```
  =SUMIF(Prior_Year_TB!<match_key_col>:<match_key_col>, <this_row_match_key>, Prior_Year_TB!<balance_col>:<balance_col>)
  ```
- **`Current Year Balance`**:
  ```
  =SUMIF(Current_Year_TB!<match_key_col>:<match_key_col>, <this_row_match_key>, Current_Year_TB!<balance_col>:<balance_col>)
  ```
- **`Dollar Change`**:
  ```
  =<current_balance_cell> - <prior_balance_cell>
  ```
- **`Percent Change`**:
  ```
  =IFERROR(<dollar_change_cell>/ABS(<prior_balance_cell>), "")
  ```

Use `SUMIF` rather than `VLOOKUP`. `VLOOKUP` returns only the first match, which would silently drop departments or other splits when the same account appears multiple times. `SUMIF` aggregates correctly and is self-documenting when the auditor inspects the cell.

All other Comparison columns (`Change Direction`, `Rank`, `Question Triggered`, `Question Trigger Reason`, `Suggested Client Questions`, `Analysis Notes`) remain static values written from Python.

---

## Change Direction

Using the Python numeric values, with the half-cent zero tolerance:

| Condition | Direction |
|---|---|
| Prior-year is zero, current-year is nonzero | `New Account` |
| Prior-year is nonzero, current-year is zero | `Closed Account` |
| Dollar Change > 0 | `Increase` |
| Dollar Change < 0 | `Decrease` |
| Dollar Change = 0 | `No Change` |

Note: `Increase` means the signed balance increased numerically, not necessarily that the natural account balance increased economically. Add notes when useful (sign flips, etc.).

---

## Ranking

Rank all rows, not just triggered rows. Sort by:

1. Absolute Dollar Change, descending.
2. Whether the account is New or Closed, descending.
3. Absolute Percent Change, descending (rows without a percent rank last).
4. Account Number, ascending.

Assign `Rank` 1..N after sorting. Sort the Comparison tab by `Rank` ascending.

---

## Question Trigger Logic

The Comparison tab includes every account. Questions are populated only when thresholds are met.

Let `abs_dollar_change = abs(Dollar Change)` and `abs_percent_change = abs(Percent Change)`.

- **Both thresholds, OR logic**: trigger when `abs_dollar_change ≥ dollar_threshold` OR `abs_percent_change ≥ percent_threshold`.
- **Both thresholds, AND logic**: trigger when both conditions are met.
- **Dollar only**: trigger when `abs_dollar_change ≥ dollar_threshold`.
- **Percent only**: trigger when `abs_percent_change ≥ percent_threshold`.
- **Neither (defaults)**: trigger when `abs_dollar_change ≥ $10,000` OR `abs_percent_change ≥ 20%`.

### Trivial-balance guardrail

Do not trigger a question on percent change alone when the dollar change is trivial. If the user has not specifically asked for percent-only review, suppress percent-only triggers when `abs_dollar_change < $1,000`.

### Trigger Reason

Populate `Question Trigger Reason` when triggered; leave blank otherwise. Examples:

- `Dollar threshold met`
- `Percent threshold met`
- `Dollar and percent thresholds met`
- `New account exceeds dollar threshold`
- `Closed account exceeds dollar threshold`

---

## Suggested Client Questions

Generate practical, concise questions a controller or auditor would actually ask, keyed off account direction first, then account-name keywords.

- **New Account**: "This account appears in the current year but not the prior year. What activity caused the new account to be created, and should any related prior-year amounts have been classified here?"
- **Closed Account**: "This account had a prior-year balance but no current-year balance. Was the activity discontinued, reclassified, settled, or moved to another account?"
- **Revenue** (`revenue`, `sales` in name or category): volume, pricing, customers, contracts, cutoff, reclassification.
- **Accounts Receivable** (`receivable`): aging, collections, billing cutoff, customers, credit memos, write-offs.
- **Inventory** (`inventory`): purchase volume, obsolescence, costing method, count adjustments, write-downs.
- **Prepaids / Other Assets** (`prepaid`, `other asset`): additions, amortization, reclassifications, cutoff.
- **Fixed Assets** (`fixed asset`, `depreciation`, `cip`): additions, disposals, CIP transfers, depreciation policy.
- **Payables / Accruals** (`payable`, `accrual`): vendor timing, unrecorded liabilities, reversals, new obligations, cutoff.
- **Debt** (`debt`, `loan`): new borrowings, principal payments, refinancing, covenants, interest classification.
- **Equity** (`equity`, `capital`, `retained earnings`): contributions, distributions, retained earnings activity, closing entries.
- **Payroll** (`payroll`, `wage`, `salary`): headcount, compensation, bonus/accrual, contractor vs employee.
- **Operating expenses** (`professional`, `software`, `fees`, `expense`): new vendors, one-time projects, renewals, implementation, reclassifications.
- **Fallback**: "This account changed materially. What underlying activity, timing, cutoff, settlement, or reclassification explains the variance?"

---

## Analysis Notes

Short, direct notes per row. Examples:

- `Current-year balance increased by $42,500 compared with prior year.`
- `Current-year balance decreased by $18,200 compared with prior year.`
- `Account appears to be new in the current year.`
- `Account had a prior-year balance but no current-year balance.`
- `Balance changed direction from debit to credit or credit to debit; review classification and underlying activity.`

---

## README Tab

Include:

- Workbook purpose
- Input file names
- Thresholds used and plain-English interpretation
- Prior-year and current-year row counts and normalized balance totals
- Comparison row count and questions-generated count
- Column mappings detected per file
- Balance convention used
- Duplicate-aggregation counts per file
- Validation status
- Any unresolved assumptions or exceptions

---

## Excel Formatting

Apply on each sheet:

- Freeze top row.
- Autofilter on the data range.
- Bold white header text on a dark blue fill (`1F4E78`), centered.
- Auto-sized column widths between 12 and 55 characters; wrap text on values longer than 70 characters.

Number formats on the Comparison tab:

- Currency: `$#,##0;[Red]($#,##0);-` for `Prior Year Balance`, `Current Year Balance`, `Dollar Change`.
- Percent: `0.0%;[Red](0.0%);-` for `Percent Change`.

Conditional formatting on the Comparison tab: pale yellow fill (`FFF2CC`) on every row where `Question Triggered = "Yes"`.

Sort the Comparison tab by `Rank` ascending.

Hide the `match_key` column on all three data sheets.

---

## Validation Checklist

Before saving the workbook, run these checks against the Python numeric values (not the formula strings):

1. Both input files loaded successfully.
2. Account name and balance (or debit + credit) columns were identified per file.
3. All balances are numeric.
4. Comparison row count equals the count of unique match keys across both years.
5. For every Comparison row: `Dollar Change == Current Year Balance − Prior Year Balance` (rounded to cents).
6. No `Materiality Score` column exists on any sheet.
7. `Suggested Client Questions` is blank when `Question Triggered = "No"`.
8. `Suggested Client Questions` is populated when `Question Triggered = "Yes"`.
9. Threshold logic was applied consistently with the user's selected `AND`/`OR`.
10. README documents thresholds, mappings, aggregation counts, and balance convention.

If any check fails, raise an error before saving. Do not write a partial workbook.