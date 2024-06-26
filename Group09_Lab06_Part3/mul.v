/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 5
    * Multiplication unit
    * Group 09 (E/20/148, E/20/157)
    * 27-05-2024
    * Version 1.0
*/

`include "adder_8bit.v"

// ALU mul unit is used to do multiplication operation in the ALU
module mul(DATA1, DATA2, RESULT);
    // Input-output Declaration
    input [7:0] DATA1, DATA2;
    output reg [7:0] RESULT;

    reg [7:0] partialProduct_0, partialProduct_1, partialProduct_2, partialProduct_3;
    reg [7:0] partialProduct_4, partialProduct_5, partialProduct_6, partialProduct_7;

    wire [7:0] carry;

    wire [7:0] sum_0, sum_1, sum_2, sum_3, sum_4, sum_5, sum_6;

    /*Functional Units 
     * Adder_8bit(Ain,Bin,Cin,Sum,Cout)
    */    
    adder_8bit addUnit_0( partialProduct_0 , partialProduct_1 , 1'b0 , sum_0 , carry[0]);
    adder_8bit addUnit_1( {carry[0], sum_0[7:1]} , partialProduct_2 , 1'b0 , sum_1 , carry[1]);
    adder_8bit addUnit_2( {carry[1], sum_1[7:1]} , partialProduct_3 , 1'b0 , sum_2 , carry[2]);
    adder_8bit addUnit_3( {carry[2], sum_2[7:1]} , partialProduct_4 , 1'b0 , sum_3 , carry[3]);
    adder_8bit addUnit_4( {carry[3], sum_3[7:1]} , partialProduct_5 , 1'b0 , sum_4 , carry[4]);
    adder_8bit addUnit_5( {carry[4], sum_4[7:1]} , partialProduct_6 , 1'b0 , sum_5 , carry[5]);
    adder_8bit addUnit_6( {carry[5], sum_5[7:1]} , partialProduct_7 , 1'b0 , sum_6 , carry[6]);

    always@(*) begin
        partialProduct_0 = {1'b0, DATA1[7] & DATA2[0], DATA1[6] & DATA2[0], DATA1[5] & DATA2[0], DATA1[4] & DATA2[0], DATA1[3] & DATA2[0], DATA1[2] & DATA2[0], DATA1[1] & DATA2[0]};
        partialProduct_1 = {DATA1[7] & DATA2[1], DATA1[6] & DATA2[1], DATA1[5] & DATA2[1], DATA1[4] & DATA2[1], DATA1[3] & DATA2[1], DATA1[2] & DATA2[1], DATA1[1] & DATA2[1], DATA1[0] & DATA2[1]};
        partialProduct_2 = {DATA1[7] & DATA2[2], DATA1[6] & DATA2[2], DATA1[5] & DATA2[1], DATA1[4] & DATA2[2], DATA1[3] & DATA2[2], DATA1[2] & DATA2[2], DATA1[1] & DATA2[2], DATA1[0] & DATA2[2]};
        partialProduct_3 = {DATA1[7] & DATA2[3], DATA1[6] & DATA2[3], DATA1[5] & DATA2[1], DATA1[4] & DATA2[3], DATA1[3] & DATA2[3], DATA1[2] & DATA2[3], DATA1[1] & DATA2[3], DATA1[0] & DATA2[3]};
        partialProduct_4 = {DATA1[7] & DATA2[4], DATA1[6] & DATA2[4], DATA1[5] & DATA2[1], DATA1[4] & DATA2[4], DATA1[3] & DATA2[4], DATA1[2] & DATA2[4], DATA1[1] & DATA2[4], DATA1[0] & DATA2[4]};
        partialProduct_5 = {DATA1[7] & DATA2[5], DATA1[6] & DATA2[5], DATA1[5] & DATA2[1], DATA1[4] & DATA2[5], DATA1[3] & DATA2[5], DATA1[2] & DATA2[5], DATA1[1] & DATA2[5], DATA1[0] & DATA2[5]};
        partialProduct_6 = {DATA1[7] & DATA2[6], DATA1[6] & DATA2[6], DATA1[5] & DATA2[1], DATA1[4] & DATA2[6], DATA1[3] & DATA2[6], DATA1[2] & DATA2[6], DATA1[1] & DATA2[6], DATA1[0] & DATA2[6]};
        partialProduct_7 = {DATA1[7] & DATA2[7], DATA1[6] & DATA2[7], DATA1[5] & DATA2[1], DATA1[4] & DATA2[7], DATA1[3] & DATA2[7], DATA1[2] & DATA2[7], DATA1[1] & DATA2[7], DATA1[0] & DATA2[7]};
    
        //Result
        RESULT[0] =  DATA1[0] & DATA2[0];
        RESULT[1] =  sum_0[0];
        RESULT[2] =  sum_1[0];
        RESULT[3] =  sum_2[0];
        RESULT[4] =  sum_3[0];
        RESULT[5] =  sum_4[0];
        RESULT[6] =  sum_5[0];
        RESULT[7] =  sum_6[0];
    end
    
endmodule



