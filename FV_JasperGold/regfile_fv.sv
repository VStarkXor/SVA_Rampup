module regfile_fv (
    input  logic        clk,
    input  logic        we,
    input  logic [4:0]  rs1_addr,
    input  logic [4:0]  rs2_addr,
    input  logic [4:0]  rd_addr,
    input  logic [31:0] rd_data,
    input  logic [31:0] rs1_data,
    input  logic [31:0] rs2_data
);

    // ---------------------------------------------------------
    // 1. INVARIANTS: Things that must ALWAYS be true
    // ---------------------------------------------------------

    // Property: Register x0 is hardwired to zero
    // Description: If rs1_addr is 0, rs1_data must be 0 in the same cycle.
    property p_x0_zero_rs1;
        @(posedge clk) (rs1_addr == 5'd0) |-> (rs1_data == 32'd0);
    endproperty

    property p_x0_zero_rs2;
        @(posedge clk) (rs2_addr == 5'd0) |-> (rs2_data == 32'd0);
    endproperty

    a_x0_zero_rs1: assert property(p_x0_zero_rs1);
    a_x0_zero_rs2: assert property(p_x0_zero_rs2);

    // ---------------------------------------------------------
    // 2. FUNCTIONAL PROPERTIES: Correctness of operations
    // ---------------------------------------------------------

    // Property: Write and Read back (RAW - Read After Write)
    // Description: If we write to a register (not x0), in the next cycle, 
    // reading from that same register should yield the written data.
    // Note: This assumes a 1-cycle latency for writing to the register file.
    property p_write_read_back(addr);
        logic [31:0] data_at_write;
        @(posedge clk) 
        (we && rd_addr == addr && addr != 5'd0, data_at_write = rd_data) 
        |=> 
        (rs1_addr == addr) |-> (rs1_data == data_at_write);
    endproperty

    // We can use a generate block or specific instances for critical registers
    a_write_read_back_x1: assert property(p_write_read_back(5'd1));
    a_write_read_back_x31: assert property(p_write_read_back(5'd31));
    
    // Property: Stability
    // Description: If 'we' is low OR we are writing to a different register,
    // the current value of a register must remain unchanged in the next cycle.

    // this propewrty is written by me
    property stabilty;
        logic [31:0] write_address;
        logic [31:0] previous_data;
        @(posedge clk)
        (we == 0, write_address = rd_addr)
        // |-> (rs1_addr == write_address) |-> (previous_data = rs1_data) //
        // only assinngment in |-> is not allowed
        |-> (rs1_addr == write_address, previous_data = rs1_data)
        |=> (rs1_addr == write_address)
        |-> (rs1_data == previous_data);
    endproperty

    stability_NoOvverite: assert property(stabilty);


    // this property is written my LLM (Gemini 3)
    property p_reg_stability(addr);
        logic [31:0] current_val;
        @(posedge clk)
        ( (rs1_addr == addr), current_val = rs1_data ) // Capture current value
        ##1 ( !(we && rd_addr == addr) )                // If no write to this addr
        |-> ( (rs1_addr == addr) && (rs1_data == current_val) ); // Value must be same
    endproperty

    stability_NoOverrite_x1_Gemini: assert property(p_reg_stability(5'd1));

    // ---------------------------------------------------------
    // 3. COVERAGE: Proving the property is reachable
    // ---------------------------------------------------------
    
    // Cover: Ensure we actually see a write to a non-zero register
    c_write_active: cover property (@(posedge clk) we && rd_addr != 5'd0);

endmodule

// ---------------------------------------------------------
// BIND: Connects the FV module to the RTL module
// This keeps the original RTL clean and tool-agnostic.
// ---------------------------------------------------------
bind regfile regfile_fv regfile_fv_inst (.*);
