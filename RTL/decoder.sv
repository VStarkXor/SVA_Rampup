module decoder (
    input  logic [31:0] instr,
    output logic [4:0]  rs1_addr,
    output logic [4:0]  rs2_addr,
    output logic [4:0]  rd_addr,
    output logic [3:0]  alu_op,
    output logic        alu_src, // 0: rs2, 1: imm
    output logic        reg_we,
    output logic [31:0] imm
);
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];

    assign rs1_addr = instr[19:15];
    assign rs2_addr = instr[24:20];
    assign rd_addr  = instr[11:7];

    always_comb begin
        alu_op = 4'b0000;
        alu_src = 1'b0;
        reg_we = 1'b0;
        imm = 32'b0;

        case (opcode)
            7'b0110011: begin // R-type
                reg_we = 1'b1;
                alu_src = 1'b0;
                alu_op = {funct7[5], funct3};
            end
            7'b0010011: begin // I-type ALU
                reg_we = 1'b1;
                alu_src = 1'b1;
                alu_op = {1'b0, funct3}; // Simplified, SRAI needs more care
                imm = {{20{instr[31]}}, instr[31:20]};
            end
            // More types could be added here
            default: ;
        endcase
    end
endmodule
