module vji_timestamp (
	input aclr,
	output [6:0] revision,
	output [3:0] subrevision,
	output [6:0] year,
	output [3:0] month,	
	output [4:0] day,	
	output [4:0] hour,	
	output [5:0] minute
);

	wire [7:0] compile_num_w;
	wire [6:0] revision_w;
	wire [3:0] subrevision_w;
	wire [6:0] year_w;	
	wire [3:0] month_w;	
	wire [4:0] day_w;	
	wire [4:0] hour_w;	
	wire [5:0] minute_w;

reg DR0_bypass_reg; // Safeguard in case bad IR is sent through JTAG 
reg [45:0] DR1_stamp; // Date, time and revision DR.  We could make separate Data Registers for each one, but
			// not necessary since we can pull them out in Tcl interface

// VJI signals
reg tdo;
wire ir_in, tck, tdi, v_sdr;

wire select_DR0 = !ir_in; // Default to 0, which is the bypass register
wire select_DR1 = ir_in;

/* Bypass register */
always @ (posedge tck or posedge aclr)
begin
	if (aclr)
	begin
		DR0_bypass_reg <= 1'b0;
		DR1_stamp <= {revision_w, subrevision_w, year_w, month_w, day_w, hour_w, minute_w, compile_num_w};
	end
	else
	begin
		DR0_bypass_reg <= tdi;
		if ( v_sdr )  // VJI is in Shift DR state
			if (select_DR1) //ir_in has been set to choose DR1
					DR1_stamp <= {DR1_stamp[0], DR1_stamp[45:1]}; // Make DR1_stamp a circular buffer...
	end
end
			

		
		
/* Node TDO Output */
always @ (*)
begin
	if (select_DR1)
		tdo <= DR1_stamp[0];
    else 
		tdo <= DR0_bypass_reg;	
end		

assign revision = revision_w;
assign subrevision = subrevision_w;
assign year = year_w;
assign month = month_w;
assign day = day_w;
assign hour = hour_w;
assign minute = minute_w;

timestamp timestamp_inst (
	.revision(revision_w),
	.subrevision(subrevision_w),
	.minute(minute_w),
	.hour(hour_w),
	.day(day_w),
	.month(month_w),
	.year(year_w),
	.compile_num(compile_num_w));


vji_interface	vji_interface_inst (
	.ir_out ( ),
	.tdo ( tdo ),
	.ir_in ( ir_in ),
	.tck ( tck ),
	.tdi ( tdi ),
	.virtual_state_cdr (  ),
	.virtual_state_cir (  ),
	.virtual_state_e1dr (  ),
	.virtual_state_e2dr (  ),
	.virtual_state_pdr (  ),
	.virtual_state_sdr ( v_sdr ),
	.virtual_state_udr (  ),
	.virtual_state_uir (  )
	);

endmodule


