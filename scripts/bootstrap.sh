#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v python3 >/dev/null 2>&1; then
  echo "ERROR: python3 is not installed."
  exit 1
fi

if ! python3 -m pip --version >/dev/null 2>&1; then
  echo "pip is missing. Install it with:"
  echo "  sudo apt-get update && sudo apt-get install -y python3-pip python3-venv"
  exit 1
fi

if [ ! -d ".venv" ]; then
  python3 -m venv .venv
fi

source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

echo "Bootstrap complete."