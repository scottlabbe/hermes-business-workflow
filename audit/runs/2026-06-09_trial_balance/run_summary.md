# Run Summary

## Task Attempted

Prepared a draft trial balance variance analysis workbook for the `trial_balance` intake job, including follow-up questions for accounts meeting both configured variance thresholds.

## Inputs Used

- `00_source/FY25 TB.csv`
- `00_source/FY26 TB.csv`
- `run_request.md`

## Outputs Created

- `01_variance_analysis/variance_analysis.xlsx`
- `01_variance_analysis/variance_analysis_metadata.json`
- `manifest.json`

## Checks Performed

- Confirmed both source files loaded and required columns were detected.
- Parsed signed currency balances, including parenthetical negatives.
- Compared unique account match keys across both years.
- Verified dollar changes against current-year less prior-year balances.
- Applied the configured AND threshold: absolute dollar change >= $200,000 and absolute percent change >= 20%.
- Confirmed suggested client questions are populated only for triggered rows.

## Limitations

- The workbook is a review aid and draft workpaper, not a final audit, compliance, legal, financial, or management conclusion.
- Percent change is blank when the prior-year balance is zero, so new accounts do not trigger the AND threshold unless a reviewer separately evaluates them.
- Account categories were taken from the source files when present and were not independently validated.

## Human Review Needed

- Review the 8 generated follow-up questions for business relevance and completeness.
- Inspect large non-triggered changes, new accounts, closed accounts, and sign-flip balances for possible follow-up outside the configured threshold rule.
- Confirm the source balance convention and whether signed balances should be interpreted differently by account type.

## Suggested Improvements

- Add preparer/reviewer signoff fields to the workbook if this will be retained as a formal workpaper.
- Add account-owner or department-owner fields to route follow-up questions.
- Consider separate review logic for new and closed accounts where percent change is not meaningful.
