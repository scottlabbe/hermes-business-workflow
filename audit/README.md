# Audit Workflows

This workspace contains public-safe Hermes workflows for audit-style review work.

Current workflows:
- `data-reliability/`: CSV key-field profiling with generated code and structured artifacts
- `variance_explainer/`: prior-year vs current-year trial balance variance workbook generation

Each workflow has its own `AGENTS.md` and should write meaningful run outputs under its own `runs/` folder. Outputs are review aids and require human validation before use.
