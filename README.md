# MIPS Pipelined Processor

A 32-bit MIPS pipelined processor implemented in VHDL.

## Project Overview

The processor is designed with a 5-stage pipeline:
1. **IF (Instruction Fetch)**
2. **ID (Instruction Decode)**
3. **EX (Execution)**
4. **MEM (Memory Access)**
5. **WB (Write Back)**

The current implementation features a specialized program stored in ROM that calculates the number of '1' bits in a 32-bit binary representation of a number stored in memory.

## Component Descriptions

### Core Pipeline Stages

- **[IFetch.vhd](sources/IFetch.vhd)**: Manages the Instruction Fetch stage. It contains the Program Counter (PC) and interfaces with the instruction memory (ROM) to fetch the next instruction. It also handles branch and jump target addresses.
- **[IDecoder.vhd](sources/IDecoder.vhd)**: Implements the Instruction Decode stage. It extracts fields from the instruction, interfaces with the Register File to read operands, and performs sign/zero extension for immediate values.
- **[UC.vhd](sources/UC.vhd)**: The Main Control Unit. It decodes the opcode of the instruction and generates all the necessary control signals for the pipeline (e.g., RegWrite, MemWrite, ALUOp, etc.).
- **[ExUnit.vhd](sources/ExUnit.vhd)**: The Execution Unit. It performs arithmetic and logic operations using an ALU. It also calculates the branch target address and handles zero/comparison flags for branch instructions.
- **[MEM.vhd](sources/MEM.vhd)**: Manages the Memory Access stage. It provides an interface to the data memory (RAM) for `lw` (load word) and `sw` (store word) instructions.

### Memory & Storage

- **[ROM.vhd](sources/ROM.vhd)**: Instruction Memory. It contains the pre-compiled machine code for the bit-counting program.
- **[RAM.vhd](sources/RAM.vhd)**: Data Memory. A 64x32-bit synchronous RAM used for data storage during execution.
- **[RegisterFile.vhd](sources/RegisterFile.vhd)**: A bank of 32 general-purpose registers (32-bit wide) with dual-read and single-write ports.

### Peripherals & Hardware Interface

- **[test_env.vhd](sources/test_env.vhd)**: The top-level entity. It instantiates and connects all the modules together. It also implements the **Pipeline Registers** (`IF_ID`, `ID_EX`, `EX_MEM`, `MEM_WB`) as internal signals and handles the FPGA's I/O (buttons, switches, LEDs).
- **[SSD.vhd](sources/SSD.vhd)**: Seven-Segment Display controller. It multiplexes and displays 32-bit values (like PC, instruction, or register content) across the 8 digits of the FPGA's display.
- **[MPG.vhd](sources/MPG.vhd)**: Monopulse Generator. Used to debounce input buttons, allowing for a controlled, single-pulse clock signal to step through the execution.

### Other Files

- **[IF_ID.vhd](sources/IF_ID.vhd)**: A template file for the IF/ID pipeline register. *Note: In this implementation, pipeline registers are managed directly within `test_env.vhd`.*

## Program Logic

The processor is programmed to:
1. Load a 32-bit number from memory.
2. Iterate through each bit using a loop.
3. Use a mask and logical `AND` to check if the least significant bit is '1'.
4. Increment a counter if a '1' is found.
5. Shift the number to the right (`SRL`) and repeat until all bits are processed.
6. Store the final count back into memory.
7. Compare the result with an expected value to verify correctness.

## Hardware Requirements

The project is designed to be deployed on a Xilinx FPGA (specifically Artix 7) using:
- **Buttons**: `btn(0)` for step-by-step clocking (EN), `btn(1)` for Reset.
- **Switches**: `sw(7 downto 5)` to select which internal value to display on the SSD (PC, ALU Result, WriteBack Data, etc.).
- **LEDs**: Display the status of the control signals.
- **SSD**: Displays the 32-bit data selected by the switches.
