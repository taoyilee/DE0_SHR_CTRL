//	DE0_DIGITAL_AUTO
// Digital Control Pattern Generation 
// Workhorse
//	On Terasic DE0 Platform
// (C) 2012 TYLEE @ RFVLSI LAB, NCTU
// All Rights Reserved.

module clk_d20(
	input clk_in,
	input [4:0]div_base,
	output reg clk
);

reg [4:0]counter;

always @ (posedge clk_in)
begin 	
	if(counter == div_base)
	begin
		counter <= 5'b00000;
		clk = ~clk;
	end
	else
		counter <= counter +1'b1;
end // End of Always


endmodule // End of Module counter

