//iteration number 786
module timestamp (compile_num, revision, subrevision, year, month, day, hour, minute);
  output [6:0] revision;
  output [3:0] subrevision;
  output [6:0] year;
  output [3:0] month;
  output [4:0] day;
  output [4:0] hour;
  output [5:0] minute;
  output [7:0] compile_num;
 
  //time_baseten = 08 12 09 13 46
 
  assign compile_num = 8'd786;
  assign revision = 7'd63;
  assign subrevision = 4'd7;
  assign year = 7'd08;
  assign month = 4'd12;
  assign day = 5'd09;
  assign hour = 5'd13;
  assign minute = 6'd46;
    
endmodule
