/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 5
    * 4:1 Multiplexer Unit
    * Group 09 (E/20/148, E/20/157)
    * 2024-05-22
    * Version 1.0
*/

module mux4(IN1, IN2, IN3, IN4, SELECT, OUT);
    // Input-output Declaration
    input[7:0] IN1, IN2, IN3, IN4;
    input[1:0] SELECT;

    output reg[7:0] OUT;

    // Operation
    always @ (IN1, IN2, IN3, IN4, SELECT)
    begin
      if(SELECT == 0) begin
        OUT = IN1;
      end

      else if(SELECT == 1) begin
        OUT = IN2;
      end

      else if(SELECT == 2) begin
        OUT = IN3;
      end

      else if(SELECT == 3) begin
        OUT = IN4;
      end

     //$display("IN1: %b \t IN2: %b \t S: %b \t OUT: %b", IN1, IN2, SELECT, OUT);
    end

endmodule