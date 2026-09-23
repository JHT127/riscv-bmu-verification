# Regression

Each configuration contains `<test_name> <seed>` pairs. Blank lines and `#` comments are allowed.

| Configuration | Purpose |
|---|---|
| `full.cfg` | Default 26-run submission regression |
| `nightly.cfg` | Short legal, timing, guard, and random regression |
| `bugs.cfg` | Nine isolated DUT bug reproducers |
| `directed.cfg`, `gaps.cfg` | Focused directed/gap tests |
| `legal_random.cfg`, `corner_random.cfg`, `error_random.cfg` | Focused random families |

```bash
make -C sim regression
make -C sim regression CONFIG=../regression/configs/bugs.cfg
```

The full regression returns nonzero on the original buggy DUT. Review individual test status, scoreboard transactions, and assertion failures. Current submission results are retained in [regression_summary.csv](../results/reports/regression_summary.csv); effective seeds and source/log hashes are checked and recorded.
