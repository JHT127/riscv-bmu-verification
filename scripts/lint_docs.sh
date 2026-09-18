#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

if ! command -v npx >/dev/null 2>&1; then
  echo "Error: npx is required to run markdownlint-cli2." >&2
  exit 1
fi

echo "Linting Markdown files with a Node 22-compatible runtime..."
# The project docs intentionally use compact/noisy markdown patterns; use the public
# npm registry to avoid the host-specific GitHub trust prompt and keep the exact
# markdownlint version stable across local and CI environments.
npx --yes --package=node@22 --package=markdownlint-cli2@0.23.2 -- markdownlint-cli2 --config .markdownlint.json "**/*.md" "!**/node_modules/**"

echo "Checking for confidential files..."
if find docs/00_spec -type f \( -iname '*.pdf' -o -iname '*.docx' \) -print -quit | grep -q .; then
  approved_spec='docs/00_spec/BMU_Specification_v1.2.pdf'
  unexpected_spec=$(find docs/00_spec -type f \( -iname '*.pdf' -o -iname '*.docx' \) ! -path "$approved_spec")
  if [[ -n "$unexpected_spec" ]]; then
    echo "Error: an unapproved specification file was found:" >&2
    printf '%s\n' "$unexpected_spec" >&2
    exit 1
  fi
fi

if find rtl -type f \( -iname '*.sv' -o -iname '*.v' -o -iname '*.svh' \) -print -quit | grep -q .; then
  unexpected_rtl=$(find rtl -type f \( -iname '*.sv' -o -iname '*.v' -o -iname '*.svh' \) \
    ! -path 'rtl/Bit_Manipulation_Unit.sv' \
    ! -path 'rtl/rtl_def.sv' \
    ! -path 'rtl/rtl_defines.sv' \
    ! -path 'rtl/rtl_lib.sv' \
    ! -path 'rtl/rtl_param.sv' \
    ! -path 'rtl/rtl_pdef.sv')
  if [[ -n "$unexpected_rtl" ]]; then
    echo "Error: an unapproved RTL source file was found:" >&2
    printf '%s\n' "$unexpected_rtl" >&2
    exit 1
  fi
fi

echo "Documentation checks passed."