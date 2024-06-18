/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 2
    * Testbench
    * Group 09 (E/20/148, E/20/157)
    * 2024-04-09
    * Version 1.0
*/

// Import files
`include "reg_file.v"

module Testbench;
    // Defining registers
    reg [7:0] WRITEDATA;
    reg [2:0] READREG1, READREG2, WRITEREG;

    // Difining nets
    wire [7:0] REGOUT1, REGOUT2;
    reg CLOCK, RESET, WRITEENABLE;

    //Instantiating the register file within the testbench module
	reg_file myReg(WRITEDATA, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, WRITEENABLE, CLOCK, RESET);

    // Simulation
    initial begin
      $dumpfile("Testbench.vcd");
	  $dumpvars(0, myReg);
      
      // Initial Conditions
      WRITEENABLE = 0;
      RESET = 0;
      CLOCK = 0;  
      #2

      // Reset All
      RESET = 1;
      #2
      RESET = 0;

      // Write 7 to REG1
      WRITEREG = 1;    // Register number
      WRITEDATA = 7;   // Data
      WRITEENABLE = 1; // Write Enable pulse
      #2
      WRITEENABLE = 0; // Write Desable pulse
      #2               // Wait 2 time units


      // Read existing data
      READREG1 = 0;  // Data in REG0 dump into OUT1 
      READREG2 = 1;  // Data in REG1 dump into OUT2
      #5             // Wait 5 time units

      // Write 12 to REG6
      WRITEREG = 6;    // Register number
      WRITEDATA = 12;  // Data
      WRITEENABLE = 1; // Write Enable pulse
      #2
      WRITEENABLE = 0; // Write Desable pulse
      #3               // Wait 2 time units


      // Read existing data
      READREG1 = 6;  // Data in REG6 dump into OUT1 
      READREG2 = 1;  // Data in REG1 dump into OUT2
      #5             // Wait 5 time units

      // Write 7 to REG1
      WRITEREG = 1;    // Register number
      WRITEDATA = 7;   // Data
      /*WRITE is not enabled. So, output is not changing for next 5 time units.*/


      // Read existing data
      READREG1 = 6;  // Data in REG0 dump into OUT1 
      READREG2 = 1;  // Data in REG1 dump into OUT2
      #5             // Wait 5 time units


      $display("DONE!");
      $finish;
    end

    // CLOCK Pulse generator
    always #1 CLOCK = !CLOCK;

endmodule

