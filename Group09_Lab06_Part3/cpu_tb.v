// Computer Architecture (CO224) - Lab 05
// Design: Testbench of Integrated CPU of Simple Processor
// Author: Isuru Nawinne
// Modified by: Janakantha S.M.B.G.
// Last Modified: 13-06-2024

`include "cpu.v"
//`include "dmem.v"  //For Lab 6 Part 1 
`include "dmem_for_dcache.v"
`include "dcacheFSM.v"
`include "imem_for_icache.v"
`include "icache.v"

`timescale 1ns/100ps
module cpu_tb;

    reg CLK, RESET;
    wire READ, WRITE, dBUSYWAIT, iBUSYWAIT, mem_read, mem_write, mem_busywait;
    wire [31:0] PC, mem_readdata, mem_writedata;
    wire [31:0] INSTRUCTION;
    wire[7:0] ADDRESS, WRITEDATA, READDATA;
    wire[5:0] mem_address;

    wire iREAD, iMem_read, iMem_busywait;
    wire [127:0] iMem_readdata;
    wire [5:0] iMem_address;
    reg [9:0]  iADDRESS;
    

    //Accessing a single instruction word at a time using a 10 bit address (10 LSBs of PC)
    always @ (PC)
    begin
        iADDRESS = {PC[9:0]};
    end
    
    /* 
    -------------------
     INSTRUCTION MEMORY
    -------------------
    */
    
    instruction_memory myInstructionMemory(CLK,iMem_read, iMem_address, iMem_readdata, iMem_busywait);
    
    /* 
    -------------------------
     INSTRUCTION CACHE MEMORY
    -------------------------
    */
   icache myInstructionCache(CLK, RESET , iADDRESS, INSTRUCTION, iBUSYWAIT, iMem_read, iMem_address, iMem_readdata, iMem_busywait);
   
    /*  
    --------------
     DATA MEMORY
    --------------
    */
    
    data_memory myDataMemory(CLK, RESET, mem_read, mem_write, mem_address, mem_writedata, mem_readdata, mem_busywait);


    /* 
    -------------------
     DATA CACHE MEMORY
    -------------------
    */
    
    dcache myDataCache(CLK, RESET, READ, WRITE, ADDRESS, WRITEDATA, READDATA, dBUSYWAIT, mem_read, mem_write, mem_address, mem_writedata, mem_readdata, mem_busywait);

    /* 
    -----
     CPU
    ----- 
    */
    cpu mycpu(PC, WRITEDATA, ADDRESS, WRITE, READ, (dBUSYWAIT || iBUSYWAIT) , INSTRUCTION, CLK, RESET, READDATA);

    integer i;

    initial begin
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, mycpu);
        
        for (i=0; i<8; i=i+1)
            $dumpvars(1, mycpu.regUnit.REGISTER[i]);
        
        for (i=0; i<256; i=i+1)
            $dumpvars(1, myDataMemory.memory_array[i]);

        for (i=0; i<8; i=i+1)
            $dumpvars(1, myDataCache.cache_memory[i]);

        for (i=0; i<8; i=i+1)
            $dumpvars(1, myDataCache.validBitArray[i]);

        for (i=0; i<8; i=i+1)
            $dumpvars(1, myDataCache.dirtyBitArray[i]);

        for (i=0; i<8; i=i+1)
            $dumpvars(1, myDataCache.tagArray[i]);
        


        for (i=0; i<1024; i=i+1)
            $dumpvars(1, myInstructionMemory.memory_array[i]);
        
        for (i=0; i<8; i=i+1)
            $dumpvars(1, myInstructionCache.iCache_memory[i]);

        for (i=0; i<8; i=i+1)
            $dumpvars(1, myInstructionCache.validBitArray[i]);

        for (i=0; i<8; i=i+1)
            $dumpvars(1, myInstructionCache.tagArray[i]);
        
        $dumpvars(0, myDataCache);
        $dumpvars(0, myInstructionCache);
        $dumpvars(0, myInstructionMemory);
            

        RESET = 1'b0;
        CLK = 1'b0;
        
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
        RESET = 1;
        #5
        RESET = 0;
        // finish simulation after some time
        #2600
        $finish;
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
        

endmodule