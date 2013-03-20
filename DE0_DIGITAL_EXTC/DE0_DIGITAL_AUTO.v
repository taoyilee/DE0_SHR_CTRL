//	DE0-Nano DE0_DIGITAL_AUTO

module DE0_DIGITAL_AUTO(
	input CLOCK_50,			// CLOCK //	
	output [7:0] LED,			// LED //
	output [33:0] GPIO_0_D,	// GPIO_0, GPIO_0 connect to GPIO Default //
	inout [33:0] GPIO_1_D	// GPIO_0, GPIO_0 connect to GPIO Default //	
);


wire VSW_R_CLRTO1;
wire VK_SEND;
wire tdo;
wire tdi;
wire tck;
wire IC_CLK;
wire CLOCK_1;
wire [2:0]ir_in;
wire [619:0]out_reg;
wire VSW_R_CLEAR;
wire virtual_state_sdr;
wire virtual_state_udr;
wire virtual_state_uir;
wire virtual_state_cir;
assign GPIO_1_D[0] = VK_SEND;
assign GPIO_1_D[1] = VSW_R_CLEAR;
assign GPIO_1_D[2] = VSW_R_CLRTO1;
assign GPIO_1_D[8:3] = 5'b0000_0;
assign GPIO_1_D[9] = 1'b0;
assign GPIO_1_D[11] = 1'b0;
assign GPIO_1_D[13] = 1'b0;
assign GPIO_1_D[15] = 1'b0;
assign GPIO_1_D[33:17] = 16'b000_000_000_000_000_0;
assign GPIO_0_D[33:0] = GPIO_1_D[33:0];
assign LED[0] = VK_SEND;
assign LED[1] = VSW_R_CLEAR;
assign LED[2] = VSW_R_CLRTO1;
assign LED[5] = ~GPIO_1_D[10]; // DIN
assign LED[6] = ~GPIO_1_D[12]; // CLK
assign LED[7] = ~GPIO_1_D[14]; // SYNC
assign GPIO_1_D[12] = IC_CLK;
assign CLOCK_1 = GPIO_0_D[16];
DIN_SYN_vJTAG U0(
	.clk_in(CLOCK_1),
	.trig(VK_SEND), 	
	.clk(IC_CLK),	// CLOCK
	.din(GPIO_1_D[10]),	// Digital Input
	.syn(GPIO_1_D[14]),	// Sync Signal
	.out_en(LED[3]),
	.clk_out_en(LED[4]),
	.clr_2_one(VSW_R_CLRTO1),
	.clr_mode(VSW_R_CLEAR),
	.data_reg(out_reg[619:0])
	);
	


vJTAG_buffer U1  (
	.tck(tck),
	.tdi(tdi), 	
	.ir_in(ir_in[2:0]),
	.v_sdr(virtual_state_sdr), 
	.udr(virtual_state_udr),	
	.out_reg(out_reg[619:0]), 
	.tdo(tdo)	
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
