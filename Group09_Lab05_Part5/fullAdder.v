/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 5
    * 1 Bit Full Adder unit
    * Group 09 (E/20/148, E/20/157)
    * 27-05-2024
    * Version 1.0
*/

//1 Bit Full Adder unit
module fullAdder(Ain,Bin, Cin, Sum, Cout);
    // Input-output Declaration
    input Ain,Bin,Cin;
    output Sum, Cout;

    // Result
    assign Sum = Ain^Bin^Cin;
    assign Cout = (Ain&Bin) | (Ain&Cin) | (Bin&Cin);
    
endmodule