// --------------------------------------------------------------------
// Copyright (c) 2005 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	DE1 TOP LEVEL
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date   :| Changes Made:
//   V1.0 :| Johnny Chen       :| 24/04/2006  :| Initial Revision
//   V1.1 :| Allen  Wang       :| 24/08/2010  :| updata to Quartus10.0
// --------------------------------------------------------------------

module DE1_TOP
	(
		////////////////////	Clock Input	 	////////////////////	 
		CLOCK_24,						//	24 MHz
		CLOCK_27,						//	27 MHz
		CLOCK_50,						//	50 MHz
		EXT_CLOCK,						//	External Clock
		////////////////////	Push Button		////////////////////
		KEY,							   //	Pushbutton[3:0]
		////////////////////	DPDT Switch		////////////////////
		SW,								//	Toggle Switch[9:0]
		////////////////////	7-SEG Dispaly	////////////////////
		HEX0,								//	Seven Segment Digit 0
		HEX1,								//	Seven Segment Digit 1
		HEX2,								//	Seven Segment Digit 2
		HEX3,								//	Seven Segment Digit 3
		////////////////////////	LED		////////////////////////
		LEDG,								//	LED Green[7:0]
		LEDR,								//	LED Red[9:0]
		////////////////////////	UART	////////////////////////
		UART_TXD,						//	UART Transmitter
		UART_RXD,						//	UART Receiver
		/////////////////////	SDRAM Interface		////////////////
		DRAM_DQ,							//	SDRAM Data bus 16 Bits
		DRAM_ADDR,						//	SDRAM Address bus 12 Bits
		DRAM_LDQM,						//	SDRAM Low-byte Data Mask 
		DRAM_UDQM,						//	SDRAM High-byte Data Mask
		DRAM_WE_N,						//	SDRAM Write Enable
		DRAM_CAS_N,						//	SDRAM Column Address Strobe
		DRAM_RAS_N,						//	SDRAM Row Address Strobe
		DRAM_CS_N,						//	SDRAM Chip Select
		DRAM_BA_0,						//	SDRAM Bank Address 0
		DRAM_BA_1,						//	SDRAM Bank Address 0
		DRAM_CLK,						//	SDRAM Clock
		DRAM_CKE,						//	SDRAM Clock Enable
		////////////////////	Flash Interface		////////////////
//		FL_DQ,							//	FLASH Data bus 8 Bits
//		FL_ADDR,							//	FLASH Address bus 22 Bits
//		FL_WE_N,							//	FLASH Write Enable
//		FL_RST_N,						//	FLASH Reset
//		FL_OE_N,							//	FLASH Output Enable
//		FL_CE_N,							//	FLASH Chip Enable
		////////////////////	SRAM Interface		////////////////
		SRAM_DQ,							//	SRAM Data bus 16 Bits
		SRAM_ADDR,						//	SRAM Address bus 18 Bits
		SRAM_UB_N,						//	SRAM High-byte Data Mask 
		SRAM_LB_N,						//	SRAM Low-byte Data Mask 
		SRAM_WE_N,						//	SRAM Write Enable
		SRAM_CE_N,						//	SRAM Chip Enable
		SRAM_OE_N,						//	SRAM Output Enable
		////////////////////	SD_Card Interface	////////////////
		SD_DAT,							//	SD Card Data
		SD_DAT3,							//	SD Card Data 3
		SD_CMD,							//	SD Card Command Signal
		SD_CLK,							//	SD Card Clock
		////////////////////	USB JTAG link	////////////////////
		TDI,  							// CPLD -> FPGA (data in)
		TCK,  							// CPLD -> FPGA (clk)
		TCS,  							// CPLD -> FPGA (CS)
	    TDO,  							// FPGA -> CPLD (data out)
		////////////////////	I2C		////////////////////////////
		I2C_SDAT,						//	I2C Data
		I2C_SCLK,						//	I2C Clock
		////////////////////	PS2		////////////////////////////
		PS2_DAT,							//	PS2 Data
		PS2_CLK,							//	PS2 Clock
		////////////////////	VGA		////////////////////////////
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_R,   						//	VGA Red[3:0]
		VGA_G,	 						//	VGA Green[3:0]
		VGA_B,  							//	VGA Blue[3:0]
		////////////////	Audio CODEC		////////////////////////
		AUD_ADCLRCK,					//	Audio CODEC ADC LR Clock
		AUD_ADCDAT,						//	Audio CODEC ADC Data
		AUD_DACLRCK,					//	Audio CODEC DAC LR Clock
		AUD_DACDAT,						//	Audio CODEC DAC Data
		AUD_BCLK,						//	Audio CODEC Bit-Stream Clock
		AUD_XCK,							//	Audio CODEC Chip Clock
		////////////////////	GPIO	////////////////////////////
		GPIO_0,							//	GPIO Connection 0
		GPIO_1,							//	GPIO Connection 1

		comb,
		a2dba,
		a2dbb,
	);

