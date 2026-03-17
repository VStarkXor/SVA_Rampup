module pc_unit (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        pc_load,
    input  logic [31:0] pc_next,
    output logic [31:0] pc
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc <= 32'h0;
        end else if (pc_load) begin
            pc <= pc_next;
        end else begin
            pc <= pc + 4;
        end
    end
endmodule
