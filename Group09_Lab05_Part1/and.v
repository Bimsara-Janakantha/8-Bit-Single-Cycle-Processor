/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 1
    * and unit
    * Group 09 (E/20/148, E/20/157)
    * 2024-04-09
    * Version 1.0
*/


// ALU and unit is used to do and operation in the ALU
module myAND(DATA1, DATA2, RESULT);
    // Input-output Declaration
    input [7:0] DATA1, DATA2;
    output [7:0] RESULT;

    // Result
    assign #1 RESULT = DATA1 & DATA2;
endmodule