//	DE0-Nano Template

module DE0_NANO(
	input CLOCK_50,			// CLOCK //	
	output [7:0] LED,			// LED //
	input [1:0]	KEY,			// KEY //
	input [3:0]	SW,			// SW //
	output [12:0] DRAM_ADDR,// SDRAM //
	output [1:0] DRAM_BA,	// SDRAM //
	output DRAM_CAS_N,		// SDRAM //
	output DRAM_CKE,			// SDRAM //
	output DRAM_CLK,			// SDRAM //
	output DRAM_CS_N,			// SDRAM //
	inout [15:0] DRAM_DQ,	// SDRAM //
	output [1:0] DRAM_DQM,	// SDRAM //
	output DRAM_RAS_N,		// SDRAM //
	output DRAM_WE_N,			// SDRAM //
	output EPCS_ASDO,			// EPCS //
	input EPCS_DATA0,			// EPCS //
	output EPCS_DCLK,			// EPCS //
	output EPCS_NCSO,			// EPCS //
	output G_SENSOR_CS_N,	// Accelerometer and EEPROM //
	input G_SENSOR_INT,		// Accelerometer and EEPROM //
	output I2C_SCLK,			// Accelerometer and EEPROM //
	inout I2C_SDAT,			// Accelerometer and EEPROM //	
	output ADC_CS_N,			// ADC //
	output ADC_SADDR,			// ADC //
	output ADC_SCLK,			// ADC //
	input ADC_SDAT,			// ADC //
	inout [12:0] GPIO_2,		// 2x13 GPIO Header //
	input [2:0]	GPIO_2_IN,	// 2x13 GPIO Header //
	inout [33:0] GPIO_0_D,	// GPIO_0, GPIO_0 connect to GPIO Default //
	input [1:0]	GPIO_0_IN,	// GPIO_0, GPIO_0 connect to GPIO Default //
	inout [33:0] GPIO_1_D,	// GPIO_0, GPIO_1 connect to GPIO Default //
	input [1:0]	GPIO_1_IN	// GPIO_0, GPIO_1 connect to GPIO Default //
);

//	Body
assign GPIO_2[12:0] = 13'bz;
assign GPIO_0_D[33:0] = 34'bz;
assign GPIO_1_D[33:0] = 34'bz;
assign DRAM_DQ[15:0] = 16'bz;
assign I2C_SDAT = 1'bz;
assign LED[7:0] = 8'b1;
	
endmodule

