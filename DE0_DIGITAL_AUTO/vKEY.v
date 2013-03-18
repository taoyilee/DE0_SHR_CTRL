//	DE0_DIGITAL_AUTO
// Digital Control Pattern Generation 
//	On Terasic DE0 Platform
// (C) 2012 TYLEE @ RFVLSI LAB, NCTU
// All Rights Reserved.

module vKEY (
	input tck, 
	input [2:0]ir_in,
	input uir,
	output reg VSW_R_CLEAR,
	output reg VSW_R_CLRTO1,
	output ir_VK_SEND
);
// IR Table
// IR=3'b000 -> JTAG Armed
// IR=3'b001 -> Data register(DR) write
// IR=3'b010 -> VK_SEND
// IR=3'b011 -> ir_SET_CLEAR
// IR=3'b100 -> ir_UNSET_CLEAR
// IR=3'b101 -> ir_SET_CLRTO1
// IR=3'b110 -> ir_UNSET_CLRTO1
// IR=3'b111 -> RESERVED

assign ir_VK_SEND 	= (ir_in==3'b010)?1'b1:1'b0; 
wire ir_SET_CLEAR 	= (ir_in==3'b011)?1'b1:1'b0; 
wire ir_UNSET_CLEAR 	= (ir_in==3'b100)?1'b1:1'b0; 
wire ir_SET_CLRTO1 	= (ir_in==3'b101)?1'b1:1'b0; 
wire ir_UNSET_CLRTO1 = (ir_in==3'b110)?1'b1:1'b0; 


always @(posedge uir)
begin
	if (ir_SET_CLEAR) 		
		VSW_R_CLEAR <=1'b1;	
	if (ir_UNSET_CLEAR) 		
		VSW_R_CLEAR <=1'b0;
	if (ir_SET_CLRTO1) 		
		VSW_R_CLRTO1 <=1'b1;	
	if (ir_UNSET_CLRTO1) 		
		VSW_R_CLRTO1 <=1'b0;	
end
endmodule
