#!/usr/bin/env python3
"""Summarize the configured runs and record the exact verification inputs."""

import csv
import hashlib
import json
import re
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def match(text, pattern, default=""):
    found = re.search(pattern, text, re.MULTILINE)
    return found.group(1) if found else default


def summarize(config):
    rows = []
    for line in config.read_text().splitlines():
        fields = line.split("#", 1)[0].split()
        if not fields:
            continue
        test, seed = fields
        log_path = ROOT / "results/logs" / f"{test}_{seed}.log"
        text = log_path.read_text(errors="replace")
        errors = match(text, r"^UVM_ERROR\s*:\s*(\d+)")
        fatals = match(text, r"^UVM_FATAL\s*:\s*(\d+)")
        effective_seed = match(text, r"SVSEED set from command line: (\d+)")
        completed = "Simulation complete via $finish" in text
        if not errors or not fatals or effective_seed != seed or not completed:
            raise ValueError(f"incomplete run or wrong effective seed: {log_path}")
        assertions = text.count("*E,ASRTST")
        row = {
            "test": test, "seed": seed, "effective_seed": effective_seed,
            "status": "FAIL" if int(errors) or int(fatals) or re.search(r"\*[EF],", text) else "PASS",
            "comparisons": match(text, r"compared=(\d+)"),
            "mismatches": match(text, r"mismatched=(\d+)"),
            "uvm_errors": errors, "uvm_fatals": fatals,
            "assertion_failures": assertions,
            "functional_coverage_percent": match(text, r"functional coverage=([\d.]+)%"),
            "model_checks": match(text, r"model checks=(\d+)"),
        }
        rows.append(row)
    if not rows:
        raise ValueError("empty regression")
    out = ROOT / "results/reports"
    out.mkdir(parents=True, exist_ok=True)
    with (out / "regression_summary.csv").open("w", newline="") as stream:
        writer = csv.DictWriter(stream, fieldnames=rows[0].keys())
        writer.writeheader()
        writer.writerows(rows)
    sources = {}
    for directory in ["rtl", "tb", "sim", "regression/configs"]:
        for path in sorted((ROOT / directory).rglob("*")):
            if path.is_file() and (path.suffix in {".sv", ".svh", ".vh", ".f", ".py", ".sh", ".cfg"} or path.name == "Makefile"):
                if any(part in {"xcelium.d", "__pycache__"} for part in path.parts):
                    continue
                sources[str(path.relative_to(ROOT))] = hashlib.sha256(path.read_bytes()).hexdigest()
    spec = ROOT / "docs/00_spec/BMU_Specification_v1.2.pdf"
    sources[str(spec.relative_to(ROOT))] = hashlib.sha256(spec.read_bytes()).hexdigest()
    manifest = {
        "generated_utc": datetime.now(timezone.utc).isoformat(),
        "source_commit": subprocess.check_output(["git", "rev-parse", "HEAD"], cwd=ROOT, universal_newlines=True).strip(),
        "source_worktree_status": subprocess.check_output(
            ["git", "status", "--porcelain", "--", "rtl", "tb", "sim", "regression/configs"], cwd=ROOT, universal_newlines=True).strip(),
        "config": str(config.resolve().relative_to(ROOT)),
        "simulator": match(text, r"TOOL:\s+(xrun.*): Started"),
        "top": "bmu_tb_top", "dut": "bmu_tb_top.dut",
        "runs": len(rows), "passed": sum(row["status"] == "PASS" for row in rows),
        "failed": sum(row["status"] == "FAIL" for row in rows),
        "source_sha256": sources,
        "log_sha256": {
            f"results/logs/{row['test']}_{row['seed']}.log": hashlib.sha256(
                (ROOT / f"results/logs/{row['test']}_{row['seed']}.log").read_bytes()).hexdigest()
            for row in rows
        },
    }
    (out / "run_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print(f"[summary] {len(rows)} runs: {manifest['passed']} passed, {manifest['failed']} failed")


if __name__ == "__main__":
    summarize(Path(sys.argv[1]))
