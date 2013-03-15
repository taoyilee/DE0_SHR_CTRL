//	DE0-Nano DE0_DIGITAL_AUTO

module DE0_DIGITAL_AUTO(
	input CLOCK_50,			// CLOCK //	
	output [7:0] LED,			// LED //
	input [1:0]	KEY,			// KEY //	
	input [3:0]	SW,			// SW //	
	inout [33:0] GPIO_0_D,	// GPIO_0, GPIO_0 connect to GPIO Default //
	inout [33:0] GPIO_1_D	// GPIO_0, GPIO_0 connect to GPIO Default //	
);


wire CLOCK_1;
assign GPIO_1_D[7:0] = 8'b0000_0000;
assign GPIO_1_D[9] = 1'b0;
assign GPIO_1_D[11] = 1'b0;
assign GPIO_1_D[13] = 1'b0;
assign GPIO_1_D[15] = 1'b0;
assign GPIO_1_D[33:17] = 17'b000_000_000_000_000_00;

assign GPIO_0_D[33:0] = GPIO_1_D[33:0];
assign LED[0] = ~KEY[0];
assign LED[1] = ~KEY[1];
// assign LED[2] = SW[0];

assign LED[4] = ~GPIO_1_D[8]; // DOUT
assign LED[5] = ~GPIO_1_D[10]; // DIN
assign LED[6] = ~GPIO_1_D[12]; // CLK
assign LED[7] = ~GPIO_1_D[14]; // SYNC

assign GPIO_1_D[16] = CLOCK_1;

DIN_SYN_vJTAG U0(
	.clk_in(CLOCK_1),
	.trig(~KEY[0]), 
	.dump(~KEY[1]), 
	.clk(GPIO_1_D[12]),	// CLOCK
	.din(GPIO_1_D[10]),	// Digital Input
	.syn(GPIO_1_D[14
	]),	// Sync Signal
	.out_en(LED[2]),
	.clk_out_en(LED[3]),
	.clr_mode(SW[1:0]),
	.data_reg(out_reg[490:0])
	);
	
pll pll0(
	.inclk0(CLOCK_50), 
	.c0(CLOCK_1)
	);
	
wire tdo;
wire tdi;
wire tck;
wire virtual_state_sdr;
wire virtual_state_udr;
wire ir_in;
wire [490:0]out_reg;
vJTAG_buffer U1  (
	.tck(tck),
	.tdi(tdi), 	
	.ir_in(ir_in),
	.v_sdr(virtual_state_sdr), 
	.udr(virtual_state_udr),	
	.out_reg(out_reg[490:0]), 
	.tdo(tdo)
	);

vJTAG U2(	
	.tdo(tdo),
	.ir_in(ir_in),
	.tck(tck),
	.tdi(tdi),
	.virtual_state_sdr(virtual_state_sdr),
	.virtual_state_udr(virtual_state_udr));

endmodule
