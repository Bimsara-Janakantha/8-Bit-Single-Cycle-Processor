// This is a sample assembly program for CO224 Lab 5
loadi 1 0x01 
loadi 2 0x90 
bne 0x02 1 2
loadi 3 0x02
loadi 4 0x05
sll 3 1 0x03
srl 4 2 0x04
sra 5 2 0x02
ror 6 2 0x03
mult 6 4 3