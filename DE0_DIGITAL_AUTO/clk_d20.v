//	DE0_DIGITAL_AUTO
// Digital Control Pattern Generation 
// Workhorse
//	On Terasic DE0 Platform
// (C) 2012 TYLEE @ RFVLSI LAB, NCTU
// All Rights Reserved.

module clk_d20(
	input clk_in,
	output reg clk
);

reg [4:0]counter;
parameter div = 20; 

wire toggle = (counter==0)?1'b1:1'b0;

always @ (posedge clk_in)
begin 	
	if(counter == div)
		counter <= 1'b0;
	else
		counter <= counter +1'b1;
end // End of Always


always @ (posedge toggle)
begin 	
	clk = ~clk;
end // End of Always
endmodule // End of Module counter

