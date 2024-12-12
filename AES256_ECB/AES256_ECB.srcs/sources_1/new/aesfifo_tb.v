`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2024 03:44:29 AM
// Design Name: 
// Module Name: aesfifo_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module aesfifo_tb();
reg clk;
reg rst;
reg [127:0] w = 128'h576F7264734D65616E696E676C657373;
wire [127:0] r;
integer i;
initial begin
    clk = 0;
    rst = 0;
    #1;
    rst = 1;
    for(i = 0; i<32; i= i+1) begin : loop
        #3; clk = ~clk;
    end
end
aesfifo fife(clk, rst, w, r);
endmodule
