# EVM Voting Machine — RTL to GDS

## Overview
A digital Electronic Voting Machine (EVM) implemented in Verilog HDL. The design supports four candidates, vote counting, and winner determination using a finite-state machine (FSM).

## Features
- Four candidate vote counters
- FSM with IDLE, VOTING, and RESULT states
- Synchronous voting controlled by the clock and vote-enable signal
- Winner determination based on vote totals
- Verilog testbench with automated checks
- RTL synthesis using Yosys
- Physical-design flow using OpenLane 2 and the Sky130 standard-cell library
- GDS layout output viewable in KLayout

## Project Structure
```text
evm_voting/
├── src/
│   └── voting_machine.v
├── tb/
│   └── tb_voting_machine.v
├── config.json
├── .gitignore
└── README.md
```

## Tools Used
- Verilog HDL
- Icarus Verilog
- GTKWave
- Yosys
- OpenLane 2
- SkyWater SKY130 PDK
- KLayout
- Docker Desktop with WSL2

## Run RTL Simulation
From the project root, compile and run the testbench:

```bash
iverilog -g2012 -o evm_sim src/voting_machine.v tb/tb_voting_machine.v
vvp evm_sim
```

To view the generated waveform:

```bash
gtkwave evm.vcd
```

## Run Yosys Synthesis
```bash
yosys -p 'read_verilog src/voting_machine.v; hierarchy -check -top voting_machine; proc; check; synth -top voting_machine; stat'
```

## Run OpenLane
Activate the OpenLane Python environment and run:

```bash
source ~/openlane312-venv/bin/activate
python -m openlane --dockerized config.json
```

OpenLane generates run-specific reports and layout outputs in the `runs/` directory.

## Validation
- RTL simulation and testbench checks: passed in the development environment
- Yosys structural check: reported zero problems
- OpenLane final flow: completed
- Antenna check: passed
- LVS: passed
- DRC: passed

Review timing, lint, and routing warnings before treating the design as ready for fabrication.

## Disclaimer
This is an educational VLSI project, not a certified voting system or a production-ready chip design.
