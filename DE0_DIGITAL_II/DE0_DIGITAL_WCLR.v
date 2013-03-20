//	DE0-Nano Template

module DE0_DIGITAL(
	input CLOCK_50,			// CLOCK //	
	output [7:0] LED,			// LED //
	input [1:0]	KEY,			// KEY //	
	output [33:0] GPIO_0_D,	// GPIO_0, GPIO_0 connect to GPIO Default //
	output [33:0] GPIO_1_D	// GPIO_0, GPIO_0 connect to GPIO Default //
);


wire CLOCK_1;
assign GPIO_0_D[33:4] = 30'b00000_00000_00000_00000_00000;
assign GPIO_1_D[33:0] = GPIO_0_D[33:0];
assign LED[7:4] = 4'b1111;
assign LED[0] = ~KEY[0];
assign LED[1] = ~KEY[1];
assign GPIO_0_D[3] = CLOCK_1;

din_syn U0(
	.clk_in(CLOCK_1),
	.trig(~KEY[0]), 
	.dump(~KEY[1]), 
	.clk(GPIO_0_D[0]),	// CLOCK
	.din(GPIO_0_D[1]),	// Digital Input
	.syn(GPIO_0_D[2]),	// Sync Signal
	.out_en(LED[2]),
	.clk_out_en(LED[3])
	);
	
pll pll0(
	.inclk0(CLOCK_50), 
	.c0(CLOCK_1)
	);

endmodule
