`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CWIR3
// Engineer: copperwire
// 
// Create Date: 29.01.2026 01:03:11
// Design Name: 
// Module Name: AXI2SPI
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


module AXI2SPI
(
    input   wire            ACLK,
    input   wire            ARESETN,
    
    input   wire    [07:00] AWADDR,
    input   wire            AWVALID,
    output  wire            AWREADY,
    
    input   wire    [31:00] WDATA,
    input   wire    [03:00] WSTRB,
    input   wire            WVALID,
    output  wire            WREADY,
    
    output  wire    [01:00] BRESP,
    output  wire            BVALID,
    input   wire            BREADY,
    
    input   wire    [07:00] ARADDR,
    input   wire            ARVALID,
    output  wire            ARREADY,
    
    output  wire    [31:00] RDATA,
    output  wire    [01:00] RRESP,
    output  wire            RVALID,
    input   wire            RREADY,
    
    output  wire            MOSI,
    input   wire            MISO,
    output  wire            SCLK,
    output  wire    [00:07] SS                          
);
    
    wire spiclk;
    
    wire [80:00] axidr;
    wire [06:00] axam;
    wire [09:00] ssax;   
    wire [15:00] axsr;
    wire [09:00] sssm;
    wire [63:00] drspim; 
    wire [16:00] drspimgr;
    wire [18:00] smsr;
    wire [09:00] smsm;
    
    
    reg clkbuffer;
    
    always @(*) clkbuffer = ACLK;
    
    
    SPI_CLOCKER SPICLKER
    ( 
        .clkin(clkbuffer),
        .reset(~ARESETN),
        .clkout(spiclk)
    );
    
    AXI_S   AXIS
    (
        .ACLK(clkbuffer),
        .ARESETN(ARESETN),
        
        .AWADDR(AWADDR),
        .AWVALID(AWVALID),
        .AWREADY(AWREADY),
        
        .WDATA(WDATA),
        .WSTRB(WSTRB),
        .WVALID(WVALID),
        .WREADY(WREADY),
        
        .BRESP(BRESP),
        .BVALID(BVALID),
        .BREADY(BREADY),
        
        .ARADDR(ARADDR),
        .ARVALID(ARVALID),
        .ARREADY(ARREADY),
        
        .RDATA(RDATA),
        .RRESP(RRESP),
        .RVALID(RVALID),
        .RREADY(RREADY),
        
        .wr_addr(axidr[07:00]),
        .wr_data(axidr[39:08]),
        .wr_en(axidr[40]),
        
        .rd_addr(axidr[48:41]),
        .rd_data(axidr[80:49]),
        
        .getBRESP(axam[01:00]),
        .getRRESP(axam[03:02]),
        
        .getTxRegStat(axam[04]),
        .getRxRegStat(axam[05]),
        
        .wrUpdateDone(axam[06])
    );
    
    
    
    AXI_MANAGER AXIMGR
    (
        .SSQ_full(ssax[000]),
        
        .setBRESP(axam[01:00]),
        .setRRESP(axam[03:02]),
        
        .AWADDR(AWADDR),
        .AWVALID(AWVALID),
        .AWREADY(ARREADY),
        
        .ARADDR(ARADDR),
        
        .wrUpdateDone(axam[06]),
        
        .reset(~ARESETN),
        
        .ACLK(clkbuffer),
        
        .wrSlaveAddr(ssax[08:01]),
        .wr_en(ssax[09]),
        
        .wrStatRegAddr(axsr[07:00]),
        .rdStatRegAddr(axsr[15:08]),
        
        .wrRegStat(axam[04]),
        .rdRegStat(axam[05])
    );
    
    
    
    SSQ SSQ_FIFO
    (
        .reset(~ARESETN),
        
        .full(ssax[00]),
        
        .rd_en(sssm[00]),
        .rd_slave_addr(sssm[08:01]),
        
        .empty(sssm[09]),
        
        .wr_en(ssax[09]),
        .wr_slave_addr(ssax[08:01])
    );
    
    
    
    DATA_REGISTERS  DATAREG
    (
        .wr_addr(axidr[07:00]),
        .wr_data(axidr[39:08]),
        .wr_en(axidr[40]),
        
        .rd_addr(axidr[48:41]),
        .rd_data(axidr[80:49]),
        
        .reset(~ARESETN),
        
        .dout(drspim[31:00]),
        .din(drspim[63:32]),
        
        .rx_reg_en(drspimgr[00]),
        .rx_reg_addr(drspimgr[08:01]),
        
        .tx_reg_addr(drspimgr[16:09])
    );
    
    
    
    
    STATUS_REGISTERS    STATUSREG
    (
        .wr_en(ssax[09]),
        
        .wrAddr(axsr[07:00]),
        .rdAddr(axsr[15:08]),
        
        .full_empty(axam[04]),
        .valid_invalid(axam[05]),
        
        .reset(~ARESETN),
        
        .wrStatUpEn(smsr[00]),
        .wrStatUpAddr(smsr[08:01]),
        
        .rdStatUpEn(smsr[18]),
        .rdStatUpAddr(smsr[17:10]),
        .rdStatUp(smsr[09])
    );
    
    
    
    
    SPI_MANAGER SPIMGR
    (
        .rx_reg_en(drspimgr[00]),
        .rx_reg_addr(drspimgr[08:01]),
        
        .tx_reg_addr(drspimgr[16:09]),
        
        .SPICLK(spiclk),
        .reset(~ARESETN),
        
        .rd_en(sssm[00]),
        .rd_slave_addr(sssm[08:01]),
        
        .SSQ_empty(sssm[09]),
        
        .ACLK(clkbuffer),
        
        .SPI_select(smsm[07:00]),
        .SPI_start(smsm[08]),
        .SPI_busy(smsm[09]),
        
        .rd_stat_up(smsr[09]),
        .rd_stat_up_addr(smsr[17:10]),
        .rd_stat_up_en(smsr[18]),
        
        .wr_stat_up_addr(smsr[08:01]),
        .wr_stat_up_en(smsr[00])
    );
    
    
    
    
    SPI_M   SPIM
    (
        .clk(spiclk),
        
        .reset(~ARESETN),
        
        .din(drspim[31:00]),
        .dout(drspim[63:32]),
        
        .selecter(smsm[07:00]),
        .start(smsm[08]),
        .busy(smsm[09]),
        
        .miso(MISO),
        .mosi(MOSI),
        .sclk(SCLK),
        .ss(SS)
    );
    


endmodule
