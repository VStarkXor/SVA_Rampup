# RISC-V SVA Formal Verification Plan

This repository is dedicated to learning SystemVerilog Assertions (SVA) through the formal verification of a simple RISC-V core, specifically targeting SymbiYosys (open-source) and JasperGold (industrial) toolchains.

## Phase 1: RTL Implementation (`/RTL`)
Implement a simple RV32I subset core designed for formal verification clarity.
- **Architecture**: Single-cycle RISC-V (RV32I subset: ALU, Branches, Loads/Stores).
- **Modules**:
  - `riscv_core.sv`: Top-level integration.
  - `alu.sv`: Arithmetic and logic operations.
  - `regfile.sv`: 32-bit register file (x0-x31).
  - `pc_unit.sv`: Program counter logic with branch/jump support.
  - `decoder.sv`: Instruction decoding logic.

## Phase 2: SVA Property Specification (`/FV`)
Define properties to verify the functional correctness of the core.
- **ALU Properties**: Verify result correctness for all ALU opcodes (e.g., `ADD`, `SUB`, `AND`, `OR`).
- **Register Integrity**: Ensure `x0` remains zero and registers are correctly updated after a write operation.
- **Control Flow**:
  - Verify branch logic (e.g., `BEQ`, `BNE`) correctly updates the PC based on ALU comparison results.
  - Verify `JAL`/`JALR` target PC calculation and return address storage.
- **Safety Properties**:
  - Check for invalid instruction handling.
  - Ensure memory accesses are within bounds and aligned (if applicable).
- **Liveness Properties**: (For multi-cycle or pipelined versions) Ensure instruction completion.

## Phase 3: Verification with SymbiYosys
- Create `.sby` configuration files.
- Adapt SVA for SymbiYosys limitations (e.g., using simpler `assert property` or `always @(posedge clk) assert` patterns if needed).
- Run `bmc` (Bounded Model Checking) and `prove` (Induction) engines.

## Phase 4: Verification with JasperGold
- Create JasperGold TCL scripts for automated verification.
- Utilize JasperGold's advanced visualization and debug features.
- Compare performance and coverage between SymbiYosys and JasperGold.

## Action Items
1. [x] Update `README.md` with the formal verification plan.
2. [x] Create `/RTL` directory and implement the RISC-V core modules.
3. [ ] Create `/FV` directory and implement SVA properties.
4. [ ] Set up SymbiYosys and JasperGold environment/scripts.
5. [ ] Perform initial verification runs and debug RTL/SVA.
