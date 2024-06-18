/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 3
    * reg_file module
    * Group 09 (E/20/148, E/20/157)
    * 2024-04-24
    * Version 1.0
*/

module reg_file(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET);
    // Port declaration
    input [7:0] IN; // Data input for writing
    input [7:0] INADDRESS; 
    input [7:0] OUT1ADDRESS, OUT2ADDRESS; // Data addresses


    input CLK, RESET, WRITE; // Control signals

    output reg [7:0] OUT1, OUT2; // Data outputs

    // Register Allocation
    reg [7:0] REGISTER [7:0]; // 8 x 8 register block

    // variable for counting
    integer i;

    // Asynchronous Data Operations (READ)
    always @ (OUT1ADDRESS, OUT2ADDRESS)
    begin
      //if (WRITE == 1'b0) begin
        #2   // Artificial delay of 2 time units
        OUT1 = REGISTER[OUT1ADDRESS[2:0]];
        OUT2 = REGISTER[OUT2ADDRESS[2:0]];
        //$display("READ DATA:: \tREG[%d]: %b \tREG[%d]: %b", OUT1ADDRESS, OUT1, OUT2ADDRESS, OUT2);
        //$display("REG[0]: %b\nREG[1]: %b\nREG[2]: %b\nREG[3]: %b\nREG[4]: %b\nREG[5]: %b\nREG[6]: %b\nREG[7]: %b", REGISTER[0], REGISTER[1], REGISTER[2], REGISTER[3], REGISTER[4], REGISTER[5], REGISTER[6], REGISTER[7]);
      end

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
        //$display("REG[0]: %b\nREG[1]: %b\nREG[2]: %b\nREG[3]: %b\nREG[4]: %b\nREG[5]: %b\nREG[6]: %b\nREG[7]: %b", REGISTER[0], REGISTER[1], REGISTER[2], REGISTER[3], REGISTER[4], REGISTER[5], REGISTER[6], REGISTER[7]);
        $display("WRITE DATA\t REG: %d \tDATA: 0x%h", INADDRESS, IN);
        #1 REGISTER[INADDRESS[2:0]] = IN; // Writing data to the given register
      end
    end

    always @ (INADDRESS, OUT1ADDRESS, OUT2ADDRESS, RESET) begin
      $display("REG[0]: 0x%h\nREG[1]: 0x%h\nREG[2]: 0x%h\nREG[3]: 0x%h\nREG[4]: 0x%h\nREG[5]: 0x%h\nREG[6]: 0x%h\nREG[7]: 0x%h", REGISTER[0], REGISTER[1], REGISTER[2], REGISTER[3], REGISTER[4], REGISTER[5], REGISTER[6], REGISTER[7]);
    end

endmodule