`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2026 14:21:43
// Design Name: 
// Module Name: tb_AXI2SPI
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


module tb_AXI2SPI;


    reg               ACLK;
    reg               ARESETN;
    
    reg       [07:00] AWADDR;
    reg               AWVALID;
    wire              AWREADY;
    
    reg       [31:00] WDATA;
    reg       [03:00] WSTRB;
    reg               WVALID;
    wire              WREADY;
    
    wire      [01:00] BRESP;
    wire              BVALID;
    reg               BREADY;
    
    reg       [07:00] ARADDR;
    reg               ARVALID;
    wire              ARREADY;
    
    wire      [31:00] RDATA;
    wire      [01:00] RRESP;
    wire              RVALID;
    reg               RREADY;
    
    wire              MOSI;
    reg               MISO;
    wire              SCLK;
    wire      [00:07] SS;   
    
    

    AXI2SPI DUT
    (
        .ACLK(ACLK),
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
                
        .MOSI(MOSI),   
        .MISO(MISO),   
        .SCLK(SCLK),   
        .SS(SS)      
    );
    
    
    reg [31:0] tempReg;
    
    
    always #5 ACLK <= ~ACLK;
    
    initial
    begin
        
        ACLK <= 0;
        ARESETN <= 0;
        
        AWADDR <= 0;
        AWVALID <= 0;
        
        WDATA <= 0;
        WSTRB <= 0;
        WVALID <= 0;
        
        BREADY <= 1;
        
        ARADDR <= 0;
        ARVALID <= 0;
        
        RREADY <= 1;
        
        MISO <= 0;
        
        @(posedge ACLK) ARESETN <= 1;
    end
    
    always @(posedge SCLK)
    begin
        MISO <= $random();
    end
    
    initial
    begin
        
        repeat(3) @(posedge ACLK);
        
        sendWriteAddress(8'h02);
        sendWriteData(32'hAAAA_AAAA , 4'hF);
        getWriteResponse();
        sendReadAddress(8'h03);
        waitSPIDone();
        
        sendReadAddress(8'h03);
        #100;
        $finish;
    end
    
    
    
    task sendWriteAddress
    (
        input [7:0] addr
    );
        begin
            @(posedge ACLK)
            begin
                AWADDR <= addr;
                AWVALID <= 1;
            end
            repeat(! (AWVALID == 1  &&  AWREADY == 1) )
            begin
                @(posedge ACLK);
            end
            AWVALID <= 0;
        end
    endtask
   
    
    task sendWriteData
    (
        input [31:0] data,
        input [3:0] strobe
    );
        begin
            @(posedge ACLK)
            begin
                WDATA <= data;
                WSTRB <= strobe;
                WVALID <= 1;
            end
            repeat( ! (WVALID == 1  &&  WREADY == 1))
            begin
                @(posedge ACLK);
            end 
            WVALID <= 0;
        end
    endtask
    
    
    task getWriteResponse;
        begin
            repeat( ! (BVALID == 1  &&  BREADY == 1))
            begin
                @(posedge ACLK);
            end
            @(posedge ACLK);
            BREADY <= 0;
            
            @(posedge ACLK) BREADY <= 1;
        end
    endtask


    task sendReadAddress
    (
        input [7:0] addr
    );
        begin
            @(posedge ACLK)
            begin
                ARADDR <= addr;
                ARVALID <= 1;
                RREADY <= 1;
            end
            repeat( ! (ARVALID == 1 &&  ARREADY == 1))
            begin
                @(posedge ACLK);
            end
            ARVALID <= 0;
            getReadData();
        end
    endtask
    
    
    task getReadData;
        begin
            repeat( ! (RREADY == 1  &&  RVALID == 1))
            begin
                @(posedge ACLK);
            end
            @(posedge ACLK);
            RREADY <= 0;
            @(posedge ACLK);
            RREADY <= 1;
        end
    endtask
    
    
    task waitSPIDone();
        begin
            wait(SS != 8'hFF);
            wait(SS == 8'hFF);
        end
    endtask
    
endmodule
