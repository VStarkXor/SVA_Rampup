# JasperGold Run Script

# 1. Clear previous session
clear -all

# 2. Analyze Design Files (RTL)
# We use -sv to enable SystemVerilog support
analyze -sv ../RTL/regfile.sv

# 3. Analyze Properties (FV)
analyze -sv regfile_fv.sv

# 4. Elaborate the design
# JasperGold will automatically handle the 'bind' statement in regfile_fv.sv
elaborate -top regfile

# 5. Setup Clock and Reset
# Since regfile.sv doesn't have a hardware reset, we'll just define the clock.
# If you add a reset later, you would use: reset -expression {!rst_n}
clock clk

# 6. (Optional) Initial state for formal
# Without a reset, JasperGold starts with registers in an arbitrary state.
# You can use 'reset -none' if there is truly no reset.
reset -none

# 7. Start the proof engines
# This will try to prove all asserts and check all covers
prove -all

# 8. (Optional) Open the UI to view results
# Note: Usually run in GUI mode anyway, but this is good for documentation.
# gui_show
