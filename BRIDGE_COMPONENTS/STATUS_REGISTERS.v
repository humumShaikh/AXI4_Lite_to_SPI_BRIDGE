`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CWIR3
// Engineer: copperwire
// 
// Create Date: 24.01.2026 18:53:38
// Design Name: 
// Module Name: STATUS_REGISTERS
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


module STATUS_REGISTERS
(
    input   wire            reset,

    input   wire            wrStatUpEn,
    input   wire    [07:00] wrStatUpAddr,
    
    input   wire            rdStatUpEn,
    input   wire    [07:00] rdStatUpAddr,
    input   wire            rdStatUp,
    
    input   wire    [07:00] wrAddr,
    input   wire    [07:00] rdAddr,

    input   wire            wr_en,
    
    output  wire            full_empty,
    output  wire            valid_invalid
);

    
    reg write_status_reg  [16:31];
    reg read_status_reg [16:31];
    
    assign full_empty = write_status_reg[wrAddr];
    assign valid_invalid = read_status_reg[rdAddr];

    
    always @(posedge rdStatUpEn  or  posedge reset)
    begin
        if(reset == 1)
        begin
            read_status_reg[16] <= 0;
            read_status_reg[17] <= 0;
            read_status_reg[18] <= 0;
            read_status_reg[19] <= 0;
            read_status_reg[20] <= 0;
            read_status_reg[21] <= 0;
            read_status_reg[22] <= 0;
            read_status_reg[23] <= 0;
            read_status_reg[24] <= 0;
            read_status_reg[25] <= 0;
            read_status_reg[26] <= 0;
            read_status_reg[27] <= 0;
            read_status_reg[28] <= 0;
            read_status_reg[29] <= 0;
            read_status_reg[30] <= 0;
            read_status_reg[31] <= 0;
        end
        
        else
        begin
            read_status_reg[rdStatUpAddr] <= rdStatUp;
        end
    end



    always @(posedge wr_en    or  posedge wrStatUpEn  or  posedge reset)
    begin
        if(reset == 1)
        begin
            write_status_reg[16] <= 0;
            write_status_reg[17] <= 0;
            write_status_reg[18] <= 0;
            write_status_reg[19] <= 0;
            write_status_reg[20] <= 0;
            write_status_reg[21] <= 0;
            write_status_reg[22] <= 0;
            write_status_reg[23] <= 0;
            write_status_reg[24] <= 0;
            write_status_reg[25] <= 0;
            write_status_reg[26] <= 0;
            write_status_reg[27] <= 0;
            write_status_reg[28] <= 0;
            write_status_reg[29] <= 0;
            write_status_reg[30] <= 0;
            write_status_reg[31] <= 0;
        end

        else
        begin
            if(wr_en == 1)
            begin
                write_status_reg[wrAddr] <= 1;
            end

            if(wrStatUpEn == 1)
            begin
                write_status_reg[wrStatUpAddr] <= 0;
            end
        end
    end

endmodule
