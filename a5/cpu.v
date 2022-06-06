module cpu (
    input clk,
    input reset,
    output [31:0] iaddr,
    input [31:0] idata,
    output [31:0] daddr,
    input [31:0] drdata,
    output [31:0] dwdata,
    output [3:0] dwe
);
//  CPU Registers
reg [31:0] iaddr;

//Control Unit - Wires
wire  memread;
wire  mem2reg;
wire  [5:0] ALUop;
wire alusrc;
wire regwrite;
wire [3:0] memwrite;

// Regfile - Wires
wire [31:0] regwdata;
wire [31:0] datawire1;
wire [31:0] datawire2;

// IMM - Wires
wire [31:0] imm;

// ALU - Wires
wire [31:0] alu_out;

// ldata - Wires
wire [31:0] ldata;

// Modules

// Control
control CONTROL(
  .idata(idata),
  .memread(memread),
  .mem2reg(mem2reg),
  .ALUop(ALUop),
  .alusrc(alusrc),
  .regwrite(regwrite),
  .memwrite(memwrite)
	);
// Register
regfile REGFILE(
  	.rs1(idata[19:15]),
  	.rs2(idata[24:20]),
  	.rd(idata[11:7]),
  	.we(regwrite),
    .wdata(regwdata),
  	.rv1(datawire1),
  	.rv2(datawire2),
    .clk(clk)
  	);

// Offset calculation
immgen IMMGEN(
  .idata(idata),
  .imm(imm)
  );

// Arithmetic Logic Unit

alu32 ALU32(
  .op(ALUop),
	.rv1(datawire1),
	.rv2( alusrc ? imm : datawire2),
  .rvout(alu_out)
	);

// Store Operations
assign dwe = (memwrite == 4'b1111 && daddr[1:0]== 2'b00) ? 4'b1111:
  				(memwrite == 4'b0011 && daddr[1:0]== 2'b00) ? 4'b0011:
  				(memwrite == 4'b0011 && daddr[1:0]== 2'b10) ? 4'b1100:
  				(memwrite == 4'b0001 && daddr[1:0]== 2'b00) ? 4'b0001:
  				(memwrite == 4'b0001 && daddr[1:0]== 2'b01) ? 4'b0010:
  				(memwrite == 4'b0001 && daddr[1:0]== 2'b10) ? 4'b0100:
  				(memwrite == 4'b0001 && daddr[1:0]== 2'b11) ? 4'b1000: 4'b0000;

assign dwdata = datawire2 ;

// Daddr = ( rs1 + imm % 4096 ) , First statement corresponds to load while second to store.
assign daddr = (( 32'h00000fff ) & (datawire1+imm));

// Load Operations

// LW,LH,LB
assign ldata =  ((idata[14:12] === 3'b001 || idata[14:12] === 3'b101) && mem2reg) ?  // LH , LHU
                ( 32'h0000fff & (drdata >> (daddr[1:0] * 8))) :
                ((idata[14:12] === 3'b000 || idata[14:12] === 3'b100) && mem2reg) ?  // LB , LBU
                ( 32'h000000ff & (drdata >> (daddr[1:0] * 8))) :
                drdata;                                                              // LW

// If load operation -> ldata , else alu_out
assign regwdata = (reset) ? 0 : mem2reg ? ldata  : alu_out;


always @(posedge clk) begin
    if (reset) begin
        iaddr <= 0;
    end else begin
        iaddr <= iaddr + 4;

    end
end

endmodule
