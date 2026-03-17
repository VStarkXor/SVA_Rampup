# JasperGold Run Script for PC Unit Level 2

# 1. Clear previous session
clear -all

# 2. Analyze Design Files (RTL)
analyze -sv RTL/pc_unit.sv

# 3. Analyze Properties (FV)
analyze -sv FV_JasperGold/pc_unit_fv.sv

# 4. Elaborate the design
elaborate -top pc_unit

# 5. Setup Clock and Reset
clock clk
reset -expression {!rst_n}

# 6. Start the proof engines
prove -all
