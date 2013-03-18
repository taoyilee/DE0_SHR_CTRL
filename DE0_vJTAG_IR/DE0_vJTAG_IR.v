//	DE0-Nano DE0_DIGITAL_AUTO

module DE0_vJTAG_IR(
	input CLOCK_50,			// CLOCK //	
	output [7:0] LED
);


wire CLOCK_1;
reg [7:0]IR_W;
wire [2:0]IR_IN;
wire tdo;
wire tdi;
wire tck;
wire virtual_state_sdr;
wire virtual_state_udr;

assign LED[7:0] = IR_W[7:0];
wire CMD0 = (IR_IN==3'b000)?1'b1:1'b0;
wire CMD1 = (IR_IN==3'b001)?1'b1:1'b0;
wire CMD2 = (IR_IN==3'b010)?1'b1:1'b0;
wire CMD3 = (IR_IN==3'b011)?1'b1:1'b0;
wire CMD4 = (IR_IN==3'b100)?1'b1:1'b0;
wire CMD5 = (IR_IN==3'b101)?1'b1:1'b0;
wire CMD6 = (IR_IN==3'b110)?1'b1:1'b0;
wire CMD7 = (IR_IN==3'b111)?1'b1:1'b0;

always @ (posedge CMD0 or posedge CMD1)
begin
		IR_W[0] <= 1'b1;
		IR_W[1] <= 1'b0;		
		IR_W[2] <= 1'b0;		
		IR_W[3] <= 1'b0;		
		IR_W[4] <= 1'b0;		
		IR_W[5] <= 1'b0;		
		IR_W[6] <= 1'b0;		
		IR_W[7] <= 1'b0;				
end
always @ (posedge CMD1)
begin
		IR_W[1] <= 1'b1;
		IR_W[0] <= 1'b0;		
		IR_W[2] <= 1'b0;		
		IR_W[3] <= 1'b0;		
		IR_W[4] <= 1'b0;		
		IR_W[5] <= 1'b0;		
		IR_W[6] <= 1'b0;		
		IR_W[7] <= 1'b0;		
end
always @ (posedge CMD2)
begin
		IR_W[2] <= 1'b1;
		IR_W[0] <= 1'b0;		
		IR_W[1] <= 1'b0;		
		IR_W[3] <= 1'b0;		
		IR_W[4] <= 1'b0;		
		IR_W[5] <= 1'b0;		
		IR_W[6] <= 1'b0;		
		IR_W[7] <= 1'b0;		
end
always @ (posedge CMD3)
begin
		IR_W[3] <= 1'b1;
		IR_W[0] <= 1'b0;		
		IR_W[1] <= 1'b0;		
		IR_W[2] <= 1'b0;		
		IR_W[4] <= 1'b0;		
		IR_W[5] <= 1'b0;		
		IR_W[6] <= 1'b0;		
		IR_W[7] <= 1'b0;		
end
always @ (posedge CMD4)
begin
		IR_W[4] <= 1'b1;
		IR_W[0] <= 1'b0;		
		IR_W[1] <= 1'b0;		
		IR_W[2] <= 1'b0;		
		IR_W[3] <= 1'b0;		
		IR_W[5] <= 1'b0;		
		IR_W[6] <= 1'b0;		
		IR_W[7] <= 1'b0;		
end
always @ (posedge CMD5)
begin
		IR_W[5] <= 1'b1;
		IR_W[0] <= 1'b0;		
		IR_W[1] <= 1'b0;		
		IR_W[2] <= 1'b0;		
		IR_W[3] <= 1'b0;		
		IR_W[4] <= 1'b0;		
		IR_W[6] <= 1'b0;		
		IR_W[7] <= 1'b0;		
end

always @ (posedge CMD6)
begin
		IR_W[6] <= 1'b1;
		IR_W[0] <= 1'b0;		
		IR_W[1] <= 1'b0;		
		IR_W[2] <= 1'b0;		
		IR_W[3] <= 1'b0;		
		IR_W[4] <= 1'b0;		
		IR_W[5] <= 1'b0;		
		IR_W[7] <= 1'b0;		
end
always @ (posedge CMD7)
begin
		IR_W[7] <= 1'b1;
		IR_W[0] <= 1'b0;		
		IR_W[1] <= 1'b0;		
		IR_W[2] <= 1'b0;		
		IR_W[3] <= 1'b0;		
		IR_W[4] <= 1'b0;		
		IR_W[5] <= 1'b0;		
		IR_W[6] <= 1'b0;		
end


vJTAG U3(	
	.tdo(tdo),
	.ir_in(IR_IN[2:0]),
	.tck(tck),
	.tdi(tdi),
	.virtual_state_sdr(virtual_state_sdr),
	.virtual_state_udr(virtual_state_udr)
	);

endmodule
