`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2024 02:55:27 AM
// Design Name: 
// Module Name: aesfifo
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

// Updated Verilog implementation for PCIe Gen3 x16 interface with FIFOs for asynchronous data access on Alveo U280

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2024 11:30:12 PM
// Design Name: 
// Module Name: aesfifo
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

//FIFO for receiving/transmitting input/output. This will be helpful to interact with XRT file
/*
module aesfifo #(parameter DATA_WIDTH=512, parameter DEPTH=1024) (
        input wr_clk,        // Write clock (Application clock domain)
        input rd_clk,            // Read clock (PCIe clock domain)
        input rst,
        input [DATA_WIDTH-1:0] din,       // Data in
        input wr_en,   // Write enable
        input rd_en,  // Read enable
        output [DATA_WIDTH-1:0] dout,        // Data out
        output empty,   //empty flag, used to tell the program to not read if nothing is there
        output full                  // FIFO full flag
    );
    //function to find floor of log2 (i.e. number of bits needed to represent value minus one)
    function integer flog2;
        input integer value;
              integer temp;
        begin
            temp = value - 1;
            for (flog2 = 0; temp > 1; flog2 = flog2 + 1) begin
                temp = temp >> 1;
            end
        end
    endfunction
    //endfunc
    reg full;
    reg [DATA_WIDTH-1:0] dout;
    //internal signals
    reg [DATA_WIDTH-1:0] FIFO [0:DEPTH-1];
    reg [flog2(DEPTH):0] read_pointer;
    reg [flog2(DEPTH):0] write_pointer;
    integer i;
    always @(posedge wr_clk or negedge rst) begin
        //active low reset, clear FIFO, access pointers and full register output
        if(~rst) begin
            for(i = 0; i<DEPTH; i = i+1) begin
                FIFO[i] <= 512'b0;
            end
            read_pointer <= 0;
            write_pointer <= 0;
            full <= 0;
        end
        else if(wr_en && ~full) begin
            FIFO[write_pointer] <= din;
            write_pointer <= (write_pointer>=DEPTH-1) ? (0) : (write_pointer + 1);
            //if incremeing write_pointer means read_pointer == write_pointer, we are officially full.
            if((read_pointer>0 && write_pointer+1==read_pointer) ||(read_pointer==0 && (write_pointer>=DEPTH-1))) full <= 1;
            else full <= 0;
        end
    end
    always @(posedge rd_clk) begin
        //because we're using active low rst, when rst is 1 we might be able to read
        if(rst==1'b1 && rd_en && ~empty) begin
            dout <= FIFO[read_pointer];
            read_pointer <= (read_pointer>=DEPTH-1) ? (0) : (read_pointer + 1);
            //if we read from a full FIFO, the fifo is no longer full
            if(full) full <= 0;
        end
    end
    //empty has the same condition as full (read_pointer==write_pointer) but is defined as primarily not full.
    //if we keep writing to the FIFO and that causes read_pointer and write_pointer to meet, then we're full.
    assign empty = read_pointer == write_pointer && ~full;
endmodule
*/
//BELOW CODE WORKS FOR THIS MODULE AS TOP

module aesfifo(
    input clk,
    input rst,
    input [127:0] indata,
    output [127:0] odata
    );
    reg [127:0] odata;
    wire [127:0] encryptor;
    wire [127:0] decryptor;
    reg state;
    //This design can be converted to an asynchronous one; simply remove the clk/rst signals,
    //  delete the always block, change odata to a wire and assign it to the output of the desired function (AES_Encrypt for ciphertext, AES_Decrypt for plaintext).
    //  The current implementation swaps which value it shows (plaintext/ciphertext) every clock cycle.
    AES_Encrypt #(256, 14, 8) tester(indata, 256'h576F7264734D65616E696E676C65737341735769636B6564416E64437275656C,encryptor);
    AES_Decrypt #(256, 14, 8) decrypter(encryptor, 256'h576F7264734D65616E696E676C65737341735769636B6564416E64437275656C,decryptor);
    always @(posedge clk or negedge rst) begin
        if(~rst) begin
            state <= 0;
            odata <= 0;
        end
        else if(state) begin
            odata <= encryptor;
            state <= ~state;
        end
        else begin
            odata <= decryptor;
            state <= ~state;
        end
    end
endmodule
