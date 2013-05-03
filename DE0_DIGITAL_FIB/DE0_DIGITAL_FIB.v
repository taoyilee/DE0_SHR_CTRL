//	DE0-Nano DE0_DIGITAL_AUTO

module DE0_DIGITAL_FIB(
	input CLOCK_50,			// CLOCK //	
	output [7:0] LED,			// LED //
	output [33:0] GPIO_0_D,	// GPIO_0, GPIO_0 connect to GPIO Default //
	output [33:0] GPIO_1_D	// GPIO_0, GPIO_0 connect to GPIO Default //	
);


wire VSW_R_CLRTO1;
wire VK_SEND;
wire tdo;
wire tdi;
wire tck;
wire td_a;
wire CLOCK_10K;
wire [2:0]ir_in;
wire [1024:0]out_reg;
wire VSW_R_CLEAR;
wire virtual_state_sdr;
wire virtual_state_udr;
wire virtual_state_uir;
wire virtual_state_cir;
assign GPIO_0_D[33:0] = GPIO_1_D[33:0];
assign LED[7:0] = GPIO_1_D[7:0]; // DIN[7:0]
wire CLOCK_500;
wire [9:0]seq_length;
wire [4:0]div_base;
clk_d20 UD(
	.clk_in(CLOCK_10K),
	.div_base(div_base[4:0]),
	.clk(CLOCK_500)
);

DOUT_FIB U0(
	.clk_in(CLOCK_500),
	.trig(VK_SEND), 	
	.clk(GPIO_1_D[16]),	// CLOCK
	.dout(GPIO_1_D[7:0]),	// Digital Input
	.syn(GPIO_1_D[28]),	// Sync Signal
//	.out_en(LED[0]),
	.clr_2_one(VSW_R_CLRTO1),
	.clr_mode(VSW_R_CLEAR),
	.data_reg(out_reg[1023:0]),
	.seq_length(seq_length[9:0])
	);
	
pll pll0(
	.inclk0(CLOCK_50), 
	.c0(CLOCK_10K)
	);
	

seq_length U4  (
	.tck(tck),
	.tdi(tdi), 	
	.ir_in(ir_in[2:0]),
	.v_sdr(virtual_state_sdr), 
	.udr(virtual_state_udr),		
	.seq_length(seq_length[9:0]),
	.div_base(div_base[4:0])
	);
	
	
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
