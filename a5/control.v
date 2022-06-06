module control (
    input [31:0] idata,
    output  memread,
    output  mem2reg,
    output  [5:0] ALUop,
    output alusrc,
    output regwrite,
    output [3:0] memwrite
);


wire [6:0] opcode;
wire [2:0] funct3;
assign funct3 = idata[14:12];
assign opcode = idata[6:0];

//  Regwrite
assign regwrite = (opcode == 7'b0000011 || opcode == 7'b0010011 || opcode == 7'b0110011 );
//  Memwrite
assign memwrite = (opcode == 7'b0100011 && funct3 == 3'b010) ? 4'b1111 :
                  (opcode == 7'b0100011 && funct3 == 3'b001) ? 4'b0011 :
                  (opcode == 7'b0100011 && funct3 == 3'b000) ? 4'b0001 : 4'b0000;

// Memtoreg
assign mem2reg = (opcode == 7'b0000011);
// MemRead - Redundant but not removing as i've exhausted the 5 lines limit
assign memread = (opcode == 7'b0000011);
//alusrc - ALU Source for Second Alu operation  ? Immediate value : Register 
assign alusrc = (opcode == 7'b0010011) ;
//ALUop - Decididng the ALU operation code
assign ALUop = {1'b0,idata[5],idata[14:12],idata[30]};

endmodule
