# RISC-V Core RTL Documentation

This directory contains a simplified single-cycle RISC-V core (RV32I subset) designed for formal verification learning.

## Module Overview

### 1. `riscv_core.sv` (Top-Level)
The top-level module that integrates all sub-modules. It manages the data path and control flow between the PC unit, decoder, register file, and ALU.

- **Inputs**: `clk`, `rst_n`, `instr` (32-bit instruction)
- **Outputs**: `pc` (32-bit Program Counter)

### 2. `alu.sv` (Arithmetic Logic Unit)
Handles all arithmetic and logical operations based on the `alu_op` signal from the decoder.

- **Operations**:
    - `ADD`, `SUB`
    - `SLL`, `SRL`, `SRA` (Logical/Arithmetic Shifts)
    - `SLT`, `SLTU` (Set Less Than)
    - `AND`, `OR`, `XOR`
- **Outputs**: `result` (32-bit), `zero` (flag)

### 3. `regfile.sv` (Register File)
A bank of 32-bit registers (x0 to x31).
- **Special Case**: `x0` is hardwired to zero. Writes to `x0` are ignored.
- **Ports**: Two read ports (`rs1_data`, `rs2_data`) and one write port (`rd_data`).

### 4. `pc_unit.sv` (Program Counter)
Manages the instruction address.
- Increments by 4 every cycle by default.
- Supports reset to `0x00000000`.
- Includes placeholders for `pc_load` and `pc_next` (to be used for branches and jumps).

### 5. `decoder.sv` (Instruction Decoder)
Decodes the 32-bit RISC-V instruction into control signals and immediate values.
- **Supported Formats**: R-type and I-type (ALU-immediate) instructions.
- **Fields Extracted**: `rs1`, `rs2`, `rd`, `opcode`, `funct3`, `funct7`, and sign-extended `imm`.

## Data Path Summary
1. The `pc_unit` provides the current `pc`.
2. An external memory (not included) would provide the `instr` based on the `pc`.
3. The `decoder` splits the `instr` into register addresses, immediate values, and control signals (`alu_op`, `alu_src`, `reg_we`).
4. The `regfile` provides `rs1_data` and `rs2_data`.
5. The `alu` performs the operation on `rs1_data` and either `rs2_data` or the immediate value (`imm`).
6. The `alu_result` is written back to the `regfile` at address `rd_addr` if `reg_we` is high.

## Formal Verification Focus
The simplicity of this RTL is intentional. It allows focusing on writing SVA for:
- Correctness of ALU results.
- Register file integrity (especially the `x0` property).
- Proper decoding of various instruction formats.
- Basic control flow (sequential PC updates).
