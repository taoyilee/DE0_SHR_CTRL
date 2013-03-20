//	DE0_DIGITAL_AUTO
// Digital Control Pattern Generation 
// Workhorse
//	On Terasic DE0 Platform
// (C) 2012 TYLEE @ RFVLSI LAB, NCTU
// All Rights Reserved.

module dout_SYN_vJTAG(
	input clk_in,
	input [1023:0]data_reg,	//	Data Register, 451 bits
	input  trig,				// Trigger Signal	
	input  [9:0]seq_length,
	input  clr_2_one,	
									// 11 -> All zeros
									// 01 -> All ones
	input  clr_mode,	
	output clk,	//	.clk(GPIO_0_D[0]),	// CLOCK
	output dout,	// .dout(GPIO_0_D[1]),	// Digital Input
	output syn,	//	.syn(GPIO_0_D[2])		// Sync Signal		
	output reg out_en	//	.syn(GPIO_0_D[2])		// Sync Signal		
);

reg dout_strobe;
reg async_out_en;
reg clk_strobe;
reg [9:0]counter;
reg syn_internal;
assign dout = clr_mode?(clr_2_one?1'b1:1'b0):(out_en?data_reg[counter]:1'b0);
assign syn = clr_mode?1'b0:syn_internal;
assign clk = out_en?clk_in:1'b0;

/* trigger is valid only if output is not enabled (ready mode)
	do not trigger when output is enabled otherwise 
	digital sequence may be sent  multiple times */
wire trig_and_oenb = trig & !async_out_en;		// dout	

always @ (posedge trig_and_oenb or posedge syn_internal)
begin
	if(trig_and_oenb)		
		async_out_en <= 1'b1;			
	else		
		async_out_en <= 1'b0;				
end // End of Always


always @ (negedge clk_in)
begin 								
	if(async_out_en)
	begin

		if (counter == seq_length-1'b1)
		begin
			counter <= 10'b0000_0000_00;
			syn_internal <= 1'b1;
			out_en <= 1'b0;
		end
		else if (counter == 10'b0000_0000_00 & out_en==1'b0)
		begin
			syn_internal <= 1'b0;
			out_en <= 1'b1;
		end
		else
		begin
			counter <= counter + 1'b1; 
			syn_internal <= 1'b0;
			out_en <= 1'b1;
		end
	end	
	else
		begin
		syn_internal <= 1'b0;
		counter <= 10'b0000_0000_00;
		out_en <= 1'b0;
		end
end // End of Always
endmodule // End of Module counter
