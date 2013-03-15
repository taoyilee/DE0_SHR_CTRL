//	DE0_DIGITAL_AUTO
// Digital Control Pattern Generation 
//	On Terasic DE0 Platform
// (C) 2012 TYLEE @ RFVLSI LAB, NCTU
// All Rights Reserved.

module vJTAG_buffer (
	input tck, 
	input tdi, 
	input aclr,
	input [1:0]ir_in,
	input v_sdr, 
	input udr,
	output reg [490:0] out_reg, 
	output reg tdo,
	output [1:0]vkey

);

reg DR0_bypass_reg; // Safeguard in case bad IR is sent through JTAG 
reg [490:0] DR1; // Date, time and revision DR.  We could make separate Data Registers for each one, but

//wire ir_in0 = (ir_in==2'b00)?1'b1:1'b0; //Data Register 1 will collect the new LED Settings
wire ir_in1 = (ir_in==2'b01)?1'b1:1'b0; //Data Register 1 will collect the new LED Settings
assign vkey[0] = (ir_in==2'b10)?1'b1:1'b0; //Data Register 1 will collect the new LED Settings
assign vkey[1] = (ir_in==2'b11)?1'b1:1'b0; //Data Register 1 will collect the new LED Settings

always @ (posedge tck or posedge aclr)
begin
	if (aclr)
	begin
		DR0_bypass_reg <= 1'b0;
		DR1 <= 490'b0;		end
	else
	begin
		DR0_bypass_reg <= tdi; //Update the Bypass Register Just in case the incoming data is not sent to DR1
		
		if ( v_sdr )  // VJI is in Shift DR state
			if (ir_in1) //ir_in has been set to choose DR1
					DR1 <= {tdi, DR1[490:1]}; // Shifting in (and out) the data
			
	end
end
			
		
		
//Maintain the TDO Continuity
always @ (*)
begin
	if (ir_in1)
		tdo <= DR1[0];
    else 
		tdo <= DR0_bypass_reg;	
end		

//The udr signal will assert when the data has been transmitted and it's time to Update the DR
//  so copy it to the Output LED register. 
//  Note that connecting the LED's to the DR1 register will cause an unwanted behavior as data is shifted through it
always @(udr)
begin
	out_reg <= DR1;
end

endmodule

