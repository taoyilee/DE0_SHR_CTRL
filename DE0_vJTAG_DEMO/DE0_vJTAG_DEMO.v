
module DE0_vJTAG_DEMO(
	input CLOCK_50,			// CLOCK //	
	output [7:0] LED			// LED //	
);


wire VSW_R_CLRTO1;
wire VK_SEND;
wire tdo;
wire tdi;
wire tck;
wire td_a;
wire [2:0]ir_in;
wire [1024:0]out_reg;
wire VSW_R_CLEAR;
wire virtual_state_sdr;
wire virtual_state_udr;
wire virtual_state_uir;
wire virtual_state_cir;
assign LED[7:0] = 8'b0;



vJTAG_buffer U1  (
	.tck(tck),
	.tdi(tdi), 	
	.ir_in(ir_in[2:0]),
	.v_sdr(virtual_state_sdr), 
	.udr(virtual_state_udr),	
	.out_reg(out_reg[1023:0])
	);
	
vKEY U2  (	
	.ir_in(ir_in[2:0]),
	.VSW_R_CLEAR(VSW_R_CLEAR),
	.VSW_R_CLRTO1(VSW_R_CLRTO1),
	.uir(virtual_state_uir),
	.ir_VK_SEND(VK_SEND),
	.tck(tck)
	);

vJTAG U3(	
	.tdo(tdo),
	.ir_in(ir_in[2:0]),
	.tck(tck),
	.tdi(tdi),
	.virtual_state_sdr(virtual_state_sdr),
	.virtual_state_udr(virtual_state_udr),
	.virtual_state_cir(virtual_state_cir),
	.virtual_state_uir(virtual_state_uir)
	);

endmodule
