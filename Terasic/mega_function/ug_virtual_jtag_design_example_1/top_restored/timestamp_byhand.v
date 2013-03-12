module timestamp (
	output [6:0] revision,
	output [3:0] subrevision,
	output [6:0] year,
	output [3:0] month,	
	output [4:0] day,	
	output [4:0] hour,	
	output [5:0] minute

);
  
	assign revision = 7'b1000110;
	assign subrevision = 4'b0010;
	assign year = 7'b0010111;	
	assign month = 4'b0001;	
	assign day = 5'b10001;
	assign hour = 5'b10010;		
	assign minute = 6'b001100;
    
endmodule
