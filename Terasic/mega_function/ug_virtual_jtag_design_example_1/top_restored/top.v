--/******************************************************************************
--* Copyright © 2006 Altera Corporation, San Jose, California, USA.             *
--* All rights reserved. All use of this software and documentation is          *
--* subject to the License Agreement located at the end of this file below.     *
--******************************************************************************
--/******************************************************************************
--*                                                                             *
--* License Agreement                                                           *
--*                                                                             *
--* Copyright (c) 2006 Altera Corporation, San Jose, California, USA.           *
--* All rights reserved.                                                        *
--*                                                                             *
--* Permission is hereby granted, free of charge, to any person obtaining a     *
--* copy of this software and associated documentation files (the "Software"),  *
--* to deal in the Software without restriction, including without limitation   *
--* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
--* and/or sell copies of the Software, and to permit persons to whom the       *
--* Software is furnished to do so, subject to the following conditions:        *
--*                                                                             *
--* The above copyright notice and this permission notice shall be included in  *
--* all copies or substantial portions of the Software.                         *
--*                                                                             *
--* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
--* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
--* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
--* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
--* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
--* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
--* DEALINGS IN THE SOFTWARE.                                                   *
--*                                                                             *
--* This agreement shall be governed in all respects by the laws of the State   *
--* of California and by the laws of the United States of America.              *
--* Altera does not recommend, suggest or require that this reference design    *
--* file be used in conjunction or combination with any other product.          *
--******************************************************************************


/* This Top Level Module contains no logic - It just routes out ports from the timestamp 
information to the FPGA interface.  Replace the ports with ports relevant to your design
*/

module top (

  input clk, n_reset,



  output [6:0] revision,
  output [3:0] subrevision,
  output [6:0] year,
  output [3:0] month,
  output [4:0] day,
  output [4:0] hour,
  output [5:0] minute,	
	
	
  output blink 
	);



//*~*~*~*~*~*~*~*~*~*Replace the following placeholder with your design logic*~*

reg [25:0] count;

always @(posedge clk)
	count <= count + 1'b1;
	
assign blink = count[25]; 

//*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~**~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*~*




// Logic section for revision information and Virtual JTAG communication controller:
// Add the following to your design;  Note that none of the outputs need to be hooked up. They are only here if you 
// want to bring these signals into your design fabric, but if they are left dangling, they will still connect to the
// Virtual JTAG Interface inside of vji_timestamp.v, and the JTAG stamp check will still work.  These are just 
// optional connections.

wire [5:0] minute_w;
wire [4:0] hour_w;
wire [4:0] day_w;
wire [3:0] month_w;
wire [6:0] year_w;
wire [9:0] revision_w;
wire [9:0] subrevision_w;

vji_timestamp vji_timestamp_inst(
	.aclr(!n_reset), 
	.revision(revision),
	.subrevision(subrevision),	
	.year(year),	
	.month(month),
	.day(day),	
	.hour(hour),		
	.minute(minute));
	

endmodule