////////////////////////	Clock Input	 	////////////////////////
input	[1:0]	CLOCK_24;				//	24 MHz
input	[1:0]	CLOCK_27;				//	27 MHz
input			CLOCK_50;				//	50 MHz
input			EXT_CLOCK;				//	External Clock
////////////////////////	Push Button		////////////////////////
input	[3:0]	KEY;						//	Pushbutton[3:0]
////////////////////////	DPDT Switch		////////////////////////
input	[9:0]	SW;						//	Toggle Switch[9:0]
////////////////////////	7-SEG Dispaly	////////////////////////
output	[6:0]	HEX0;					//	Seven Segment Digit 0
output	[6:0]	HEX1;					//	Seven Segment Digit 1
output	[6:0]	HEX2;					//	Seven Segment Digit 2
output	[6:0]	HEX3;					//	Seven Segment Digit 3
////////////////////////////	LED		////////////////////////////
output	[7:0]	LEDG;					//	LED Green[7:0]
output	[9:0]	LEDR;					//	LED Red[9:0]
////////////////////////////	UART	////////////////////////////
output			UART_TXD;			//	UART Transmitter
input			UART_RXD;				//	UART Receiver
///////////////////////		SDRAM Interface	////////////////////////
inout		[15:0]	DRAM_DQ;			//	SDRAM Data bus 16 Bits
output	[11:0]	DRAM_ADDR;		//	SDRAM Address bus 12 Bits
output				DRAM_LDQM;		//	SDRAM Low-byte Data Mask 
output				DRAM_UDQM;		//	SDRAM High-byte Data Mask
output				DRAM_WE_N;		//	SDRAM Write Enable
output				DRAM_CAS_N;		//	SDRAM Column Address Strobe
output				DRAM_RAS_N;		//	SDRAM Row Address Strobe
output				DRAM_CS_N;		//	SDRAM Chip Select
output				DRAM_BA_0;		//	SDRAM Bank Address 0
output				DRAM_BA_1;		//	SDRAM Bank Address 0
output				DRAM_CLK;		//	SDRAM Clock
output				DRAM_CKE;		//	SDRAM Clock Enable
////////////////////////	Flash Interface	////////////////////////
//inout	[7:0]	   FL_DQ;			//	FLASH Data bus 8 Bits
//output	[21:0]	FL_ADDR;			//	FLASH Address bus 22 Bits
//output				FL_WE_N;			//	FLASH Write Enable
//output				FL_RST_N;		//	FLASH Reset
//output				FL_OE_N;			//	FLASH Output Enable
//output				FL_CE_N;			//	FLASH Chip Enable
////////////////////////	SRAM Interface	////////////////////////
inout	   [15:0]	SRAM_DQ;			//	SRAM Data bus 16 Bits
output	[17:0]	SRAM_ADDR;		//	SRAM Address bus 18 Bits
output				SRAM_UB_N;		//	SRAM High-byte Data Mask 
output				SRAM_LB_N;		//	SRAM Low-byte Data Mask 
output				SRAM_WE_N;		//	SRAM Write Enable
output				SRAM_CE_N;		//	SRAM Chip Enable
output				SRAM_OE_N;		//	SRAM Output Enable
////////////////////	SD Card Interface	////////////////////////
inout					SD_DAT;			//	SD Card Data
inout					SD_DAT3;			//	SD Card Data 3
inout					SD_CMD;			//	SD Card Command Signal
output				SD_CLK;			//	SD Card Clock
////////////////////////	I2C		////////////////////////////////
inout					I2C_SDAT;		//	I2C Data
output				I2C_SCLK;		//	I2C Clock
////////////////////////	PS2		////////////////////////////////
input		 			PS2_DAT;			//	PS2 Data
input					PS2_CLK;			//	PS2 Clock
////////////////////	USB JTAG link	////////////////////////////
input  				TDI;				// CPLD -> FPGA (data in)
input  				TCK;				// CPLD -> FPGA (clk)
input  				TCS;				// CPLD -> FPGA (CS)
output 				TDO;				// FPGA -> CPLD (data out)
////////////////////////	VGA			////////////////////////////
output				VGA_HS;			//	VGA H_SYNC
output				VGA_VS;		   //	VGA V_SYNC
output	[3:0]		VGA_R;   		//	VGA Red[3:0]
output	[3:0]		VGA_G;	 		//	VGA Green[3:0]
output	[3:0]		VGA_B;   		//	VGA Blue[3:0]
////////////////////	Audio CODEC		////////////////////////////
inout					AUD_ADCLRCK;	//	Audio CODEC ADC LR Clock
input					AUD_ADCDAT;		//	Audio CODEC ADC Data
inout					AUD_DACLRCK;	//	Audio CODEC DAC LR Clock
output				AUD_DACDAT;		//	Audio CODEC DAC Data
inout					AUD_BCLK;		//	Audio CODEC Bit-Stream Clock
output				AUD_XCK;			//	Audio CODEC Chip Clock
////////////////////////	GPIO	////////////////////////////////
inout		[35:0]	GPIO_0;			//	GPIO Connection 0
inout		[35:0]	GPIO_1;			//	GPIO Connection 1

