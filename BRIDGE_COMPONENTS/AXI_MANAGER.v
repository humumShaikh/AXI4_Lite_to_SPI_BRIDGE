`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CWIR3
// Engineer: copperwire
// 
// Create Date: 24.01.2026 16:27:50
// Design Name: 
// Module Name: AXI_MANAGER
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


module AXI_MANAGER
(
    input   wire            ACLK,

    input   wire            reset,
    
    input   wire    [7:0]   AWADDR,
    input   wire            AWVALID,
    input   wire            AWREADY,
    
    input   wire    [7:0]   ARADDR,
    
    input   wire            wrRegStat,
    input   wire            rdRegStat,
    
    input   wire            SSQ_full,
    
    output  reg     [1:0]   setBRESP,
    output  reg     [1:0]   setRRESP,
    
    output  wire    [7:0]   wrStatRegAddr,
    output  wire    [7:0]   rdStatRegAddr,
    
    output  reg     [7:0]   wrSlaveAddr,
    output  reg             wr_en,
    input   wire            wrUpdateDone   
);

    
    assign wrStatRegAddr = {1'b1 , AWADDR[3:0]};
    assign rdStatRegAddr = {1'b1 , ARADDR[3:0]};
    
    
    always @(posedge ACLK  or  posedge reset)
    begin
        if(reset == 1)
        begin            
            //setBRESP <= 0;
            //setRRESP <= 0;
            
            wrSlaveAddr <= 0;
            wr_en <= 0;
        end
        
        
        else if(ACLK == 1)
        begin
            if(AWVALID == 1 &&  AWREADY == 1    &&  wrUpdateDone != 1)
            begin
                if(checkWriteStat(wrRegStat) == 2'b00)
                begin
                    wrSlaveAddr <= AWADDR;
                end
            end
            
            else if(wrUpdateDone == 1   &&  wr_en != 1)
            begin
                wr_en <= 1;
            end
            
            else if(wr_en == 1)
            begin
                wr_en <= 0;
            end
        end
        
    end

    
    
    always @(AWADDR , wrRegStat , SSQ_full)
    begin
        case (AWADDR)
            
            00      :   begin
                            setBRESP = checkWriteStat(wrRegStat);
                        end
                        
            02      :   begin
                            setBRESP = checkWriteStat(wrRegStat);
                        end              
                        
            04      :   begin
                            setBRESP = checkWriteStat(wrRegStat);
                        end
                        
            06      :   begin
                            setBRESP = checkWriteStat(wrRegStat);
                        end   
                        
            08      :   begin
                            setBRESP = checkWriteStat(wrRegStat);
                        end
                        
            10      :   begin
                            setBRESP = checkWriteStat(wrRegStat);
                        end              
                        
            12      :   begin
                            setBRESP = checkWriteStat(wrRegStat);
                        end
                        
            14      :   begin
                            setBRESP = checkWriteStat(wrRegStat);
                        end          
                        
            default :   begin
                            setBRESP = 2'b11;
                        end                                                
            
        endcase
    end
    
    
    
    always @(ARADDR , rdRegStat)
    begin
        case (ARADDR)
            
            8'h01   :   begin
                            setRRESP = checkReadStat(rdRegStat);
                        end
                        
            8'h03   :   begin
                            setRRESP = checkReadStat(rdRegStat);
                        end              
                        
            8'h05   :   begin
                            setRRESP = checkReadStat(rdRegStat);
                        end
                        
            8'h07   :   begin
                            setRRESP = checkReadStat(rdRegStat);
                        end   
                        
            8'h09   :   begin
                            setRRESP = checkReadStat(rdRegStat);
                        end
                        
            8'h0B   :   begin
                            setRRESP = checkReadStat(rdRegStat);
                        end              
                        
            8'h0D   :   begin
                            setRRESP = checkReadStat(rdRegStat);
                        end
                        
            8'h0F   :   begin
                            setRRESP = checkReadStat(rdRegStat);
                        end          
                        
            8'h10   :   begin
                            setRRESP = 2'b00;
                        end   
                        
            8'h11   :   begin
                            setRRESP = 2'b00;
                        end  
                        
            8'h12   :   begin
                            setRRESP = 2'b00;
                        end   
                        
            8'h13   :   begin
                            setRRESP = 2'b00;
                        end        
                        
            8'h14   :   begin
                            setRRESP = 2'b00;
                        end   
                        
            8'h15   :   begin
                            setRRESP = 2'b00;
                        end  
                        
            8'h16   :   begin
                            setRRESP = 2'b00;
                        end   
                        
            8'h17   :   begin
                            setRRESP = 2'b00;
                        end
                        
            8'h18   :   begin
                            setRRESP = 2'b00;
                        end   
                        
            8'h19   :   begin
                            setRRESP = 2'b00;
                        end  
                        
            8'h1A   :   begin
                            setRRESP = 2'b00;
                        end   
                        
            8'h1B   :   begin
                            setRRESP = 2'b00;
                        end        
                        
            8'h1C   :   begin
                            setRRESP = 2'b00;
                        end   
                        
            8'h1D   :   begin
                            setRRESP = 2'b00;
                        end  
                        
            8'h1E   :   begin
                            setRRESP = 2'b00;
                        end   
                        
            8'h1F   :   begin
                            setRRESP = 2'b00;
                        end                                                                 
                        
            default :   begin
                            setRRESP = 2'b11;
                        end                                                
            
        endcase
    end
    
    
    
    function [1:0] checkWriteStat(input x);
        begin
            if(x == 1   ||  SSQ_full == 1) checkWriteStat =  2'b10;
            else checkWriteStat =  2'b00;
        end
    endfunction
    
   
    function [1:0] checkReadStat(input y);
        begin
            if(y == 1) checkReadStat =  2'b00;
            else checkReadStat =  2'b01;
        end
    endfunction
    


endmodule
