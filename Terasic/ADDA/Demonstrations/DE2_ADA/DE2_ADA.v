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
// Major Functions:	DE2 TOP LEVEL
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Johnny Chen       :| 05/08/19  :| Initial Revision
//   V1.4 :| Allen  Wang       :| 10/09/01  :| Updata 
// --------------------------------------------------------------------

module DE2_ADA(

	//////// CLOCK //////////
	CLOCK_50,
	//////// GPIO //////////
	ADC_CLK_A,
	ADC_CLK_B,
	ADC_DA,
	ADC_DB,
	ADC_OEB_A,
	ADC_OEB_B,
	ADC_OTR_A,
	ADC_OTR_B,
	DAC_CLK_A,
	DAC_CLK_B,
	DAC_DA,
	DAC_DB,
	DAC_MODE,
	DAC_WRT_A,
	DAC_WRT_B,
   OSC_SMA_ADC4,
	POWER_ON,
   SMA_DAC4
);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

//////////////////////////// CLOCK ///////////////////////
input		          		CLOCK_50;
//////////////////////////// GPIO ///////////////////////
output		          	ADC_CLK_A;
output		          	ADC_CLK_B;
input		    [13:0]		ADC_DA;
input		    [13:0]		ADC_DB;
output		          	ADC_OEB_A;
output		          	ADC_OEB_B;
input		          		ADC_OTR_A;
input		          		ADC_OTR_B;
output		          	DAC_CLK_A;
output		          	DAC_CLK_B;
output		 [13:0]		DAC_DA;
output		 [13:0]		DAC_DB;
output		          	DAC_MODE;
output		          	DAC_WRT_A;
output		          	DAC_WRT_B;
output		        		POWER_ON;
output                  OSC_SMA_ADC4;
output                  SMA_DAC4;

DE2_ADDA_TOP       U1  (
                        .CLOCK_50	 (CLOCK_50),
                        .ADC_CLK_A	 (ADC_CLK_A),
								.ADC_CLK_B   (ADC_CLK_B),
								.ADC_DA		 (ADC_DA),
								.ADC_DB		 (ADC_DB),
								.ADC_OEB_A	 (ADC_OEB_A),
								.ADC_OEB_B	 (ADC_OEB_B),
								.ADC_OTR_A   (ADC_OTR_A),
								.ADC_OTR_B	 (ADC_OTR_B),
								.DAC_CLK_A	 (DAC_CLK_A),
								.DAC_CLK_B   (DAC_CLK_B),
								.DAC_DA		 (DAC_DA),
								.DAC_DB		 (DAC_DB),
								.DAC_MODE	 (DAC_MODE),
								.DAC_WRT_A	 (DAC_WRT_A),
								.DAC_WRT_B	 (DAC_WRT_B),
								.POWER_ON    (POWER_ON),
								.OSC_SMA_ADC4(OSC_SMA_ADC4),
							   .SMA_DAC4    (SMA_DAC4)
                        );
endmodule

