set revision "63"  ;#Decimal 0-128
set subrevision "7"; #Decimal 0-19

# Creates a register bank in a verilog file with the specified value
proc write_stamp_verilog {revision subrevision} {

	set time_baseten [clock format [clock seconds] -format {%y %m %d %H %M}]

	#year 0-99, 7 bits
	#Month 1-12, 4 bits
	#year 0-99,      7 bits
	#Month 1-12,     4 bits
	#Day   1-31,     5 bits
	#Hour  0-23,     5 bits
	#Minute 0-59,    6 bits
	#Compile_num     8 bits

	set year [lindex $time_baseten 0]
	set month [lindex $time_baseten 1]
	set day [lindex $time_baseten 2]
	set hour [lindex $time_baseten 3]
	set minute [lindex $time_baseten 4]


	if {[file exists "timestamp.v"]} { 
	    set fh [open "timestamp.v" r]
	    gets $fh line
	    scan $line "%s %s %x" discard1 discard2 dec_value
	    incr dec_value
	    close $fh
	} else {
	    set dec_value 0
	}
	    



	if { [catch {
	    set fh [open "timestamp.v" w ]
	    
	    puts $fh "//iteration number $dec_value"
	    puts $fh "module timestamp (compile_num, revision, subrevision, year, month, day, hour, minute);"

	    puts $fh "  output \[6:0\] revision;"
	    puts $fh "  output \[3:0\] subrevision;"
	    puts $fh "  output \[6:0\] year;"
	    puts $fh "  output \[3:0\] month;"
	    puts $fh "  output \[4:0\] day;"
	    puts $fh "  output \[4:0\] hour;"
	    puts $fh "  output \[5:0\] minute;"
	    puts $fh "  output \[7:0\] compile_num;"

	    puts $fh " "
	    puts $fh "  //time_baseten = $time_baseten"
	    puts $fh " "
	    puts $fh "  assign compile_num = 8'd$dec_value;"
	    
	    puts $fh "  assign revision = 7'd$revision;"
	    puts $fh "  assign subrevision = 4'd$subrevision;"
	    puts $fh "  assign year = 7'd$year;"
	    puts $fh "  assign month = 4'd$month;"
	    puts $fh "  assign day = 5'd$day;"
	    puts $fh "  assign hour = 5'd$hour;"
	    puts $fh "  assign minute = 6'd$minute;"
	    puts $fh "    "
	    puts $fh "endmodule"
	    close $fh
    } res ] } {
        return -code error $res
    } else {
        return 1
    }
}

write_stamp_verilog $revision $subrevision


