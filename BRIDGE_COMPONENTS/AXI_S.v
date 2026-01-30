`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CWIR3
// Engineer: copperwire
// 
// Create Date: 24.01.2026 16:36:52
// Design Name: 
// Module Name: AXI_S
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


module AXI_S
(
    /////////////////////AXI CLK/////////////////////
    input   wire            ACLK,
    /////////////////////AXI CLK/////////////////////
    
    /////////////////////AXI RESETN/////////////////////
    input   wire            ARESETN,
    /////////////////////AXI RESETN/////////////////////
    
    /////////////////////AXI ADDRESS WRITE/////////////////////
    input   wire    [07:00] AWADDR,
    input   wire            AWVALID,
    output  reg             AWREADY,
    /////////////////////AXI ADDRESS WRITE/////////////////////
    
    /////////////////////AXI DATA WRITE/////////////////////
    input   wire    [31:00] WDATA,
    input   wire    [03:00] WSTRB,
    input   wire            WVALID,
    output  reg             WREADY,
    /////////////////////AXI DATA WRITE/////////////////////
    
    /////////////////////AXI WRITE RESPONSE/////////////////////
    output  reg     [01:00] BRESP,
    output  reg             BVALID,
    input   wire            BREADY,
    /////////////////////AXI WRITE RESPONSE/////////////////////
    
    
    /////////////////////AXI READ ADDRESS/////////////////////
    input   wire    [07:00] ARADDR,
    input   wire            ARVALID,
    output  reg             ARREADY,
    /////////////////////AXI READ ADDRESS/////////////////////
    
    /////////////////////AXI DATA READ/////////////////////
    output  reg     [31:00] RDATA,
    output  reg     [01:00] RRESP,
    output  reg             RVALID,
    input   wire            RREADY,
    /////////////////////AXI DATA READ/////////////////////        
    
    /////////////////////AXI GET RESPONSE/////////////////////
    input   wire    [01:00] getBRESP,
    input   wire    [01:00] getRRESP,
    /////////////////////AXI GET RESPONSE/////////////////////
    
    /////////////////////AXI WRITE DATA REG/////////////////////
    output  reg     [07:00] wr_addr,
    output  reg     [31:00] wr_data,
    output  reg             wr_en,
    output  reg             wrUpdateDone,
    /////////////////////AXI WRITE DATA REG/////////////////////
    
    /////////////////////AXI READ DATA REG/////////////////////
    output  wire    [07:00] rd_addr,
    input   wire    [31:00] rd_data,
    input   wire            getTxRegStat,
    input   wire            getRxRegStat
    /////////////////////AXI READ DATA REG/////////////////////
);

    reg [07:00] tempAWADDR;
    reg [31:00] tempWDATA;  
    
    reg [07:00] tempARADDR;
    reg [31:00] tempRDATA;
    
    reg addressWriteHandshake;
    reg dataWriteHandshake;
    
    reg addressReadHandshake;
    
    
    always @(posedge ACLK)
    begin
    
        if(ARESETN == 0)
        begin
            AWREADY <= 1;
            
            WREADY <= 1;
            
            BRESP <= 2'b00;
            BVALID <= 0;
            
            ARREADY <= 1;
            
            RDATA <= 0;
            RRESP <= 0;
            RVALID <= 0;
            
            wr_en <= 0;
            wr_addr <= 0;
            wr_data <= 0;
            wrUpdateDone <= 0;
            
            tempAWADDR <= 0;
            tempWDATA <= 0;
            tempARADDR <= 0;
            tempRDATA <= 0;
            
            addressWriteHandshake <= 0;
            dataWriteHandshake <= 0;
            addressReadHandshake <= 0;
        end
        
        else
        begin
            if(AWVALID == 1 &&  AWREADY == 1)
            begin
                tempAWADDR <= AWADDR;
                
                addressWriteHandshake <= 1;
                
                AWREADY <= 0;
            end
            
            if(WVALID == 1  &&  WREADY == 1)
            begin
                tempWDATA <= WDATA & { {8{WSTRB[3]}} , {8{WSTRB[2]}} , {8{WSTRB[1]}} , {8{WSTRB[0]}} };
                
                dataWriteHandshake <= 1;
                
                WREADY <= 0;
            end
            
            if(addressWriteHandshake == 1   &&  dataWriteHandshake == 1)
            begin
                BVALID <= 1;
                BRESP <= getBRESP;
                
                addressWriteHandshake <= 0;
                dataWriteHandshake <= 0;
                
                if(getBRESP == 2'b00)
                begin
                    wr_addr <= tempAWADDR;
                    wr_data <= tempWDATA;
                    wr_en <= 1;
                    wrUpdateDone <= 1;
                end
            end
            
            else if(BVALID == 1  &&  BREADY == 1)
            begin
                BVALID <= 0;
                AWREADY <= 1;
                WREADY <= 1;
                
                wr_en <= 0;
                wrUpdateDone <= 0;
            end
            
            ////////////////////////////WRITE TRANSACTION/////////////////
            
            ////////////////////////////READ TRANSACTION/////////////////
            
            
            if(ARVALID == 1  &&  ARREADY == 1)
            begin
                ARREADY <= 0;
                
                tempARADDR <= ARADDR;
                
                addressReadHandshake <= 1;
            end
            
            if(addressReadHandshake == 1)
            begin
                case (tempARADDR)
                    8'h01   :   RDATA <= rd_data;
                    8'h03   :   RDATA <= rd_data;
                    8'h05   :   RDATA <= rd_data;
                    8'h07   :   RDATA <= rd_data;
                    8'h09   :   RDATA <= rd_data;
                    8'h0B   :   RDATA <= rd_data;
                    8'h0D   :   RDATA <= rd_data;
                    8'h0F   :   RDATA <= rd_data;
                    8'h10   :   RDATA <= getTxRegStat;
                    8'h11   :   RDATA <= getRxRegStat;
                    8'h12   :   RDATA <= getTxRegStat;
                    8'h13   :   RDATA <= getRxRegStat;
                    8'h14   :   RDATA <= getTxRegStat;
                    8'h15   :   RDATA <= getRxRegStat;
                    8'h16   :   RDATA <= getTxRegStat;
                    8'h17   :   RDATA <= getRxRegStat;
                    8'h18   :   RDATA <= getTxRegStat;
                    8'h19   :   RDATA <= getRxRegStat;
                    8'h1A   :   RDATA <= getTxRegStat;
                    8'h1B   :   RDATA <= getRxRegStat;
                    8'h1C   :   RDATA <= getTxRegStat;
                    8'h1D   :   RDATA <= getRxRegStat;
                    8'h1E   :   RDATA <= getTxRegStat;
                    8'h1F   :   RDATA <= getRxRegStat;
                endcase
                RRESP <= getRRESP;
                RVALID <= 1;
                
                addressReadHandshake <= 0;
            end
            
            else
            begin
                if(RVALID == 1  &&  RREADY == 1)
                begin
                    RVALID <= 0;
                    ARREADY <= 1;
                end
            end
            
        end
        
    end
        
    
    assign rd_addr = tempARADDR;
    

endmodule
