//	DE0_DIGITAL_AUTO
// Digital Control Pattern Generation 
//	On Terasic DE0 Platform
// (C) 2012 TYLEE @ RFVLSI LAB, NCTU
// All Rights Reserved.

module vJTAG_buffer (
	input tck, 
	input tdi, 
	input aclr,
	input [2:0]ir_in,
	input v_sdr, 	
	input udr,
	output reg [1023:0] out_reg
	);

reg DR0_bypass_reg; // Safeguard in case bad IR is sent through JTAG 
reg [1023:0] DR1; // Date, time and revision DR.  We could make separate Data Registers for each one, but

wire ir_WRITE = (ir_in==3'b001)?1'b1:1'b0; 

always @ (posedge tck or posedge aclr)
begin
	if (aclr)
	begin
		DR0_bypass_reg <= 1'b0;
		DR1 <= 1024'b0;		
	end
	else
	begin
		DR0_bypass_reg <= tdi; //Update the Bypass Register Just in case the incoming data is not sent to DR1
		
		if ( v_sdr )  // VJI is in Shift DR state
			if (ir_WRITE) //ir_in has been set to choose DR1
				DR1 <= {DR1[1022:0], tdi}; // Shifting in (and out) the data			
	end
end
			
			

//The udr signal will assert when the data has been transmitted and it's time to Update the DR
//  so copy it to the Output LED register. 
//  Note that connecting the LED's to the DR1 register will cause an unwanted behavior as data is shifted through it
always @(udr)
begin
	out_reg <= DR1;
end

endmodule
