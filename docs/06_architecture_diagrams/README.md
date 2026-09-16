# Architecture Diagrams

Diagrams to add here (as `.png`/`.svg`, exported from draw.io, Visio,
or hand-drawn + scanned — doesn't need to be fancy, needs to be clear):

- **BMU block diagram** — ports, `ap` struct fields, combinational core
  and `result_ff` register
- **Timing diagram** — `valid_in` / `result_ff` / `error` relationship
  across cycles, including hold and reset cases
- **UVM testbench architecture** — agent, driver, monitor, sequencer,
  reference model, scoreboard, coverage collector, and how they connect
  to `top_tb.sv`
- **Sequence hierarchy** — how directed/random sequences layer on the
  base sequence per operation family
