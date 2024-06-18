/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 3
    * CPU module
    * Group 09 (E/20/148, E/20/157)
    * 2024-05-06
    * Version 5.1
*/

// Note: The JUMP Instruction is implemented
// Note: The BEQ Instruction is implemented

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
    reg[7:0] nextPC;  
    /* 
      Note: Our Instruction memory is 8x1024 size. Then it has 1024 spaces for 8 bit words. The size of one instruction is 32 bit. 
      That means one instruction is a size of 4 words in instruction memory. So, the maximum instructions that can be store in the 
      instruction memory is 256. In binary we need maximum 8 bits to address the all of the memory locations in the instruction memory.
      Then, minimum 8 bits are sufficient in PC to access the Instruction memory.
    */

    // Connections for ALU
    wire[7:0] ALURESULT;
    reg[2:0] ALUOP;
    wire ZERO;

    // Connections for PC Adder Unit
    wire[7:0] pcAdderOut;

    // Connections for Branch Mux Unit
    reg BRANCH;
    //wire branchEnable;
    wire[7:0] branchMuxOut;

    // Connections for Jump Mux Unit
    reg JUMP;
    wire[7:0] jumpMuxOut;

    // Connections for 8x8 register file
    wire[7:0] REGOUT1, REGOUT2;
    reg[7:0] READREG1, READREG2, WRITEREG;
    reg WRITEENABLE;

    // Data Bus for OPCODES
    reg[7:0] OPCODE;

    // Data Bus for IMMEDIATE Value
    reg[7:0] IMMEDIATE1, IMMEDIATE2;

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

    alu aluUnit(REGOUT1, immMuxOut, ALURESULT, ZERO, ALUOP);
    add pcAdder(nextPC, IMMEDIATE1<<2, pcAdderOut);
    reg_file regUnit(ALURESULT, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, WRITEENABLE, CLK, RESET);
    mux subMux(REGOUT2, twos_Complemet, subMuxSelect, subMuxOut);
    mux immediateMux(IMMEDIATE2, subMuxOut, immMuxSelect, immMuxOut);
    mux jumpMux(branchMuxOut, pcAdderOut, JUMP, jumpMuxOut);
    mux branchMux(nextPC, pcAdderOut, (BRANCH & ZERO), branchMuxOut);
    complement complementUnit(REGOUT2, twos_Complemet);

    /* ------------------------------------------------------------------------------------------ */




    /* -------------------------------- Program Counter Functions ------------------------------- */
    // Calculating Next Instruction
    always@(PC)
    begin
      #1 nextPC = PC + 4;
    end

    // Goto Next Instruction
    always@ (posedge CLK)
    begin
      if(RESET == 1) begin  // RESET PC to zero and Pass to the Instruction Register 
        $display("RESET PC");
        #1
        PC <= 0;
        nextPC <= 0;
        //jump <= 0;
      end
      else begin            // Pass Calculated PC Value to the Instruction Register
        #1 PC = jumpMuxOut;
      end

      $display("\nnextPC: %b \tPCAdder: %b", nextPC, pcAdderOut);
      $display("Branch: %b \tZERO: %b \tBranchOut: %b", BRANCH, ZERO, branchMuxOut);
      $display("Jump: %b \nPC: %b", JUMP, PC);
    end

    /* ------------------------------------------------------------------------------------------ */



    /* --------------------------------- Control Unit Functions --------------------------------- */

    /*
        NOTE: All instructions are of 32-bit fixed length, and encoded in the format shown below.

        +----------------------+----------------------+---------------------+--------------------+
        |        OP-CODE       |      RD / IMM_1      |          RT         |     RS / IMM_2     |
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
      // Reset Control Signals
      JUMP = 0;
      BRANCH = 0;
      //subMuxSelect <= 0;
      //immMuxSelect <= 0;

      $display("INSTRCTION: %b", INSTRUCTION);
          
      // Fetching out Sub Instructions
      OPCODE     <= INSTRUCTION[31:24]; // OPCODE
      WRITEREG   <= INSTRUCTION[23:16]; // Address of the write register
      READREG1   <= INSTRUCTION[15:8];  // Address of the read register 1
      READREG2   <= INSTRUCTION[7:0];   // Address of the read register 2
      IMMEDIATE1 <= INSTRUCTION[23:16]; // Immediate value 1
      IMMEDIATE2 <= INSTRUCTION[7:0];   // Immediate value 2
      $display("OPCODE: %b\t RD: %d\t RT: %d\tRS: %d \tIMM1: 0x%h \tIMM2: 0x%h", OPCODE, WRITEREG, READREG1, READREG2, IMMEDIATE1, IMMEDIATE2);

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
                        ALUOP <= 0;        // ALU FORWARD 
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

        // JUMP
        8'b0000_0110: begin
                        $display("JUMP"); 
                        JUMP = 1;          // Select the jump address as the PC
                      end

        // BEQ
        8'b0000_0111: begin
                        $display("BEQ"); 
                        BRANCH <= 1;       // Select the branch address as the PC
                        subMuxSelect <= 1; // Select the 2's complement value
                        immMuxSelect <= 1; // Select register value
                        ALUOP <= 1;        // ALU ADD 
                      end
      endcase      

      #6 WRITEENABLE = 0; // Desable Writing

    end

    /* ------------------------------------------------------------------------------------------ */

endmodule