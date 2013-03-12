// --------------------------------------------------------------------
// Copyright (c) 2007 by Terasic Technologies Inc. 
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
// Major Functions:	DE2_70 TOP LEVEL 
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author      :| Mod. Date   :| Changes Made:
//   V1.0 :| Johnny FAN  :| 07/07/2009  :| Initial Revision
//	 V2.0 :| Allen Wang :| 24/08/2010  :| updata to Quartus 10.0
// --------------------------------------------------------------------

module DE2_70_ADA
	(
		iCLK_50,							//	50 MHz
		////////////////////	GPIO	////////////////////////////
		GPIO_0,							//	GPIO Connection 0 I/O
		GPIO_CLKIN_N0,     				//	GPIO Connection 0 Clock Input 0
		GPIO_CLKIN_P0,          		//	GPIO Connection 0 Clock Input 1
		GPIO_CLKOUT_N0,     			//	GPIO Connection 0 Clock Output 0
		GPIO_CLKOUT_P0,            		//	GPIO Connection 0 Clock Output 1
		GPIO_1,							//	GPIO Connection 1 I/O
		GPIO_CLKIN_N1,             		//	GPIO Connection 1 Clock Input 0
		GPIO_CLKIN_P1,             		//	GPIO Connection 1 Clock Input 1
		GPIO_CLKOUT_N1,            		//	GPIO Connection 1 Clock Output 0
		GPIO_CLKOUT_P1            	    //	GPIO Connection 1 Clock Output 1
        ,sin_out
        ,sin10_out
        ,comb
        ,a2dba
        ,a2dbb
        ,CLK_100
	);

//===========================================================================
// PARAMETER declarations
//===========================================================================


//===========================================================================
// PORT declarations
//===========================================================================
////////////////////////	Clock Input	 	////////////////////////////////////////////////////////////
input				 iCLK_50;						//	50 MHz
///////////////////////////    	GPIO	   ////////////////////////////////////////////////////////////
inout		[31:0]	GPIO_0;							//	GPIO Connection 0 I/O
input				GPIO_CLKIN_N0;     		   		//	GPIO Connection 0 Clock Input 0
input				GPIO_CLKIN_P0;          	//	GPIO Connection 0 Clock Input 1
inout				GPIO_CLKOUT_N0;     			//	GPIO Connection 0 Clock Output 0
inout				GPIO_CLKOUT_P0;         	//	GPIO Connection 0 Clock Output 1
inout		[31:0]	GPIO_1;							//	GPIO Connection 1 I/O
input				GPIO_CLKIN_N1;          	//	GPIO Connection 1 Clock Input 0
input				GPIO_CLKIN_P1;          	//	GPIO Connection 1 Clock Input 1
inout				GPIO_CLKOUT_N1;         	//	GPIO Connection 1 Clock Output 0
inout				GPIO_CLKOUT_P1;         	//	GPIO Connection 1 Clock Output 1
//////////////////////////////////////////////////////////////////////////////////////////////////////////
//=============================================================================
// REG/WIRE declarations
//=============================================================================
output  [13:0]	a2dba;
output  [13:0]	a2dbb;
output  CLK_100;

assign  a2dba = {GPIO_0[27],GPIO_0[25],GPIO_0[26],GPIO_0[24],GPIO_0[23],GPIO_0[21],GPIO_0[22],GPIO_0[20],
                 GPIO_0[19],GPIO_0[17],GPIO_0[18],GPIO_0[16],GPIO_0[15],GPIO_0[14]};

assign  a2dbb = {GPIO_0[13],GPIO_0[11],GPIO_0[12],GPIO_0[10],GPIO_0[9],GPIO_0[7],GPIO_0[8],GPIO_0[6],
                 GPIO_0[5],GPIO_0[3],GPIO_0[4],GPIO_0[2],GPIO_0[1],GPIO_0[0]};

assign  {GPIO_1[15],GPIO_1[17],GPIO_1[18],GPIO_1[20],GPIO_1[19],GPIO_1[21],GPIO_1[23],GPIO_1[25],
         GPIO_1[22],GPIO_1[24],GPIO_1[27],GPIO_1[29],GPIO_1[26],GPIO_1[28]} = comb; //B

assign  {GPIO_1[0],GPIO_1[1],GPIO_1[2],GPIO_1[4],GPIO_1[3],GPIO_1[5],GPIO_1[6],GPIO_1[8],
         GPIO_1[7],GPIO_1[9],GPIO_1[10],GPIO_1[12],GPIO_1[11],GPIO_1[13]} = comb; //A

assign  GPIO_1[30] = CLK_125;   //Input write signal for PORT B
assign  GPIO_1[14] = CLK_125;   //Input write signal for PORT A

assign  GPIO_1[31] = 1; 		//Mode Select. 1 = dual port, 0 = interleaved.

assign  GPIO_0[28] = 1;		    //POWER ON

assign  GPIO_0[29] = 0; 		//Enable B
assign  GPIO_0[31] = 0; 		//Enable A



wire    [31:0]phasinc1;
wire    [31:0]phasinc2;

wire    g = 0;
wire    v = 1;

assign  phasinc1 = {g,g,g,g,v,v,g,g,v,v,g,g,v,v,g,g,v,v,g,g,v,v,g,g,v,v,g,g,v,v,g,v};
assign  phasinc2 = {g,v,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g};

output  [13:0]sin10_out;
output  [13:0]sin_out;
 
wire    sn;
wire    s10n;

assign  sn      = ~sin_out[12];
assign  s10n    = ~sin10_out[12]; 

assign  GPIO_CLKOUT_P1 = CLK_125; //PLL Clock to DAC_B
assign  GPIO_CLKOUT_N1 = CLK_125; //PLL Clock to DAC_A

assign  GPIO_CLKOUT_P0 = CLK_65; //PLL Clock to ADC_B
assign  GPIO_CLKOUT_N0 = CLK_65; //PLL Clock to ADC_A

output  [13:0]comb;

//=============================================================================
// Structural coding
//=============================================================================

NCO  sin1    (
					  .phi_inc_i (phasinc1),
                 .clk		 (CLK_125),
                 .clken		 (v),
                 .reset_n	 (g),
                 .fsin_o	 (sin_out),
					 );

NCO  sin2    (
					  .phi_inc_i (phasinc2),
                 .clk		 (CLK_125),
                 .clken		 (v),
                 .reset_n   (g),
                 .fsin_o	 (sin10_out),
					 );     

pll     pll_100 (
				 .inclk0(iCLK_50),
                 .pllena(v),
                 .areset(g),
                 .c0    (CLK_125),
                 .c1    (CLK_65)
					 );

lpm_add lpm     (
				 .clock (CLK_125),
                 .dataa ({g,sn,sin_out[11:0]}),
                 .datab ({g,s10n,sin10_out[11:0]}),
                 .result(comb)
			   );

endmodule

