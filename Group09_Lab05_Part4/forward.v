/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 3
    * forward unit
    * Group 09 (E/20/148, E/20/157)
    * 2024-04-24
    * Version 1.0
*/


// FORWARD unit should simply send an operand value from DATA2 to its output. 
module forward(DATA2, RESULT);
    // Input-output Declaration
    input [7:0] DATA2;
    output [7:0] RESULT;

    // Result
    assign #1 RESULT = DATA2;
endmodule