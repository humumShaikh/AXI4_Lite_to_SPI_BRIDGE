`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CWIR3
// Engineer: copperwire
// 
// Create Date: 24.01.2026 19:18:43
// Design Name: 
// Module Name: DATA_REGISTERS
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


module DATA_REGISTERS
(
    input   wire            reset,
  
    input   wire    [07:00] wr_addr,
    input   wire    [31:00] wr_data,
    input   wire            wr_en,
    
    input   wire    [07:00] rd_addr,
    output  wire    [31:00] rd_data,
    
    output  wire    [31:00] dout,
    input   wire    [31:00] din,
    
    input   wire            rx_reg_en,
    input   wire    [07:00] rx_reg_addr,
    
    input   wire   [07:00]  tx_reg_addr 
);


    reg [31:0] write_data_reg [0:15];
    reg [31:0] read_data_reg [0:15];
    
    
    
    assign rd_data = read_data_reg[rd_addr];
    
    assign dout = write_data_reg[tx_reg_addr];
    
    
    
    always @(posedge wr_en  or  posedge reset)
    begin
        if(reset == 1)
        begin
            write_data_reg[00] <= 32'h0000_0000;
            write_data_reg[01] <= 32'h0000_0000;
            write_data_reg[02] <= 32'h0000_0000;
            write_data_reg[03] <= 32'h0000_0000;
            write_data_reg[04] <= 32'h0000_0000;
            write_data_reg[05] <= 32'h0000_0000;
            write_data_reg[06] <= 32'h0000_0000;
            write_data_reg[07] <= 32'h0000_0000;
            write_data_reg[08] <= 32'h0000_0000;
            write_data_reg[09] <= 32'h0000_0000;
            write_data_reg[10] <= 32'h0000_0000;
            write_data_reg[11] <= 32'h0000_0000;
            write_data_reg[12] <= 32'h0000_0000;
            write_data_reg[13] <= 32'h0000_0000;
            write_data_reg[14] <= 32'h0000_0000;
            write_data_reg[15] <= 32'h0000_0000;
        end
        
        else if(wr_en == 1)
        begin
            write_data_reg[wr_addr] <= wr_data;
        end
    end
    
    always @(posedge rx_reg_en  or  posedge reset)
    begin
        if(reset == 1)
        begin
            read_data_reg[00] <= 32'h0000_0000;
            read_data_reg[01] <= 32'h0000_0000;
            read_data_reg[02] <= 32'h0000_0000;
            read_data_reg[03] <= 32'h0000_0000;
            read_data_reg[04] <= 32'h0000_0000;
            read_data_reg[05] <= 32'h0000_0000;
            read_data_reg[06] <= 32'h0000_0000;
            read_data_reg[07] <= 32'h0000_0000;
            read_data_reg[08] <= 32'h0000_0000;
            read_data_reg[09] <= 32'h0000_0000;
            read_data_reg[10] <= 32'h0000_0000;
            read_data_reg[11] <= 32'h0000_0000;
            read_data_reg[12] <= 32'h0000_0000;
            read_data_reg[13] <= 32'h0000_0000;
            read_data_reg[14] <= 32'h0000_0000;
            read_data_reg[15] <= 32'h0000_0000;
        end
        
        else if(rx_reg_en == 1)
        begin
            read_data_reg[rx_reg_addr] <= din;
        end
    end


endmodule
