/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 5
    * 8 bit adder
    * Group 09 (E/20/148, E/20/157)
    * 27-05-2024
    * Version 1.0
*/

`include "fullAdder.v"

//8 Bit Full Adder unit
module adder_8bit(Ain,Bin,Cin,Sum,Cout);
    input [7:0] Ain, Bin;
    input Cin;      //Carry in  
    output [7:0] Sum;
    output Cout;    //Carry out

    wire [7:0] carry;

    //Functional Units
    fullAdder FA_0(Ain[0],Bin[0],   Cin    , Sum[0], carry[0]);
    fullAdder FA_1(Ain[1],Bin[1], carry[0] , Sum[1], carry[1]);
    fullAdder FA_2(Ain[2],Bin[2], carry[1] , Sum[2], carry[2]);
    fullAdder FA_3(Ain[3],Bin[3], carry[2] , Sum[3], carry[3]);
    fullAdder FA_4(Ain[4],Bin[4], carry[3] , Sum[4], carry[4]);
    fullAdder FA_5(Ain[5],Bin[5], carry[4] , Sum[5], carry[5]);
    fullAdder FA_6(Ain[6],Bin[6], carry[5] , Sum[6], carry[6]);
    fullAdder FA_7(Ain[7],Bin[7], carry[6] , Sum[7], carry[7]);

    assign Cout = carry[7];

endmodule

