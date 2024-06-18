/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 5
    * Shift Unit
    * Group 09 (E/20/148, E/20/157)
    * 2024-05-22
    * Version 1.0
*/

// ALU shift unit is used to do shift operation in the ALU
// NOTE: LEFT LOGICAL SHIFT is implemented
// NOTE: RIGHT LOGICAL SHIFT is implemented
// NOTE: RIGHT ARITHMETICAL SHIFT is implemented
// NOTE: ROTATE RIGHT is implemented


`include "mux4.v"
`include "mux.v"
`include "complement.v"
`timescale 1ns/100ps

module shift(DATA1, DATA2, TYPE, RESULT);
    // Input-output Declaration
    input [7:0] DATA1, DATA2;
    output reg [7:0] RESULT;
    input[1:0] TYPE;

    // Local nets
    wire[7:0] ComplementOut, SHIFT, MSB, Mux1Out, Mux2Out, Mux3Out, Mux4Out, Temp;

    // Definig Functional Units
    complement complementUnit(DATA2, ComplementOut);
    mux ShiftAmount(DATA2, ComplementOut, DATA2[7], SHIFT);
    mux4 MSBMux(8'b0000_0000, 8'b1111_1111, DATA1, DATA1, TYPE, MSB);
    mux4 Mux_1(DATA1,   {DATA1[6:0], 1'b0},   DATA1,   {MSB[0],DATA1[7:1]},     {DATA2[7],SHIFT[0]}, Mux1Out);
    mux4 Mux_2(Mux1Out, {Mux1Out[5:0], 2'b00}, Mux1Out, {MSB[2:1],Mux1Out[7:2]}, {DATA2[7],SHIFT[1]}, Mux2Out);
    mux4 Mux_3(Mux2Out, {Mux2Out[3:0], 4'b0000}, Mux2Out, {MSB[6:3],Mux2Out[7:4]}, {DATA2[7],SHIFT[2]}, Mux3Out);
    mux4 Mux_4(Mux3Out, 8'b0000_0000, Mux3Out, 8'b1111_1111, {DATA2[7],(SHIFT[6]|SHIFT[5]|SHIFT[4]|SHIFT[3])}, Mux4Out);
    mux  Final(Mux4Out, Mux3Out, TYPE[1], Temp);

    always@(*) begin
      #2 RESULT = Temp;
    end
endmodule