module regfile(
    input [4:0] rs1,     // address of first operand to read - 5 bits
    input [4:0] rs2,     // address of second operand
    input [4:0] rd,      // address of value to write
    input we,            // should write update occur
    input [31:0] wdata,  // value to be written
    output [31:0] rv1,   // First read value
    output [31:0] rv2,   // Second read value
    input clk            // Clock signal - all changes at clock posedge
);
    // Desired function
    // rv1, rv2 are combinational outputs - they will update whenever rs1, rs2 change
    // on clock edge, if we=1, regfile entry for rd will be updated

    integer i;
    reg [31:0] register[31:0];
    // Initialise all registers to zero
    initial begin
      for  (i=0; i<32; i=i+1) begin
          register[i] = 0;
      end
    end
    // Read value from Registers
    assign rv1 = register[rs1];
    assign rv2 = register[rs2];
    // Write value to registers
    always@(posedge clk)
      if(we)
        begin
          register[rd] <= wdata;
          // Added Line
          register[0] <= 0;

        end

endmodule
