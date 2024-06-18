/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 3
    * or unit
    * Group 09 (E/20/148, E/20/157)
    * 2024-04-24
    * Version 1.0
*/


// ALU OR unit is used to do OR operation in the ALU
module myOR(DATA1, DATA2, RESULT);
    // Input-output Declaration
    input [7:0] DATA1, DATA2;
    output [7:0] RESULT;

    // Result
    assign #1 RESULT = DATA1 | DATA2;
endmodule