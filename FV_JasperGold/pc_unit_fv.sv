module pc_unit_fv (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        pc_load,
    input  logic [31:0] pc_next,
    input  logic [31:0] pc
);

    // ---------------------------------------------------------
    // 1. RESET PROPERTIES
    // ---------------------------------------------------------

    // Property: PC must be 0 after reset
    // Use $past to check the state of rst_n in the previous cycle
    property p_pc_after_reset;
        @(posedge clk) $fell(rst_n) |=> (pc == 32'h0);
    endproperty
    a_pc_after_reset: assert property(p_pc_after_reset);

    // Property: PC must remain 0 while reset is active (asynchronous reset check)
    // Note: Since the RTL uses 'always_ff @(posedge clk or negedge rst_n)', 
    // it's an asynchronous reset.
    property p_pc_during_reset;
        @(posedge clk) !rst_n |-> (pc == 32'h0);
    endproperty
    a_pc_during_reset: assert property(p_pc_during_reset);

    // ---------------------------------------------------------
    // 2. FUNCTIONAL PROPERTIES (Sequential Execution)
    // ---------------------------------------------------------

    // Property: Sequential PC Increment
    // Description: If pc_load is low, the PC must increment by 4.
    // We use 'disable iff (!rst_n)' to ignore this check during reset.
    property p_pc_increment;
        @(posedge clk) disable iff (!rst_n)
        (!pc_load) |=> (pc == $past(pc) + 4);
    endproperty
    a_pc_increment: assert property(p_pc_increment);

    // ---------------------------------------------------------
    // 3. BRANCH/JUMP PROPERTIES (Load PC)
    // ---------------------------------------------------------

    // Property: PC Load
    // Description: If pc_load is high, the PC must become pc_next.
    property p_pc_load;
        @(posedge clk) disable iff (!rst_n)
        (pc_load) |=> (pc == $past(pc_next));
    endproperty
    a_pc_load: assert property(p_pc_load);

    // ---------------------------------------------------------
    // 4. STABILITY PROPERTIES (The "Pro" Flavor)
    // ---------------------------------------------------------

    // Property: PC Stability
    // If no load and we are at the very first cycle after reset, 
    // we use $stable or just check the value.
    // Let's check if PC is stable when clock is not toggling (conceptually)
    // but in SVA we usually check cycle-to-cycle changes.
    
    // Cover: Ensure we see a PC load happen
    c_pc_load_seen: cover property (@(posedge clk) disable iff (!rst_n) pc_load);

endmodule

// BIND
bind pc_unit pc_unit_fv pc_unit_fv_inst (.*);
