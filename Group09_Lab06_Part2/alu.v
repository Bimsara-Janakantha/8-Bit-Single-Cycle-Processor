/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 5
    * ALU unit
    * Group 09 (E/20/148, E/20/157)
    * 2024-05-15
    * Version 2.0
*/

`include "forward.v"
`include "add.v"
`include "and.v"
`include "or.v"
`include "shift.v"
`include "mul.v"

// Note: ZERO signal is implemented

// ALU unit is used to provide suitable output according to the selector value. 
module alu(DATA1, DATA2, RESULT, ZERO, SELECT);
    // Input-output Declaration
    input [7:0] DATA1, DATA2;
    input [2:0] SELECT;
    output reg [7:0] RESULT;
    output reg ZERO;

    wire [7:0] addOut, andOut, fwdOut, orOut, compOut, subOut, shiftOut, mulOut;
    reg[1:0] TYPE;

    // Making functional Units
    forward fwdUnit(DATA2, fwdOut);
    add addUnit(DATA1, DATA2, addOut);
    myAND andUnit(DATA1, DATA2, andOut);
    myOR orUnit(DATA1, DATA2, orOut);
    shift shiftUnit(DATA1, DATA2, TYPE, shiftOut);
    mul mulUnit(DATA1,DATA2, mulOut);

    // Multiplexing according to selector values
    always @ (SELECT, fwdOut, addOut, andOut, orOut, shiftOut,mulOut)
    begin
      ZERO = 0; // Default set ZERO to 0 (To disable the signal)
      TYPE = 0; // Default set TYPE to 0 (To indicate the logical shift)

      case (SELECT)		//Case statement to switch between the outputs

			3'b000 :	RESULT = fwdOut;    //SELECT = 0 : FORWARD
			
			3'b001 :	begin     
                  RESULT = addOut;  //SELECT = 1 : ADD
                  if (RESULT == 0) begin
                    ZERO = 1'b1;    //Enable the ZERO signal
                  end
                end
			
			3'b010 :	RESULT = andOut;		//SELECT = 2 : AND
			
			3'b011 :	RESULT = orOut;		  //SELECT = 3 : OR

      3'b100 :	RESULT = shiftOut;  //SELECT = 4 : SHIFT

      3'b101 :	begin
                  TYPE = 1;         // Arithmetic Shift
                  RESULT = shiftOut;//SELECT = 4 : SHIFT
                end

      3'b110 :	begin
                  TYPE = 2;         // Rotate 
                  RESULT = shiftOut;//SELECT = 4 : SHIFT
                end

      3'b111 :	begin
                  RESULT = mulOut;  
                end

		endcase 

    //$display("DATA1: %b  \tDATA2: %b  \tSELECT: %b  \tRESULT: %b", DATA1, DATA2, SELECT, RESULT);

    end

    endmodule