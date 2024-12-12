`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 10:04:25 PM
// Design Name: 
// Module Name: AES_EXY
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


module AES_EXY(
    input [511:0] rx_plain,
    input [511:0] rx_cipher,
    output [511:0] tx_plain,
    output [511:0] tx_cipher
    );
    wire [255:0] key;
    assign key = 256'h576F7264734D65616E696E676C65737341735769636B6564416E64437275656C;
    genvar j;
generate
    for(j = 0; j<4; j = j + 1) begin : loop
        AES_Encrypt #(256, 14, 8) tester(rx_plain[(512-(128*j)-1):(512-(128*(j+1)))], key,tx_cipher[(512-(128*j)-1):(512-(128*(j+1)))]);
        AES_Decrypt #(256, 14, 8) decrypter(rx_cipher[(512-(128*j)-1):(512-(128*(j+1)))], key,tx_plain[(512-(128*j)-1):(512-(128*(j+1)))]);
        //AES_Encrypt #(256, 14, 8) tester(in[(2048-(128*j)-1):(2048-(128*(j+1)))], 256'h576F7264734D65616E696E676C65737341735769636B6564416E64437275656C,enc_ans[(2048-(128*j)-1):(2048-(128*(j+1)))]);
        //AES_Decrypt #(256, 14, 8) decrypter(decrypt_txt[(2048-(128*j)-1):(2048-(128*(j+1)))], 256'h576F7264734D65616E696E676C65737341735769636B6564416E64437275656C,dec_ans[(2048-(128*j)-1):(2048-(128*(j+1)))]);
    end
endgenerate
endmodule
