`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CWIR3
// Engineer: copperwire
// 
// Create Date: 25.01.2026 16:47:30
// Design Name: 
// Module Name: SPI_MANAGER
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


module SPI_MANAGER
(
    input   wire            ACLK,
    input   wire            SPICLK,
    
    input   wire            reset,
    
    output  reg             rx_reg_en,
    output  reg     [07:00] rx_reg_addr,
    
    output  reg     [07:00] tx_reg_addr,
    
    output  reg             rd_en,
    input   wire    [07:00] rd_slave_addr,
    
    input   wire            SSQ_empty,
        
    output  reg     [07:00] wr_stat_up_addr,
    output  reg             wr_stat_up_en,
    
    output  reg             rd_stat_up,
    output  reg     [07:00] rd_stat_up_addr,
    output  reg             rd_stat_up_en,
    
    output  reg             SPI_start,
    output  reg     [00:07] SPI_select,
    
    input   wire            SPI_busy           
);
    
    localparam [3:0]    IDLE                =   0,
                        FETCH               =   1,
                        INITCOMM            =   2,
                        HALT                =   3,
                        FINISH              =   4;

    reg [3:0] SPISTATE = IDLE;

    reg [7:0] tempAddress;
    reg spiStartPrev;  



    always @(posedge ACLK   or  posedge reset)
    begin
        if(reset == 1)
        begin
            SPISTATE <= IDLE;
            
            rx_reg_en <= 0;
            rx_reg_addr <= 8'h00;
            tx_reg_addr <= 8'h00;
           
            rd_en <= 0;
            
            wr_stat_up_addr <= 8'h00;
            wr_stat_up_en <= 0;
            
            rd_stat_up <= 0;
            rd_stat_up_addr <= 8'h00;
            rd_stat_up_en <= 0;
            
            SPI_start <= 0;
            SPI_select <= 8'hFF;
            
            tempAddress <= 8'h00;

            spiStartPrev <= 1;
        end

        else
        begin
            case (SPISTATE)

                IDLE                :   begin
                                            rd_stat_up_en <= 0;
                                            rx_reg_en <= 0;
                                            
                                            if(SSQ_empty != 1   &&  SPI_busy != 1)
                                            begin
                                                rd_en <= 1;
                                                SPISTATE <= FETCH;
                                            end

                                            else rd_en <= 0;
                                        end

                FETCH               :   begin
                                            rd_en <= 0;
                                            
                                            tx_reg_addr <= rd_slave_addr;

                                            tempAddress <= rd_slave_addr;

                                            SPISTATE <= INITCOMM;
                                        end         

                INITCOMM            :   begin
                                            SPI_start <= 1;
                                            spiStartPrev <= SPICLK;

                                            rd_stat_up <= 0;
                                            rd_stat_up_addr <= {1'b1 , { {tempAddress[3:0]} + 1'b1}  };
                                            rd_stat_up_en <= 1;
                                            
                                            
                                            case (tempAddress)
                                                8'h00   :   begin
                                                                SPI_select <= 8'b0111_1111;
                                                            end
                                                            
                                                8'h02   :   begin
                                                                SPI_select <= 8'b1011_1111;
                                                            end    
                                                            
                                                8'h04   :   begin
                                                                SPI_select <= 8'b1101_1111;
                                                            end
                                                            
                                                8'h06   :   begin
                                                                SPI_select <= 8'b1110_1111;
                                                            end  
                                                            
                                                8'h08   :   begin
                                                                SPI_select <= 8'b1111_0111;
                                                            end
                                                            
                                                8'h0A   :   begin
                                                                SPI_select <= 8'b1111_1011;
                                                            end    
                                                            
                                                8'h0C   :   begin
                                                                SPI_select <= 8'b1111_1101;
                                                            end
                                                            
                                                8'h0E   :   begin
                                                                SPI_select <= 8'b1111_1110;
                                                            end                                              
                                            endcase
                                            

                                            SPISTATE <= HALT;
                                        end                                

                HALT              :   begin
                                            rd_stat_up_en <= 0;

                                            if(spiStartPrev == 0    &&  SPICLK == 1)
                                            begin
                                                SPI_start <= 0;
                                                
                                                wr_stat_up_addr <= {1'b1 , {tempAddress[3:0]}};
                                                wr_stat_up_en <= 1;
                                                
                                                SPISTATE <= FINISH;
                                            end

                                            else if(spiStartPrev == 1   &&  SPICLK == 0)
                                            begin
                                                spiStartPrev <= 0;
                                                SPISTATE <= HALT;
                                            end

                                            else if(spiStartPrev == 0   &&  SPICLK == 0)
                                            begin
                                                SPISTATE <= HALT;
                                            end

                                            else if(spiStartPrev == 1   &&  SPICLK == 1)
                                            begin
                                                SPISTATE <= HALT;
                                            end
                                        end         

                FINISH              :   begin
                                            wr_stat_up_en <= 0;
                                            if(SPI_busy != 1)
                                            begin
                                                rd_stat_up <= 1;
                                                rd_stat_up_addr <= {1'b1 , { {tempAddress[3:0]} + 1'b1}  };
                                                rd_stat_up_en <= 1;
                                                
                                                rx_reg_en <= 1;
                                                rx_reg_addr <= {{tempAddress[3:0]} + 1'b1};
                                                
                                                SPISTATE <= IDLE;
                                            end

                                            else SPISTATE <= FINISH;
                                        end                                                   

            endcase
        end
    end  
    


endmodule
