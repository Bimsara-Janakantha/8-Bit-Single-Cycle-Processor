/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 5
    * 2's Complement Unit
    * Group 09 (E/20/148, E/20/157)
    * 2024-05-15
    * Version 1.0
*/


// This module is used to produce 2's complement value of a given 8 bit data set
module complement(DATA2, RESULT);
    // Input-output Declaration
    input [7:0] DATA2;
    output [7:0] RESULT;

    // Result
    assign #1 RESULT = ~DATA2 + 8'b0000_0001;

    /*initial begin
        $monitor("DATA=%b,  RESULT=%b\n", DATA2, RESULT);
    end*/

endmodule