/*
Module        : Data Cache 
Author        : Isuru Nawinne, Kisaru Liyanage
Date          : 25/05/2020
Modified by   : E/20/148, E/20/157
Last Modified : 14/06/2024

Description	:
This file presents a skeleton implementation of the cache controller using a Finite State Machine model. 
*/
`timescale 1ns/100ps

module dcache (
    // Ports connected to CPU
    CLK, RESET, READ, WRITE, ADDRESS, WRITEDATA, READDATA, dBUSYWAIT, 

    // Ports connected to Data Memory
    mem_read, mem_write, mem_address, mem_writedata, mem_readdata, mem_busywait
    );

    // Input and output port declaration
    input CLK, RESET, READ, WRITE, mem_busywait;
    input [7:0] WRITEDATA, ADDRESS;
    input [31:0] mem_readdata;

    output reg dBUSYWAIT, mem_read, mem_write;
    output reg [5:0] mem_address;
    output reg [7:0] READDATA;
    output reg [31:0] mem_writedata;

    // Local nets declareation
    reg[2:0] tag;            // reg for tag
    reg[2:0] index;          // reg for index
    reg[1:0] offset;         // reg for offset

    reg hit;                 // check validity of the cache data
    wire dirty;              // check consistancy of the write data
    wire validBit;           // check validity of the cache data
    wire [2:0] cachetag;     // current tag value available in the cache
    reg validBitArray[7:0];  // Valid bit array for cache 8 blocks
    reg dirtyBitArray[7:0];  // Dirty bit array for cache 8 blocks
    reg [2:0] tagArray[7:0];
    reg isWriteMiss;
    reg isReadDmem;

    reg [31:0] cache_memory[7:0]; // Cache memory block array

    integer i;

    /* Combinational part for indexing, tag comparison for hit deciding, etc. */

    // Initial state
    initial begin      
      for(i=0; i<8; i = i+1) begin
        validBitArray[i] = 1'b0;
        dirtyBitArray[i] = 1'b0;
        tagArray[i]      = 3'b000;
        cache_memory[i]  = 0;
        isWriteMiss = 0;
      end
    end

    // Handling busywait signal
    always @ (READ, WRITE) begin
      dBUSYWAIT = (READ || WRITE) ? 1 : 0; // If read or write signal came busywait = 1
    end
    
    // separating cpu address into tag, index, offset
    always @ (ADDRESS) begin
        tag       <= ADDRESS[7:5];
        index     <= ADDRESS[4:2];
        offset    <= ADDRESS[1:0];
        $display("time: %g\tAddress: %b\ntag: %b \t\tindex: %b \t\toffset: %b",$time, ADDRESS, tag, index, offset);
    end

    // extracting stored data blocks wrt given index
    assign #1 dirty    = dirtyBitArray[index];
    assign #1 validBit = validBitArray[index];
    assign #1 cachetag = tagArray[index];
    
    // Tag comparison and validation
    always @(*) begin
      #0.9
      if(validBit && (tag == cachetag)) begin
        hit <= 1; // HIT
        dBUSYWAIT <= 0;
        isWriteMiss <= 0;
        
        $display("WriteHit @ Time: %g", $time);
        
      end
      else begin
        hit <= 0; // MISS
        if (WRITE) begin
          isWriteMiss <= 1;
          $display("WriteMiss @ Time: %g", $time);
        end
      end

      // READ HIT :: extracting data and sending to the CPU asynchronously
      if (READ && !WRITE) begin  // If the request is a Read request
            if(hit) begin // If the request is a hit
                case (offset) 
                    0: READDATA <= #1 cache_memory[index][7:0];
                    1: READDATA <= #1 cache_memory[index][15:8];
                    2: READDATA <= #1 cache_memory[index][23:16];
                    3: READDATA <= #1 cache_memory[index][31:24];
                    default: READDATA <= #1 8'bxxxx_xxxx;
                endcase
            end
        end
    end

    /* 
        Reading/ writing memory
        1). Hit ::  Valid bit = 1 && Tag is matching        => hit = 1
        2). Miss::  Valid bit = 0 || Tag is not matching    => hit = 0
    */

    always @ (posedge CLK) begin
        // HIT
        if (hit && !READ && WRITE) begin // WRITE HIT
            case (offset) 
                0: cache_memory[index][7:0]   = #1 WRITEDATA;
                1: cache_memory[index][15:8]  = #1 WRITEDATA;
                2: cache_memory[index][23:16] = #1 WRITEDATA;
                3: cache_memory[index][31:24] = #1 WRITEDATA;
            endcase
            dirtyBitArray[index] = 1;
        end

        // MISS
        else if (isReadDmem) begin // READ MISS
            #1 
            cache_memory[index] = mem_readdata;  // Write to cache (READ MISS)
            if (isWriteMiss) begin
                case (offset) 
                    0: cache_memory[index][7:0]   = WRITEDATA;
                    1: cache_memory[index][15:8]  = WRITEDATA;
                    2: cache_memory[index][23:16] = WRITEDATA;
                    3: cache_memory[index][31:24] = WRITEDATA;
                endcase    
                dirtyBitArray[index] = 1;            // Set dirty current place
            end
            else begin
                case (offset) 
                    0: READDATA = cache_memory[index][7:0];
                    1: READDATA = cache_memory[index][15:8];
                    2: READDATA = cache_memory[index][23:16];
                    3: READDATA = cache_memory[index][31:24];
                    default: READDATA = 8'bxxxx_xxxx;
                endcase
            end            
            dBUSYWAIT = 0;  
            validBitArray[index] = 1;
            tagArray[index] = tag;     
            isWriteMiss = 0;         // Set writeMiss to the default value
            isReadDmem = 0;
        end
    end
   

        /* Cache Controller FSM Start */

        parameter IDLE = 3'b000, MEM_READ = 3'b001, MEM_WRITE = 3'b010;
        reg [2:0] state, next_state;

        // combinational next state logic
        always @(*) begin
            case (state)
                IDLE:
                    if ((READ || WRITE) && !dirty && !hit)  
                        next_state = MEM_READ;
                    else if ((READ || WRITE) && dirty && !hit)
                        next_state = MEM_WRITE;
                    else
                        next_state = IDLE; 
                
                MEM_READ:
                    if (!mem_busywait)
                        next_state = IDLE;
                    else    
                        next_state = MEM_READ;

                MEM_WRITE:
                    if (!mem_busywait)
                        next_state = MEM_READ;
                    else    
                        next_state = MEM_WRITE;
            endcase
        end

        // combinational output logic
        always @(*)
        begin
            case(state)
                IDLE:
                begin
                    mem_read = 0;
                    mem_write = 0;
                end
            
                MEM_READ: 
                begin
                    mem_read = 1;
                    mem_write = 0;
                    mem_address = {tag, index};
                    mem_writedata = 32'dx;
                    dBUSYWAIT = 1;
                    isReadDmem = !mem_busywait;
                end

                // Later
                MEM_WRITE: 
                begin
                    mem_read = 0;
                    mem_write = 1;
                    mem_address = {cachetag, index};
                    mem_writedata = cache_memory[index];
                    dBUSYWAIT = 1;
                    dirtyBitArray[index] = mem_busywait;
                end            
            endcase
        end

        // sequential logic for state transitioning 
        always @(posedge CLK, RESET)
        begin
            if(RESET) begin
                state = IDLE;
                validBitArray[i] <= 1'b0;
                dirtyBitArray[i] <= 1'b0;
                tagArray[i]      <= 3'b000;
                cache_memory[i]  <= 0;
                isWriteMiss      <= 0;
                isReadDmem       <= 0;
            end
            else
                state = next_state;
        end

        /* Cache Controller FSM End */
endmodule