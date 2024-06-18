/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 3
    * CPU module
    * Group 09 (E/20/148, E/20/157)
    * 2024-04-24
    * Version 1.0
*/

// Importing external modules
`include "alu.v"
`include "reg_file.v"
`include "mux.v"
`include "complement.v"

module cpu(PC, INSTRUCTION, CLK, RESET);
    /* -------------------------------- Input-output Declaration -------------------------------- */

    input[31:0] INSTRUCTION;   // 32-bit bus
    input CLK, RESET;          // Single ports

    output reg[31:0] PC;       // 32-bit bus

    /* ------------------------------------------------------------------------------------------ */



    /* -------------------------------- Local Nets and Registers -------------------------------- */

    // Tempary stored location for next PC instruction
    reg[31:0] tempPC;

    // Connections for ALU
    wire[7:0] ALURESULT;
    reg[2:0] ALUOP;

    // Connections for 8x8 register file
    wire[7:0] REGOUT1, REGOUT2;
    reg[2:0] READREG1, READREG2, WRITEREG;
    reg WRITEENABLE;

    // Data Bus for OPCODES
    reg[7:0] OPCODE;

    // Data Bus for IMMEDIATE Value
    reg[7:0] IMMEDIATE;

    // 2's Complement Output
    wire[7:0] twos_Complemet;

    // Inputs and outputs for SubMux
    wire[7:0] subMuxOut;
    reg subMuxSelect;

    // Inputs and outputs for ImmediateMux
    wire[7:0] immMuxOut;
    reg immMuxSelect;

    /* ------------------------------------------------------------------------------------------ */



    /* -------------------------------- Making Functional Units --------------------------------- */

    alu aluUnit(REGOUT1, immMuxOut, ALURESULT, ALUOP);
    reg_file regUnit(ALURESULT, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, WRITEENABLE, CLK, RESET);
    mux subMux(REGOUT2, twos_Complemet, subMuxSelect, subMuxOut);
    mux immediateMux(IMMEDIATE, subMuxOut, immMuxSelect, immMuxOut);
    complement complementUnit(REGOUT2, twos_Complemet);

    /* ------------------------------------------------------------------------------------------ */




    /* -------------------------------- Program Counter Functions ------------------------------- */
    // Calculating Next Instruction
    always@(PC)
    begin
      #1 tempPC = PC + 4;
    end

    // Goto Next Instruction
    always@ (posedge CLK)
    begin
      if(RESET == 1) begin  // RESET PC to zero and Pass to the Instruction Register 
        $display("RESET PC");
        #1
        PC = 0;
        tempPC = 0;
      end
      else begin            // Pass Calculated PC Value to the Instruction Register
        #1 PC = tempPC;
      end

      $display("\nPC: %b", PC);
    end

    /* ------------------------------------------------------------------------------------------ */



    /* --------------------------------- Control Unit Functions --------------------------------- */

    /*
        NOTE: All instructions are of 32-bit fixed length, and encoded in the format shown below.

        +----------------------+----------------------+---------------------+--------------------+
        |        OP-CODE       |       RD / IMM       |          RT         |      RS / IMM      |
        |     (bits 31-24)     |     (bits 23-16)     |     (bits 15-8)     |     (bits 7-0)     |
        +----------------------+----------------------+---------------------+--------------------+

        * Bits(31-24): OP-CODE field identifies the instruction's operation. This should be used 
                       by the control logic to interpret the remaining fields and derive the 
                       control signals. 

        * Bits(23-16): A register (RD) to be written to in the register file, or an immediate value 
                       (jump or branch target offset). 

        * Bits(15-8):  A register (RT) to be read from in the register file. 

        * Bits(7-0):   A register (RS) to be read from in the register file, or an immediate value. 
    */    

    // Instruction Decording
    always @ (INSTRUCTION)
    begin
      $display("INSTRCTION: %b", INSTRUCTION);
          
      // Fetching out Sub Instructions
      OPCODE    <= INSTRUCTION[31:24]; // OPCODE
      WRITEREG  <= INSTRUCTION[23:16]; // Address of the write register
      READREG1  <= INSTRUCTION[15:8];  // Address of the read register 1
      READREG2  <= INSTRUCTION[7:0];   // Address of the read register 2
      IMMEDIATE <= INSTRUCTION[7:0];   // Immediate value
      $display("OPCODE: %b\t RD: %d\t RT: %d\tRS: %d \tIMM: 0x%h", OPCODE, WRITEREG, READREG1, READREG2, IMMEDIATE);

      #1  // Latency for Instruction Decoding

      case (OPCODE)

        // Load Instruction
        8'b0000_0000: begin
                        $display("Loadi");
                        immMuxSelect <= 0; // Select immediate value                        
                        ALUOP <= 0;        // ALU FORWARD 
                        WRITEENABLE <= 1;  // Writing pulse on
                      end

        // Move
        8'b0000_0001: begin
                        $display("Move");
                        subMuxSelect <= 0; // Select the original register 2 value
                        immMuxSelect <= 1; // Select register value
                        ALUOP = 0;        // ALU FORWARD 
                        WRITEENABLE <= 1;  // Writing pulse on
                      end

        // Add
        8'b0000_0010: begin
                        $display("Add");
                        subMuxSelect <= 0; // Select the original register 2 value
                        immMuxSelect <= 1; // Select register value
                        ALUOP <= 1;        // ALU ADD 
                        WRITEENABLE <= 1;  // Writing pulse on
                      end

        // Sub
        8'b0000_0011: begin
                        $display("Sub");
                        subMuxSelect <= 1; // Select the 2's complement value
                        immMuxSelect <= 1; // Select register value
                        ALUOP <= 1;        // ALU ADD 
                        WRITEENABLE <= 1;  // Writing pulse on
                      end


        // AND
        8'b0000_0100: begin
                        $display("AND");
                        subMuxSelect <= 0; // Select the original register 2 value
                        immMuxSelect <= 1; // Select register value
                        ALUOP <= 2;        // ALU AND 
                        WRITEENABLE <= 1;  // Writing pulse on
                      end

        // OR
        8'b0000_0101: begin
                        $display("OR");
                        subMuxSelect <= 1; // Select the original register 2 value
                        immMuxSelect <= 1; // Select register value
                        ALUOP <= 3;        // ALU OR 
                        WRITEENABLE <= 1;  // Writing pulse on
                      end
      endcase      

      #6 WRITEENABLE = 0; // Desable Writing

    end

    /* ------------------------------------------------------------------------------------------ */

endmodule