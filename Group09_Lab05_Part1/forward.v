/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 1
    * forward unit
    * Group 09 (E/20/148, E/20/157)
    * 2024-04-09
    * Version 1.0
*/


// FORWARD unit should simply send an operand value from DATA2 to its output. 
module forward(DATA, OUT);
    // Input-output Declaration
    input [7:0] DATA;
    output [7:0] OUT;

    // Result
    assign #1 OUT = DATA;
endmodule