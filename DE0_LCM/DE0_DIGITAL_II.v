//	DE0-Nano DE0_DIGITAL_AUTO

module DE0_DIGITAL_II(
	input CLOCK_50,			// CLOCK //	
	output [7:0] LED,			// LED //
	inout [33:0] GPIO_0_D,	// GPIO_0, GPIO_0 connect to GPIO Default //
	output [33:0] GPIO_1_D	// GPIO_0, GPIO_0 connect to GPIO Default //	
);

assign GPIO_0_D[33:0] = 34'b11111_11111_11111_11111_11111_11111_1111;
assign GPIO_1_D[33:0] = 34'b11111_11111_11111_11111_11111_11111_1111;
assign LED[7:0] = 7'b1;
endmodule
