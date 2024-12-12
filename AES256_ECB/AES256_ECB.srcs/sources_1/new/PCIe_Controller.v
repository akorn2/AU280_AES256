`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2024 10:17:13 PM
// Design Name: 
// Module Name: PCIe_Controller
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
module PCIe_Controller();
endmodule
//UNUSED, BUT WOULD BE HELPFUL IN INTERACTING WITH PCIE4C MODULE
/*
module PCIe_Controller(
    input clk,                  // PCIe clock signal
    input app_clk,              // Application clock signal
    input rst,                // Reset signal
    input [127:0] packet_in,    // Input packet data (from FPGA application)
    input packet_in_valid,      // Input packet valid signal
    output [127:0] packet_out,   // Output packet data (to FPGA application)
    output packet_out_valid,     // Output packet valid signal
    // Detailed PCIe signals (i.e. application facing)
    input [511:0] pcie_rx_tdata,  // PCIe received data (512-bit TLP data bus)
    input [15:0] pcie_rx_tkeep,  // Byte enable for pcie_rx_tdata
    input pcie_rx_tlast,         // End of TLP signal
    input pcie_rx_tvalid,        // Data valid signal
    output pcie_rx_tready,       // Ready signal for RX TLP data
    output [511:0] pcie_tx_tdata, // PCIe transmitted data (512-bit TLP data bus)
    output [15:0] pcie_tx_tkeep, // Byte enable for pcie_tx_tdata
    output pcie_tx_tlast,        // End of TLP signal
    output pcie_tx_tvalid,       // Data valid signal
    input pcie_tx_tready         // Ready signal for TX TLP data
);
    //parameters
    parameter DATA_WIDTH = 128;
    parameter FIFO_DEPTH = 1024;
    //Internal Signals
    reg [127:0] packet_out;
    reg packet_out_valid;
    
    // FIFO signals for RX and TX
    wire [511:0] rx_fifo_dout; // RX FIFO data output
    wire rx_fifo_empty;        // RX FIFO empty flag
    reg rx_fifo_rd_en;        // RX FIFO read enable

    reg [511:0] tx_fifo_din;  // TX FIFO data input
    wire tx_fifo_full;         // TX FIFO full flag
    reg tx_fifo_wr_en;        // TX FIFO write enable

    // RX FIFO: PCIe RX -> Application
    aesfifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(FIFO_DEPTH)
    ) rx_fifo (
        .wr_clk(clk),            // Write clock (PCIe clock domain)
        .rd_clk(app_clk),        // Read clock (Application clock domain)
        .rst(rst),
        .din(pcie_rx_tdata),     // Data in
        .wr_en(pcie_rx_tvalid),  // Write enable
        .rd_en(rx_fifo_rd_en),   // Read enable
        .dout(rx_fifo_dout),     // Data out (returns packet for Encryption[/decryption])
        .empty(rx_fifo_empty),   // FIFO empty flag
        .full()                  // FIFO full flag (doesn't matter for rx FIFO, but does for TX)
    );

    // TX FIFO: Application -> PCIe TX
    aesfifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(FIFO_DEPTH)
    ) tx_fifo (
        .wr_clk(app_clk),        // Write clock (Application clock domain)
        .rd_clk(clk),            // Read clock (PCIe clock domain)
        .rst(rst),
        .din(tx_fifo_din),       // Data in
        .wr_en(tx_fifo_wr_en),   // Write enable
        .rd_en(pcie_tx_tready),  // Read enable
        .dout(pcie_tx_tdata),    // Data out
        .empty(),                // FIFO empty flag (Doesn't matter for TX FIFO, but does for RX FIFO)
        .full(tx_fifo_full)      // FIFO full flag
    );

    // Asynchronous RX logic
    always @(posedge app_clk or negedge rst) begin
        if (rst) begin
            packet_out <= 0;
            packet_out_valid <= 0;
        end else if (!rx_fifo_empty) begin
            packet_out <= rx_fifo_dout[127:0]; // Extract lower 128 bits for application
            packet_out_valid <= 1;
            rx_fifo_rd_en <= 1;
        end else begin
            packet_out_valid <= 0;
            rx_fifo_rd_en <= 0;
        end
    end

    // Asynchronous TX logic
    always @(posedge app_clk or negedge rst) begin
        if (rst) begin
            tx_fifo_wr_en <= 0;
        end else if (!tx_fifo_full && packet_in_valid) begin
            tx_fifo_din <= packet_in; // Pad input to 512 bits
            tx_fifo_wr_en <= 1;
        end else begin
            tx_fifo_wr_en <= 0;
        end
    end

    // PCIe TX signals
    assign pcie_tx_tkeep = 16'hFFFF; // Indicating all bytes are valid
    assign pcie_tx_tlast = 1'b1;     // Indicating single-packet TLP
    assign pcie_tx_tvalid = !tx_fifo_full; // Data valid when TX FIFO is not full

    // Indicating RX TLP is ready to be received
    assign pcie_rx_tready = !rx_fifo_empty; // Ready when RX FIFO has space

endmodule
*/