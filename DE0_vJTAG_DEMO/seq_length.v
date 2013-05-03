//	DE0_DIGITAL_AUTO
// Digital Control Pattern Generation 
//	On Terasic DE0 Platform
// (C) 2012 TYLEE @ RFVLSI LAB, NCTU
// All Rights Reserved.

module seq_length (
	input tck, 
	input tdi, 
	input aclr,
	input [2:0]ir_in,
	input v_sdr, 
	output reg [9:0]seq_length, 
	output reg [4:0]div_base, 
	input udr
);

reg DR0_bypass_reg; // Safeguard in case bad IR is sent through JTAG 
reg [14:0] DR1; // Date, time and revision DR.  We could make separate Data Registers for each one, but

wire ir_SEQ = (ir_in==3'b111)?1'b1:1'b0; 

always @ (posedge tck or posedge aclr)
begin
	if (aclr)
	begin
		DR0_bypass_reg <= 1'b0;
		DR1 <= 15'b0;		
	end
	else
	begin
		DR0_bypass_reg <= tdi; //Update the Bypass Register Just in case the incoming data is not sent to DR1
		
		if ( v_sdr )  // VJI is in Shift DR state
			if (ir_SEQ) //ir_in has been set to choose DR1
				DR1 <= {tdi, DR1[14:1]}; // Shifting in (and out) the data			
	end
end
			
		
//The udr signal will assert when the data has been transmitted and it's time to Update the DR
//  so copy it to the Output LED register. 
//  Note that connecting the LED's to the DR1 register will cause an unwanted behavior as data is shifted through it
always @(posedge udr)
begin
	seq_length <= DR1[9:0];
	div_base <= DR1[14:10];
end

endmodule
