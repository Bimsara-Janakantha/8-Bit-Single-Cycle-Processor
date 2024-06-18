/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 3
    * Multiplexer unit
    * Group 09 (E/20/148, E/20/157)
    * 2024-04-24
    * Version 1.0
*/

module mux(IN1, IN2, SELECT, OUT);
    // Input-output Declaration
    input[7:0] IN1, IN2;
    input SELECT;

    output reg[7:0] OUT;

    // Operation
    always @ (IN1, IN2, SELECT)
    begin
      if(SELECT == 0) begin
        OUT = IN1;
      end

      else if(SELECT == 1) begin
        OUT = IN2;
      end

     //$display("IN1: %b \t IN2: %b \t S: %b \t OUT: %b", IN1, IN2, SELECT, OUT);
    end

endmodule