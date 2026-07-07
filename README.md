# UART UVM Verification Environment
This repository contains a robust, scalable Universal Verification Methodology (UVM) testbench designed to fully verify a full-duplex UART IP Core. The environment utilizes modern SystemVerilog/UVM constraints, randomized delays, and functional coverage tracking to achieve high verification quality.
## Design Under Test (DUT) Specification
The DUT is a full-duplex UART transceiver supporting standard async communication with the following fixed parameters:
 * Data Width: 8 bits
 * Parity: None (no parity bit)
 * Stop Bits: 1 stop bit
 * Default Baud Rate: 115200 (at 50 MHz clock)
### Interface Ports
| Port Name | Direction | Width | Description |
|---|---|---|---|
| clk | input | 1 | Global System Clock (50 MHz) |
| rst | input | 1 | Synchronous Active-High Reset |
| data_snd | input | 8 | Input byte data to be transmitted via TX |
| tx_valid | input | 1 | Control signal: Enable/Start transmission |
| tx | output | 1 | Serial output line (TX bitstream) |
| tx_ready | output | 1 | Status signal: Byte transmission completed / ready for next |
| data_rcv | output | 8 | Received output byte data decoded from RX |
| rx | input | 1 | Serial input line (RX bitstream) |
| rx_done | output | 1 | Status signal: Byte receiving successfully completed |
## Verification Architecture (UVM Environment)
The verification environment consists of a top-level uart_env managing two separate UVM Agents for full-duplex independent TX/RX traffic verification:
 1. UART TX Agent (Active): It works with the uart transmitter.
 2. UART RX Agent (Active): It works with the uart receiver.
### Key Verification Features:
 * Randomized Inter-packet Delays: Sequences automatically inject constrained random delays between data transmissions to verify the design's robust handling of idle states.
 * Functional Coverage (100% Target): Tracks comprehensive coverage across all transmitted and received 8-bit values.
## Simulation Outputs & Log
All simulation results are structured inside the dedicated sim_uvm/ output directory to prevent workspace clutter:
 * Simulation Log (sim/*.log): Captures complete simulation transcript data, UVM reporter tables, uvm_info logs, and fatal/error/warning severity summaries.
 * Functional Coverage Report (sim/cov/): Generates .ucdb coverage files providing explicit state coverage data metrics.
## How to Run (Makefile Targets)
The project includes an automated Makefile for compilation, execution, and workspace cleanup. The simulation directory will be created automaticly when you run makefile.
### 1. Run Simulation in Console Mode (CLI)
Executes tests in text mode without loading the graphical layout. Best suited for regression checks or fast runs.
```
make run
```
### 2. Run Simulation in Graphical Mode (GUI)
Launches the QuestaSim GUI window, configures wave groupings, runs all steps to the end without annoying dialog prompts, unfolds the waveform folders, and centers time axes automatically (Zoom Full).
```
make gui
```
### 3. Clear Workspace
Cleans out generated execution files, UCDB coverage reports, and work directories without altering the underlying core directory layout structure.
```
make clean
```