//	Turn on all display
assign	HEX0		=	7'h00;
assign	HEX1		=	7'h00;
assign	HEX2		=	7'h00;
assign	HEX3		=	7'h00;
assign	LEDG		=	8'hFF;
assign	LEDR		=	10'h3FF;

//	All inout port turn to tri-state
assign	DRAM_DQ		=	16'hzzzz;
assign	FL_DQ		   =	8'hzz;
assign	SRAM_DQ		=	16'hzzzz;
assign	SD_DAT		=	1'bz;
assign	I2C_SDAT	   =	1'bz;
assign	AUD_ADCLRCK	=	1'bz;
assign	AUD_DACLRCK	=	1'bz;
assign	AUD_BCLK	   =	1'bz;
assign	GPIO_0		=	36'hzzzzzzzzz;
assign	GPIO_1		=	36'hzzzzzzzzz;


output	[13:0]	a2dba;
output	[13:0]	a2dbb;

assign	a2dba = {GPIO_0[31],GPIO_0[29],GPIO_0[30],GPIO_0[28],GPIO_0[27],GPIO_0[25],GPIO_0[26],GPIO_0[24],
                 GPIO_0[23],GPIO_0[21],GPIO_0[22],GPIO_0[20],GPIO_0[19],GPIO_0[17]};

assign	a2dbb = {GPIO_0[15],GPIO_0[13],GPIO_0[14],GPIO_0[12],GPIO_0[11],GPIO_0[9],GPIO_0[10],GPIO_0[8],
                 GPIO_0[7],GPIO_0[5],GPIO_0[6],GPIO_0[4],GPIO_0[3],GPIO_0[1]};


output	[13:0]	comb;

wire					CLK_65;
wire					CLK_125;

assign	{GPIO_1[19],GPIO_1[21],GPIO_1[22],GPIO_1[24],GPIO_1[23],GPIO_1[25],GPIO_1[27],GPIO_1[29],
         GPIO_1[26],GPIO_1[28],GPIO_1[31],GPIO_1[33],GPIO_1[30],GPIO_1[32]} = comb; //B

assign	{GPIO_1[1],GPIO_1[3],GPIO_1[4],GPIO_1[6],GPIO_1[5],GPIO_1[7],GPIO_1[8],GPIO_1[10],
         GPIO_1[9],GPIO_1[11],GPIO_1[12],GPIO_1[14],GPIO_1[13],GPIO_1[15]} = comb; //A

assign  GPIO_0[33] = 0; //Enable B
assign  GPIO_0[35] = 0; //Enable A

assign  GPIO_0[18] = CLK_65; //PLL Clock to ADC_B
assign  GPIO_0[16] = CLK_65; //PLL Clock to ADC_A


assign  GPIO_0[32] = 1; //POWER ON
assign  GPIO_1[35] = 1; //Mode Select. 1 = dual port, 0 = interleaved.

assign  GPIO_1[18] = CLK_125; //PLL Clock to DAC_B
assign  GPIO_1[16] = CLK_125; //PLL Clock to DAC_A

assign  GPIO_1[34] = CLK_125; //Input write signal for PORT B
assign  GPIO_1[17] = CLK_125; //Input write signal for PORT A

wire    [31:0]	phasinc1;
wire    [31:0]	phasinc2;

wire    g = 0;
wire    v = 1;


assign  phasinc1 = {g,g,g,g,v,v,g,g,v,v,g,g,v,v,g,g,v,v,g,g,v,v,g,g,v,v,g,g,v,v,g,v};
assign  phasinc2 = {g,v,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g};


wire  	[13:0]	sin10_out;
wire  	[13:0]	sin_out;


nco80_st	sin1   (
					  .clk		(CLK_125),
					  .reset_n  (v),
					  .clken    (v),
					  .phi_inc_i(phasinc1),
					  .fsin_o   (sin_out),
					  .out_valid(ovalid));

nco80_st	sin2   (
					  .clk      (CLK_125),
					  .reset_n  (v),
					  .clken    (v),
					  .phi_inc_i(phasinc2),
					  .fsin_o	(sin10_out),
					  .out_valid(ovalid));


pll  pll_100    (
					  .inclk0(CLOCK_50),
					  .pllena(v),
					  .areset(g),
					  .c0    (CLK_125),
					  .c1    (CLK_65));


lpm_add lpm     (
                 .clock (CLK_125),
					  .dataa ({g,~sin_out[12],sin_out[11:0]}),
					  .datab ({g,~sin10_out[12],sin10_out[11:0]}),
					  .result(comb));


endmodule
