/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 2
    * reg_file module
    * Group 09 (E/20/148, E/20/157)
    * 2024-04-09
    * Version 1.0
*/

module reg_file(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET);
    // Port declaration
    input [7:0] IN; // Data input for writing
    input [2:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS; // Data addresses

    input CLK, RESET, WRITE; // Control signals

    output [7:0] OUT1, OUT2; // Data outputs

    // Register Allocation
    reg [7:0] REGISTER [7:0]; // 8 x 8 register block

    // variable for counting
    integer i;

    // Asynchronous Data Operations (READ)
    // Artificial delay of 2 time units
    //if (WRITE == 1'b0) begin
      //$display("READ DATA");
      assign #2 OUT1 = REGISTER[OUT1ADDRESS];
      assign #2 OUT2 = REGISTER[OUT2ADDRESS];
    //end

    // Synchronous Data Operations (WRITE, RESET)
    always @ (posedge CLK)
    begin
      // RESET (Highest Priority Operation)
      if (RESET == 1'b1) begin
        $display("RESET MEMORY");
        #1 for(i=0; i<8; i = i+1) begin
          REGISTER[i] = 8'b0000_0000;
        end
      end

      // WRITE
      else if (WRITE == 1'b1) begin
        $display("WRITE DATA");
        #1 REGISTER[INADDRESS] = IN; // Writing data to the given register
      end
    end

endmodule