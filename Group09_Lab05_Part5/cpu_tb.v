// Computer Architecture (CO224) - Lab 05
// Design: Testbench of Integrated CPU of Simple Processor
// Author: Isuru Nawinne
// Modified by: Janakantha S.M.B.G.
// Last Modified: 15/05/2024

`include "cpu.v"

module cpu_tb;

    reg CLK, RESET;
    wire [31:0] PC;
    reg [31:0] INSTRUCTION;
    
    /* 
    ------------------------
     SIMPLE INSTRUCTION MEM
    ------------------------
    */
    
    // TODO: Initialize an array of registers (8x1024) named 'instr_mem' to be used as instruction memory
    reg[7:0] instr_mem[1023:0];
    
    // TODO: Create combinational logic to support CPU instruction fetching, given the Program Counter(PC) value 
    //       (make sure you include the delay for instruction fetching here)
    always @ (PC)
    begin
        #2 
        INSTRUCTION[31:24] = instr_mem[PC+3];
        INSTRUCTION[23:16] = instr_mem[PC+2];
        INSTRUCTION[15:8]  = instr_mem[PC+1];
        INSTRUCTION[7:0]   = instr_mem[PC];
    end
    
    initial
    begin
        // Initialize instruction memory with the set of instructions you need execute on CPU
        
        // METHOD 1: manually loading instructions to instr_mem 
        /*{instr_mem[3], instr_mem[2], instr_mem[1], instr_mem[0]}     = 32'b00000000_00000100_00000000_00000101; // loadi 4 0x05
        {instr_mem[7], instr_mem[6], instr_mem[5], instr_mem[4]}     = 32'b00000000_00000010_00000000_00001001; // loadi 2 0x09
        {instr_mem[11], instr_mem[10], instr_mem[9], instr_mem[8]}   = 32'b00000010_00000110_00000100_00000010; // add 6 4 2
        {instr_mem[15], instr_mem[14], instr_mem[13], instr_mem[12]} = 32'b00000001_00000000_00000000_00000110; // mov 0 6
        {instr_mem[19], instr_mem[18], instr_mem[17], instr_mem[16]} = 32'b00000000_00000001_00000000_00000001; // loadi 1 0x01
        {instr_mem[23], instr_mem[22], instr_mem[21], instr_mem[20]} = 32'b00000010_00000010_00000010_00000001; // add 2 2 1
        {instr_mem[27], instr_mem[26], instr_mem[25], instr_mem[24]} = 32'b00000110_00000011_00000000_00000000; // j 0x03
            // ------------------------------------- Empty two rows are here ------------------------------------------------//
        {instr_mem[39], instr_mem[38], instr_mem[37], instr_mem[36]} = 32'b00000000_00000001_00000000_00000101; // loadi 1 0x05
        {instr_mem[43], instr_mem[42], instr_mem[41], instr_mem[40]} = 32'b00000000_00000010_00000000_00000001; // loadi 2 0x01
        {instr_mem[47], instr_mem[46], instr_mem[45], instr_mem[44]} = 32'b00000111_00000011_00000001_00000010; // beq 0x02 1 2
        */
        // METHOD 2: loading instr_mem content from instr_mem.mem file
        $readmemb("instr_mem.mem", instr_mem);
    end
    
    /* 
    -----
     CPU
    -----
    */
    cpu mycpu(PC, INSTRUCTION, CLK, RESET);

    integer i;

    initial begin
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, mycpu);
        
        for (i=0; i<8; i=i+1)
            $dumpvars(1, mycpu.regUnit.REGISTER[i]);
        
        RESET = 1'b0;
        CLK = 1'b0;
        
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
        RESET = 1;
        #5
        RESET = 0;
        // finish simulation after some time
        #100
        $finish;
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
        

endmodule