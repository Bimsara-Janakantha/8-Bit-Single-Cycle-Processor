/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 5
    * add unit
    * Group 09 (E/20/148, E/20/157)
    * 2024-05-15
    * Version 2.0
*/

`timescale 1ns/100ps

// ALU add unit is used to do add operation in the ALU
module add(DATA1, DATA2, RESULT);
    // Input-output Declaration
    input [7:0] DATA1, DATA2;
    output [7:0] RESULT;
    //output reg [7:0] RESULT;

    // Result
    assign #2 RESULT = DATA1 + DATA2;
    
    /*
    always @ (DATA1, DATA2) begin
        #2 
        RESULT = DATA1 + DATA2;
        //$display("ADD Unit:: \tDATA1: %d \tDATA2: %d \tRESULT: %d", DATA1, DATA2, RESULT);
    end
    */

endmodule