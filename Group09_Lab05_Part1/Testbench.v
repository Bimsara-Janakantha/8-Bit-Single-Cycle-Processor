/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 1
    * Testbench
    * Group 09 (E/20/148, E/20/157)
    * 2024-04-09
    * Version 1.0
*/

// Including modules
`include "alu.v"

// Testbench
module Testbench;
    // Input-Output ports declaration
    reg [7:0] OPERAND1, OPERAND2;
    reg [2:0] ALUOP;
    wire [7:0] RESULT;

    // Instantiate the ALU
    alu myALU(OPERAND1, OPERAND2, RESULT, ALUOP);

    // Simulation
    initial begin
      $dumpfile("Testbench.vcd");
	    $dumpvars(0, myALU);

      OPERAND1 = 10;
      OPERAND2 = 15;

      // ADD operation
      #5 
      ALUOP = 1;
      #5

      // AND operation
      ALUOP = 2;
      #5

      // OR operation
      ALUOP = 3;
      #5

      // FORWARD operation
      ALUOP = 0;
      #5

      $display("Done!");
    end
endmodule