module dummydecoder(
    input [31:0] instr,  // Full 32-b instruction
    output [5:0] op,     // some operation encoding of your choice
    output [4:0] rs1,    // First operand
    output [4:0] rs2,    // Second operand
    output [4:0] rd,     // Output reg
    input  [31:0] r_rv2, // From RegFile
    output [31:0] rv2,   // To ALU
    output we            // Write to reg
);

    assign op = {1'b0,instr[5],instr[14:12],instr[30]};
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign rd = instr[11:7];
    assign we = 1;          // For only ALU ops, can always set to 1
    // Should send either the value from the RegFile or the Imm value from Instr
    assign rv2 = (instr[5]) ? r_rv2 : {{20{1'b0}},instr[31:20]};

endmodule
