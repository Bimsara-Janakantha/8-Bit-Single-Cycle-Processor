/*
    * CO224 - Computer Architecture
    * Lab 06 - Part 6
    * Instruction Cache Unit
    * Group 09 (E/20/148, E/20/157)
    * 25-06-2024
    * Version 1.0

    Instruction Word size - 4 Bytes 
    Block size - 16 Bytes (4 Instruction words)
    Cache size - 128 Bytes (8 cache entries)

*/

`timescale 1ns/100ps

module icache(// Ports connected to CPU
    CLK, RESET , iADDRESS, INSTRUCTION, iBUSYWAIT, 
    
    // Ports connected to Instruction Memory
    iMem_read, iMem_address, iMem_readdata, iMem_busywait
    );
    
    // Input and output port declaration
    input CLK, RESET, iMem_busywait;
    input [9:0]  iADDRESS;
    input [127:0] iMem_readdata;

    output reg iBUSYWAIT, iMem_read;
    output reg [5:0] iMem_address;
    output reg [31:0] INSTRUCTION;

    // Local nets declareation
    reg Hit;                        // indicate a hit or a miss

    wire validBit;                  // check validity of the cache data
    wire [2:0] cacheTag;            // current tag value available in the cache
    reg [127:0] iCache_memory[7:0]; // Cache memory block array (8 blocks with 16 Bytes each = 127 bits)

    reg validBitArray[7:0];         // Valid bit array for cache 8 blocks
    reg [2:0] tagArray[7:0];        // Tag array for cache 8 blocks

    reg isReadAccess;               //read access signal to read from cache
    reg isReadImem;                 //read from instruction memory

    reg [31:0] instruction_reg;

    integer i;
    
    //Tag, index, offset of the recieved 10 bit address
    reg[2:0] tag;            // reg for tag
    reg[2:0] index;          // reg for index
    reg[1:0] offset;         // reg for offset


    /* Combinational part for indexing, tag comparison for Hit deciding, etc. */

    // Initial state of the cache
    initial begin      
      for(i=0; i<8; i = i+1) begin
        validBitArray[i] = 1'b0;
        tagArray[i]      = 3'b000;
        iCache_memory[i]  = 0;
      end
    end

    //Detecting incoming memory access and
    //Split the address into Tag, Index and Offset
    always @ (iADDRESS) begin
        iBUSYWAIT <= 1;
        isReadAccess <= 1;

        tag       <= iADDRESS[9:7];
        index     <= iADDRESS[6:4];
        offset    <= iADDRESS[3:2];
        $display("time: %g\tAddress: %b\ntag: %b \t\tindex: %b \t\toffset: %b",$time, iADDRESS, tag, index, offset);
    end

    // extracting stored data blocks wrt given index
    assign #1 validBit = validBitArray[index];
    assign #1 cacheTag = tagArray[index];

    // Tag comparison and validation
    always @(*) begin
        if(isReadAccess) begin
            #0.9
            if(validBit && (tag == cacheTag)) begin
                Hit <= 1; // HIT
                
                $display("Instruction Read Hit @ Time: %g", $time); 
            end
            else begin
                Hit <= 0; // MISS
                $display("Instruction Read Miss @ Time: %g", $time);
            end

            //asynchronously read the cache instruction using the offset provided
            case (offset) 
                0:  instruction_reg <= #1 iCache_memory[index][31:0];
                1:  instruction_reg <= #1 iCache_memory[index][63:32];
                2:  instruction_reg <= #1 iCache_memory[index][95:64];
                3:  instruction_reg <= #1 iCache_memory[index][127:96];
                default: INSTRUCTION <= #1 8'bxxxx_xxxx;
            endcase    
           
      end
    end

    always @(*) begin
        
        if (Hit) begin
            iBUSYWAIT <= 0;
            INSTRUCTION <= instruction_reg;
        end
    end

    /* Cache Controller FSM Start */

    parameter IDLE = 1'b0, iMEM_READ = 1'b1;
    reg state, next_state;

    // combinational next state logic
    always @(*) begin
        case (state)
            IDLE:
                if (isReadAccess && !Hit)  
                    next_state = iMEM_READ;
                else
                    next_state = IDLE; 
            
            iMEM_READ:
                if (!iMem_busywait)
                    next_state = IDLE;
                else    
                    next_state = iMEM_READ;
        endcase
    end

    // combinational output logic
    always @(*)
    begin
        case(state)
            IDLE:
            begin
               iMem_read = 0;
               
            end
         
            iMEM_READ: 
            begin
                iMem_read = 1;
                iMem_address = {tag, index};
                iBUSYWAIT = 1;
                isReadImem = !iMem_busywait;
            end
         
        endcase
    end

    // sequential logic for state transitioning 
    always @(posedge CLK, RESET)
    begin
        if(RESET) begin
            state = IDLE;
            for(i=0; i<8; i = i+1) begin
                validBitArray[i] = 1'b0;
                tagArray[i]      = 3'b000;
                iCache_memory[i]  = 0;
            end
            isReadImem       <= 0;
        end
        else
            state = next_state;
    end

    always @ (posedge CLK) begin
        
        if (isReadImem) begin  // READ MISS

            #1 
            iCache_memory[index]=iMem_readdata;  //update cache block (128 bits)
            validBitArray[index] = 1'b1;         //set validbit to 1
            tagArray[index] = tag;               //Update the tag 

            isReadImem = 0;
       
        end
    end

    /* Cache Controller FSM End */

endmodule