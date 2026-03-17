module riscv_core (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [31:0] instr,
    output logic [31:0] pc
);
    logic [31:0] rs1_data, rs2_data, rd_data;
    logic [4:0]  rs1_addr, rs2_addr, rd_addr;
    logic [3:0]  alu_op;
    logic        alu_src, reg_we;
    logic [31:0] imm, alu_b, alu_result;
    logic        alu_zero;

    pc_unit pc_u (
        .clk(clk),
        .rst_n(rst_n),
        .pc_load(1'b0), // No branches for now
        .pc_next(32'b0),
        .pc(pc)
    );

    decoder dec (
        .instr(instr),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .alu_op(alu_op),
        .alu_src(alu_src),
        .reg_we(reg_we),
        .imm(imm)
    );

    regfile regs (
        .clk(clk),
        .we(reg_we),
        .rs1_addr(rs1_addr),
        .rs2_addr(rs2_addr),
        .rd_addr(rd_addr),
        .rd_data(alu_result),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    assign alu_b = alu_src ? imm : rs2_data;

    alu alu_inst (
        .a(rs1_data),
        .b(alu_b),
        .alu_op(alu_op),
        .result(alu_result),
        .zero(alu_zero)
    );

endmodule
