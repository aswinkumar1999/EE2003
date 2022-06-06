module immgen(
  input [31:0] idata,
  output [31:0] imm
);

wire [6:0] opcode;
wire [2:0] funct3;

assign funct3 = idata[14:12];
assign opcode = idata[6:0];

// Old code will fail in some test cases ( unsigned cases )
// assign imm = {{20{1'b0}},idata[31:20]};

// Convert all different immediate inputs to 32-bit signed / unsigned ones based on the opcode
assign imm = (opcode == 7'b0100011) ? {{20{idata[31]}},idata[31:25],idata[11:7]} :  // Store operations
             (opcode == 7'b0000011 && (funct3 == 3'b100 || funct3 == 3'b101)) ?     // Load Unsigned
                {{20{1'b0}},idata[31:20]} : {{20{idata[31]}},idata[31:20]};         // Load Signed , ALU

endmodule
