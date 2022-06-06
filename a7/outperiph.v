`timescale 1ns/1ps
`define OUTFILE "output.txt"

module outperiph (
    input clk,
    input reset,
    input [31:0] daddr,
    input [31:0] dwdata,
    input [3:0] dwe,
    output [31:0] drdata
);

    // Implement the peripheral logic here: use $fwrite to the file output.txt
    // Use the `define above to open the file so that it can be
    // overridden later if needed

    // Return value from here (if requested based on address) should
    // be the number of values written so far
    integer tmp;
    reg [31:0] drdata;

    initial begin
        drdata = 0;
        tmp = $fopen(`OUTFILE,"w");
    end

    always @(posedge clk) begin
        if(dwe) begin
            $fwrite(tmp,"%c",dwdata);
            drdata <= drdata + 1;
        end
    end

endmodule
