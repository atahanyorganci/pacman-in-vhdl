
# Clock signal
set_property PACKAGE_PIN W5 [get_ports CLOCK]
set_property IOSTANDARD LVCMOS33 [get_ports CLOCK]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports CLOCK]

# Switches
set_property PACKAGE_PIN V17 [get_ports {RESET}]
set_property IOSTANDARD LVCMOS33 [get_ports {RESET}]

#VGA Connector
#Bank = 14, Pin name = ,					Sch name = VGA_R0
set_property PACKAGE_PIN G19 [get_ports {VGA_RED[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_RED[0]}]
#Bank = 14, Pin name = ,					Sch name = VGA_R1
set_property PACKAGE_PIN H19 [get_ports {VGA_RED[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_RED[1]}]
#Bank = 14, Pin name = ,					Sch name = VGA_R2
set_property PACKAGE_PIN J19 [get_ports {VGA_RED[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_RED[2]}]
#Bank = 14, Pin name = ,					Sch name = VGA_R3
set_property PACKAGE_PIN N19 [get_ports {VGA_RED[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_RED[3]}]
#Bank = 14, Pin name = ,					Sch name = VGA_B0
set_property PACKAGE_PIN N18 [get_ports {VGA_BLUE[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_BLUE[0]}]
#Bank = 14, Pin name = ,						Sch name = VGA_B1
set_property PACKAGE_PIN L18 [get_ports {VGA_BLUE[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_BLUE[1]}]
#Bank = 14, Pin name = ,					Sch name = VGA_B2
set_property PACKAGE_PIN K18 [get_ports {VGA_BLUE[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_BLUE[2]}]
#Bank = 14, Pin name = ,						Sch name = VGA_B3
set_property PACKAGE_PIN J18 [get_ports {VGA_BLUE[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_BLUE[3]}]
#Bank = 14, Pin name = ,					Sch name = VGA_G0
set_property PACKAGE_PIN J17 [get_ports {VGA_GREEN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_GREEN[0]}]
#Bank = 14, Pin name = ,				Sch name = VGA_G1
set_property PACKAGE_PIN H17 [get_ports {VGA_GREEN[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_GREEN[1]}]
#Bank = 14, Pin name = ,					Sch name = VGA_G2
set_property PACKAGE_PIN G17 [get_ports {VGA_GREEN[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_GREEN[2]}]
#Bank = 14, Pin name = ,				Sch name = VGA_G3
set_property PACKAGE_PIN D17 [get_ports {VGA_GREEN[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {VGA_GREEN[3]}]
#Bank = 14, Pin name = ,						Sch name = VGA_HS
set_property PACKAGE_PIN P19 [get_ports VGA_HS]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_HS]
#Bank = 14, Pin name = ,				Sch name = VGA_VS
set_property PACKAGE_PIN R19 [get_ports VGA_VS]
set_property IOSTANDARD LVCMOS33 [get_ports VGA_VS]

# SSD Digit Cathodes
set_property PACKAGE_PIN W7 [get_ports {CATHODE[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[0]}]
set_property PACKAGE_PIN W6 [get_ports {CATHODE[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[1]}]
set_property PACKAGE_PIN U8 [get_ports {CATHODE[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[2]}]
set_property PACKAGE_PIN V8 [get_ports {CATHODE[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[3]}]
set_property PACKAGE_PIN U5 [get_ports {CATHODE[4]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[4]}]
set_property PACKAGE_PIN V5 [get_ports {CATHODE[5]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[5]}]
set_property PACKAGE_PIN U7 [get_ports {CATHODE[6]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {CATHODE[6]}]
	
# Multiplexed anodes
set_property PACKAGE_PIN U2 [get_ports {ANODE[0]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {ANODE[0]}]
set_property PACKAGE_PIN U4 [get_ports {ANODE[1]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {ANODE[1]}]
set_property PACKAGE_PIN V4 [get_ports {ANODE[2]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {ANODE[2]}]
set_property PACKAGE_PIN W4 [get_ports {ANODE[3]}]
	set_property IOSTANDARD LVCMOS33 [get_ports {ANODE[3]}]

#Buttons
set_property PACKAGE_PIN T18 [get_ports UP]						
	set_property IOSTANDARD LVCMOS33 [get_ports UP]
set_property PACKAGE_PIN W19 [get_ports LEFT]						
	set_property IOSTANDARD LVCMOS33 [get_ports LEFT]
set_property PACKAGE_PIN T17 [get_ports RIGHT]						
	set_property IOSTANDARD LVCMOS33 [get_ports RIGHT]
set_property PACKAGE_PIN U17 [get_ports DOWN]						
	set_property IOSTANDARD LVCMOS33 [get_ports DOWN]