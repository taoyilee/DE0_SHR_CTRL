#Copyright (C) 1991-2006 Altera Corporation
#Your use of Altera Corporation's design tools, logic functions 
#and other software and tools, and its AMPP partner logic 
#functions, and any output files any of the foregoing 
#including device programming or simulation files), and any 
#associated documentation or information are expressly subject 
#to the terms and conditions of the Altera Program License 
#Subscription Agreement

# This script gives an example of how debugging utilities could be built
# Tcl APIs commuicate with sld_virtual_jtag instances in the System On a Porgrammable Chip (SOPC) design
# The complete list and details for these APIs are provided in Quartus II Scripting Reference Manual.

# Hardware required to communicate with the FPGA through JTAG port is USB Blaster (or any other download cable from Altera Corp.)

# To run, after configuring the device, either:
# quartus_stp -t get_stamp.tcl
# or:
# quartus_stp -s
# source get_stamp.tcl
#
# For help, type: 
# quartus_sh --qhelp

#### Script begins ######################################################
package require Tk


global usbblaster_name
global test_device
# List all available programming hardwares, and select the USBBlaster.
# (Note: this example assumes only one USBBlaster connected.)
# Programming Hardwares:
foreach hardware_name [get_hardware_names] {
#	puts $hardware_name
	if { [string match "USB-Blaster*" $hardware_name] } {
		set usbblaster_name $hardware_name
	}
}


#puts "\nSelect JTAG chain connected to $usbblaster_name.\n";

# List all devices on the chain, and select the first device on the chain.
#Devices on the JTAG chain:


foreach device_name [get_device_names -hardware_name $usbblaster_name] {
#	puts $device_name
	if { [string match "@1*" $device_name] } {
		set test_device $device_name
	}
}
#puts "\nSelect device: $test_device.\n";

####configure GUI

set revision_text "POF created: \nUSERCODE: \nCompile Number:"

label .top -text "FPGA Revision Information" -font bold
set msg_box [message .msg -background white -relief sunken -textvariable revision_text -width 250]
button .revinfo -text "Get Revision Info" -command {set revision_text [update_msg]}

pack .top .msg .revinfo -side top -pady 5 -padx 5



# Open device 
proc openport {} {
	global usbblaster_name
        global test_device
	open_device -hardware_name $usbblaster_name -device_name $test_device
}


# Close device.  Just used if communication error occurs
proc closeport { } {
	catch {device_unlock}
	catch {close_device}
}


# Retrieve device id code.
# IDCODE instruction value is 6; The ID code is 32 bits long.
# IR and DR shift should be locked together to ensure that other applications 
# will not change the instruction register before the id code value is shifted
# out while the instruction register is still holding the IDCODE instruction.
#device_lock -timeout 10000
#device_ir_shift -ir_value 6 -no_captured_ir_value
#puts "IDCODE: 0x[device_dr_shift -length 32 -value_in_hex]"
#device_unlock


proc get_stamp {} {
openport   
device_lock -timeout 10000
    # Shift through DR.  Note that -dr_value is unimportant since we're not actually capturing the value inside the part, just seeing what shifts out
    device_virtual_ir_shift -instance_index 0 -ir_value 1
    set stamp [device_virtual_dr_shift -instance_index 0  -length 46 ]
    # Set IR back to 0, which is bypass mode
    device_virtual_ir_shift -instance_index 0 -ir_value 0

  
    closeport

    return $stamp
}

proc report_stamp {stamp} {
    set revision [string range $stamp 0 6]
    set subrevision [string range $stamp 7 10]
    set year [string range $stamp 11 17]
    set month [string range $stamp 18 21]
    set day [string range $stamp 22 26]		
    set hour [string range $stamp 27 31]
    set minute [string range $stamp 32 37]	
    set compile_num [string range $stamp 38 45]
    
    puts "revision = $revision"
    puts "subrevision = $subrevision"
    puts "year = $year"
    puts "month = $month"
    puts "day = $day"
    puts "hour = $hour"
    puts "minute = $minute"
    puts "iteration = $compile_num"
}



# Procedure for formatting the output and displaying it in the message box
proc update_msg {} {

    set stamp [get_stamp]

    set year [string range $stamp 11 17]
    set month [string range $stamp 18 21]
    set day [string range $stamp 22 26]		
    set hour [string range $stamp 27 31]
    set minute [string range $stamp 32 37]
    set compile_num [string range $stamp 38 45]

    array set m {
	0001 Jan 0010 Feb 0011 Mar
	0100 Apr 0101 May 0110 Jun
	0111 Jul 1000 Aug 1001 Sep
	1010 Oct 1011 Nov 1100 Dec
    }
    set month $m($month)
    set day [expr 0x[bin2hex $day ]]
    set year [expr 2000 + [expr 0x[bin2hex $year ]]]
    set hour [expr 0x[bin2hex $hour]]
    set minute  [expr 0x[bin2hex $minute]]
   
    set pof_date "$month $day, $year; $hour:$minute"
    set user_code [get_usercode]
    set compile_num "0x[bin2hex $compile_num]"
    
    return "POF created: \t$pof_date \nUSERCODE: \t0x$user_code \nCompile Number: \t$compile_num"

}


#procedure for querying 32-bit USERCODE that is part of the DR scan chain.
proc get_usercode {} {

    openport
    device_lock -timeout 10000
    #USER code is part of the JTAG DR chain  - >  Not Virtual (USER0/USER1) chain
    #IR value for USERCODE is 7;  USER CODE is 32 bits in length
    
    device_ir_shift -ir_value 7
   
    set return_val [device_dr_shift -length 32 -value_in_hex]
    closeport
    return $return_val

}
    

proc bin2hex bin {
    ## No sanity checking is done
    array set t {
	0000 0 0001 1 0010 2 0011 3 0100 4
	0101 5 0110 6 0111 7 1000 8 1001 9
	1010 a 1011 b 1100 c 1101 d 1110 e 1111 f
    }
    set diff [expr {4-[string length $bin]%4}]
    if {$diff != 4} {
        set bin [format %0${diff}d$bin 0]
    }
    regsub -all .... $bin {$t(&)} hex
    return [subst $hex]
#}


#set stamp [get_stamp]
#report_stamp $stamp
closeport
tkwait window .
