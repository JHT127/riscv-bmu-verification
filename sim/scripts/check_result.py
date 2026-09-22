#!/usr/bin/env python3
"""Fail a run on UVM errors, simulator/assertion errors, or missing completion."""

import re
import sys
from pathlib import Path


def passed(text):
    errors = re.findall(r"^UVM_ERROR\s*:\s*(\d+)", text, re.MULTILINE)
    fatals = re.findall(r"^UVM_FATAL\s*:\s*(\d+)", text, re.MULTILINE)
    return (
        len(errors) == len(fatals) == 1
        and errors[0] == fatals[0] == "0"
        and "Simulation complete via $finish" in text
        and not re.search(r"\*[EF],|UVM_(?:ERROR|FATAL) .* @", text)
    )


if __name__ == "__main__":
    log = Path(sys.argv[1])
    if not passed(log.read_text(errors="replace")):
        print(f"[run] FAIL: errors or incomplete simulation in {log}", file=sys.stderr)
        sys.exit(1)
    print(f"[run] PASS: {log}")
