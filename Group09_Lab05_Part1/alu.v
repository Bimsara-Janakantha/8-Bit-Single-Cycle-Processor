/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 1
    * ALU unit
    * Group 09 (E/20/148, E/20/157)
    * 2024-04-09
    * Version 1.0
*/

`include "forward.v"
`include "add.v"
`include "and.v"
`include "or.v"

// ALU unit is used to provide suitable output according to the selector value. 
module alu(DATA1, DATA2, RESULT, SELECT);
    // Input-output Declaration
    input [7:0] DATA1, DATA2;
    input [2:0] SELECT;
    output reg [7:0] RESULT;

    wire [7:0] addOut, andOut, fwdOut, orOut;

    // Making functional Units
    forward fwdUnit(DATA2, fwdOut);
    add addUnit(DATA1, DATA2, addOut);
    myAND andUnit(DATA1, DATA2, andOut);
    myOR orUnit(DATA1, DATA2, orOut);

    // Multiplexing according to selector values
    always @ (DATA1, DATA2, SELECT)
    begin
      case (SELECT)		//Case statement to switch between the outputs

			3'b000 :	RESULT = fwdOut;	//SELECT = 0 : FORWARD
			
			3'b001 :	RESULT = addOut;		//SELECT = 1 : ADD
			
			3'b010 :	RESULT = andOut;		//SELECT = 2 : AND
			
			3'b011 :	RESULT = orOut;			//SELECT = 3 : OR
			
		endcase 
    end
endmodule