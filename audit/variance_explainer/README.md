# Trial Balance Variance Explainer

This Hermes audit workflow creates a prior-year vs current-year trial balance variance review workbook.

Given two trial balance files, Hermes should:
- normalize both files into a common schema
- compare balances by account
- rank variances
- apply user-supplied or default question thresholds
- write a formatted workbook with source tabs, a comparison tab, and a README tab
- write `run_summary.md` for human review

Generated outputs should be saved under:

```text
runs/<run_id>/
  run_summary.md
  outputs/
    tb_variance_analysis.xlsx
```

The workbook is a review aid. It is not a final audit, accounting, legal, financial, or management conclusion.
