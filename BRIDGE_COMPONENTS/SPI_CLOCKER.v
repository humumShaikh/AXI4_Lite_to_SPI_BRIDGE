`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CWIR3
// Engineer: copperwire
// 
// Create Date: 26.01.2026 19:51:46
// Design Name: 
// Module Name: SPI_CLOCKER
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

module SPI_CLOCKER
(
    input   wire    clkin,
    input   wire    reset,
    output  reg     clkout
);

    reg [2:0] counter;
    
    always @(posedge clkin  or  posedge reset)
    begin
        if(reset == 1)
        begin
            counter <= 0;
            clkout <= 0;
        end
        
        else if(clkin == 1)
        begin
            if(counter == 4)
            begin
                counter <= 0;
                clkout <= ~clkout;
            end
           
            else counter <= counter + 1;
        end
    end

endmodule
