#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if [ ! -d ".venv" ]; then
  echo "ERROR: .venv does not exist. Run scripts/bootstrap.sh first."
  exit 1
fi

source .venv/bin/activate

python - <<'PY'
import pandas
import openpyxl
print("Python dependencies OK")
PY

if [ ! -d "audit/variance_explainer" ]; then
  echo "ERROR: audit/variance_explainer folder not found."
  exit 1
fi

echo "Preflight passed."