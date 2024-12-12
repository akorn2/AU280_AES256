`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2024 02:05:50 AM
// Design Name: 
// Module Name: AES_EX_Extractor
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


module AES_EX_Extractor(
    input clk,
    output QSFP0_FS,
    output QSFP0_OEB,
    output done
    );
    assign QSFP0_FS = 0;
    assign QSFP0_OEB = 0;
    reg [2047:0] plaintext;
    reg enable;
    wire [2047:0] ciphertext;
    reg state;
    always @(posedge clk) begin
        if(state==1'bZ || state==0) begin 
            state <= 2'b1; 
            plaintext <= 2048'h0;
            enable <= 1;
        end
        else if(state==1) begin 
            enable <= 0;
            plaintext <= 2048'h44616E6E792052656E73636820616E64204C65767920526F7A6D616E206172652074686520626573742070656F706C652049206B6E6F772E20427574207265616C6C7920616C6C2049206E65656420746F20646F20697320746F2070726F7669646520612062756E6368206F662072616E646F6D207465787420616E6420636861726163746572732C206C696B6520746869733A203F2A2121212A3F2E20596F7520776572656E277420657870656374696E672061206E6F726D616C2073656E74656E63652C207765726520796F753F20497427732061207465737420616E6420696E2041534349492049206E6565642032353620636861726163746572732E;
            state <= 0;
        end
    end
    AES_Extractor(plaintext, ciphertext);
endmodule
