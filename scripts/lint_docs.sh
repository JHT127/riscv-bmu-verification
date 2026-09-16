#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

if ! command -v npx >/dev/null 2>&1; then
  echo "Error: npx is required to run markdownlint-cli2." >&2
  exit 1
fi

echo "Linting Markdown files..."
npx --yes markdownlint-cli2 '**/*.md' '!**/node_modules/**'

echo "Checking for confidential files..."
if find docs/00_spec -type f \( -iname '*.pdf' -o -iname '*.docx' \) -print -quit | grep -q .; then
  echo "Error: a spec file was found in docs/00_spec/." >&2
  exit 1
fi

if find rtl -type f \( -iname '*.sv' -o -iname '*.v' -o -iname '*.svh' \) -print -quit | grep -q .; then
  echo "Error: an RTL source file was found in rtl/." >&2
  exit 1
fi

echo "Documentation checks passed."