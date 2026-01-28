`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CWIR3
// Engineer: copperwire
// 
// Create Date: 24.01.2026 22:21:57
// Design Name: 
// Module Name: SSQ
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


module SSQ
(
    input   wire            reset,
    
    input   wire            rd_en,
    input   wire            wr_en,
    
    input   wire    [07:00] wr_slave_addr,
    output  reg     [07:00] rd_slave_addr,
    
    output  reg             empty,
    output  reg             full
);

    reg [7:0] buffer [1:16];
    reg [4:0] wrPtr;

    
    always @(posedge wr_en   or  posedge rd_en   or  posedge reset)
    begin
        
        if(reset == 1)
        begin
            buffer[01] <= 8'h00;
            buffer[02] <= 8'h00;
            buffer[03] <= 8'h00;
            buffer[04] <= 8'h00;
            buffer[05] <= 8'h00;
            buffer[06] <= 8'h00;
            buffer[07] <= 8'h00;
            buffer[08] <= 8'h00;
            buffer[09] <= 8'h00;
            buffer[10] <= 8'h00;
            buffer[11] <= 8'h00;
            buffer[12] <= 8'h00;
            buffer[13] <= 8'h00;
            buffer[14] <= 8'h00;
            buffer[15] <= 8'h00;
            buffer[16] <= 8'h00;
            
            wrPtr <= 5'h0_0000;
            rd_slave_addr <= 8'h00;
            
            empty <= 1;
            full <= 0;
        end 
       
        
        else if(wr_en == 1  &&  rd_en == 1)
        begin
                        
            case (wrPtr)
                
                00  :   begin
                            rd_slave_addr <= wr_slave_addr;
                            empty <= 1;
                            full <= 0;
                        end
                        
                01  :   begin
                            rd_slave_addr <= buffer[01];
                            buffer[01] <= wr_slave_addr;
                            empty <= 0;
                            full <= 0;
                        end           
                        
                02  :   begin
                            rd_slave_addr <= buffer[01];
                            buffer[01] <= buffer[02];
                            buffer[02] <= wr_slave_addr;
                            empty <= 0;
                            full <= 0;
                        end      
                        
                03  :   begin
                            rd_slave_addr <= buffer[01];
                            buffer[01] <= buffer[02];
                            buffer[02] <= buffer[03];
                            buffer[03] <= wr_slave_addr;
                            empty <= 0;
                            full <= 0;
                        end 
                        
                04  :   begin
                            rd_slave_addr <= buffer[01];
                            buffer[01] <= buffer[02];
                            buffer[02] <= buffer[03];
                            buffer[03] <= buffer[04];
                            buffer[04] <= wr_slave_addr;
                            empty <= 0;
                            full <= 0;
                        end     
                        
                05  :   begin
                            rd_slave_addr <= buffer[01];
                            buffer[01] <= buffer[02];
                            buffer[02] <= buffer[03];
                            buffer[03] <= buffer[04];
                            buffer[04] <= buffer[05];
                            buffer[05] <= wr_slave_addr;
                            empty <= 0;
                            full <= 0;
                        end     
                        
                06  :   begin
                            rd_slave_addr <= buffer[01];
                            buffer[01] <= buffer[02];
                            buffer[02] <= buffer[03];
                            buffer[03] <= buffer[04];
                            buffer[04] <= buffer[05];
                            buffer[05] <= buffer[06];
                            buffer[06] <= wr_slave_addr;
                            empty <= 0;
                            full <= 0;
                        end                                                                
                
                07  :   begin
                            rd_slave_addr <= buffer[01];
                            buffer[01] <= buffer[02];
                            buffer[02] <= buffer[03];
                            buffer[03] <= buffer[04];
                            buffer[04] <= buffer[05];
                            buffer[05] <= buffer[06];
                            buffer[06] <= buffer[07];
                            buffer[07] <= wr_slave_addr;
                            empty <= 0;
                            full <= 0;
                        end   
                        
                08  :   begin
                            rd_slave_addr <= buffer[01];
                            buffer[01] <= buffer[02];
                            buffer[02] <= buffer[03];
                            buffer[03] <= buffer[04];
                            buffer[04] <= buffer[05];
                            buffer[05] <= buffer[06];
                            buffer[06] <= buffer[07];
                            buffer[07] <= buffer[08];
                            buffer[08] <= wr_slave_addr;
                            empty <= 0;
                            full <= 0;
                        end  
                        
                09  :   begin
                            rd_slave_addr <= buffer[01];
                            buffer[01] <= buffer[02];
                            buffer[02] <= buffer[03];
                            buffer[03] <= buffer[04];
                            buffer[04] <= buffer[05];
                            buffer[05] <= buffer[06];
                            buffer[06] <= buffer[07];
                            buffer[07] <= buffer[08];
                            buffer[08] <= buffer[09];
                            buffer[09] <= wr_slave_addr;
                            empty <= 0;
                            full <= 0;
                        end        
                        
                10  :   begin
                            rd_slave_addr <= buffer[01];
                            buffer[01] <= buffer[02];
                            buffer[02] <= buffer[03];
                            buffer[03] <= buffer[04];
                            buffer[04] <= buffer[05];
                            buffer[05] <= buffer[06];
                            buffer[06] <= buffer[07];
                            buffer[07] <= buffer[08];
                            buffer[08] <= buffer[09];
                            buffer[09] <= buffer[10];
                            buffer[10] <= wr_slave_addr;
                            empty <= 0;
                            full <= 0;
                        end   
                        
                11  :   begin
                            rd_slave_addr <= buffer[01];
                            buffer[01] <= buffer[02];
                            buffer[02] <= buffer[03];
                            buffer[03] <= buffer[04];
                            buffer[04] <= buffer[05];
                            buffer[05] <= buffer[06];
                            buffer[06] <= buffer[07];
                            buffer[07] <= buffer[08];
                            buffer[08] <= buffer[09];
                            buffer[09] <= buffer[10];
                            buffer[10] <= buffer[11];
                            buffer[11] <= wr_slave_addr;
                            empty <= 0;
                            full <= 0;
                        end
                        
                12  :   begin
                            rd_slave_addr <= buffer[01];
                            buffer[01] <= buffer[02];
                            buffer[02] <= buffer[03];
                            buffer[03] <= buffer[04];
                            buffer[04] <= buffer[05];
                            buffer[05] <= buffer[06];
                            buffer[06] <= buffer[07];
                            buffer[07] <= buffer[08];
                            buffer[08] <= buffer[09];
                            buffer[09] <= buffer[10];
                            buffer[10] <= buffer[11];
                            buffer[11] <= buffer[12];
                            buffer[12] <= wr_slave_addr;
                            empty <= 0;
                            full <= 0;
                        end     
                        
                13  :   begin
                            rd_slave_addr <= buffer[01];
                            buffer[01] <= buffer[02];
                            buffer[02] <= buffer[03];
                            buffer[03] <= buffer[04];
                            buffer[04] <= buffer[05];
                            buffer[05] <= buffer[06];
                            buffer[06] <= buffer[07];
                            buffer[07] <= buffer[08];
                            buffer[08] <= buffer[09];
                            buffer[09] <= buffer[10];
                            buffer[10] <= buffer[11];
                            buffer[11] <= buffer[12];
                            buffer[12] <= buffer[13];
                            buffer[13] <= wr_slave_addr;
                            empty <= 0;
                            full <= 0;
                        end  
                        
                14  :   begin
                            rd_slave_addr <= buffer[01];
                            buffer[01] <= buffer[02];
                            buffer[02] <= buffer[03];
                            buffer[03] <= buffer[04];
                            buffer[04] <= buffer[05];
                            buffer[05] <= buffer[06];
                            buffer[06] <= buffer[07];
                            buffer[07] <= buffer[08];
                            buffer[08] <= buffer[09];
                            buffer[09] <= buffer[10];
                            buffer[10] <= buffer[11];
                            buffer[11] <= buffer[12];
                            buffer[12] <= buffer[13];
                            buffer[13] <= buffer[14];
                            buffer[14] <= wr_slave_addr;
                            empty <= 0;
                            full <= 0;
                        end       
                        
                15  :   begin
                            if(full != 1)
                            begin
                                rd_slave_addr <= buffer[01];
                                buffer[01] <= buffer[02];
                                buffer[02] <= buffer[03];
                                buffer[03] <= buffer[04];
                                buffer[04] <= buffer[05];
                                buffer[05] <= buffer[06];
                                buffer[06] <= buffer[07];
                                buffer[07] <= buffer[08];
                                buffer[08] <= buffer[09];
                                buffer[09] <= buffer[10];
                                buffer[10] <= buffer[11];
                                buffer[11] <= buffer[12];
                                buffer[12] <= buffer[13];
                                buffer[13] <= buffer[14];
                                buffer[14] <= buffer[15];
                                buffer[15] <= buffer[16];
                                buffer[16] <= wr_slave_addr;
                                empty <= 0;
                                full <= 0;
                            end
                        end                                                                                     
                
            endcase
        end
        
        
        
        else if(wr_en == 1)
        begin
            if(wrPtr != 15)
            begin
                buffer[wrPtr + 1] <= wr_slave_addr;
                wrPtr <= wrPtr + 1;
                empty <= 0;
                full <= 0;
            end
            
            else if(wrPtr == 15 &&  full != 1)
            begin
                buffer[wrPtr + 1] <= wr_slave_addr;
                wrPtr <= wrPtr + 1;
                empty <= 0;
                full <= 1;
            end
        end
        
        
        
        else if(rd_en == 1)
        begin
            if(wrPtr != 1)
            begin
                rd_slave_addr <= buffer[01];
                buffer[01] <= buffer[02];
                buffer[02] <= buffer[03];
                buffer[03] <= buffer[04];
                buffer[04] <= buffer[05];
                buffer[05] <= buffer[06];
                buffer[06] <= buffer[07];
                buffer[07] <= buffer[08];
                buffer[08] <= buffer[09];
                buffer[09] <= buffer[10];
                buffer[10] <= buffer[11];
                buffer[11] <= buffer[12];
                buffer[12] <= buffer[13];
                buffer[13] <= buffer[14];
                buffer[14] <= buffer[15];
                buffer[15] <= buffer[16];
                buffer[16] <= 8'h00;
                wrPtr <= wrPtr - 1;
                empty <= 0;
            end
            
            else if(wrPtr == 1  &&  empty != 1)
            begin
                rd_slave_addr <= buffer[01];
                buffer[01] <= 8'h00;
                wrPtr <= wrPtr - 1;
                empty <= 1;
                full <= 0;
            end
        end
        
    end

        
endmodule