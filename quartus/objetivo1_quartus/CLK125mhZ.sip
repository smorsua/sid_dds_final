set_global_assignment -entity "CLK125mhZ" -library "lib_CLK125mhZ" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "CLK125mhZ" -library "lib_CLK125mhZ" -name IP_TOOL_VERSION "17.1"
set_global_assignment -entity "CLK125mhZ" -library "lib_CLK125mhZ" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_CLK125mhZ" -name SPD_FILE [file join $::quartus(sip_path) "CLK125mhZ.spd"]

set_global_assignment -library "lib_CLK125mhZ" -name MISC_FILE [file join $::quartus(sip_path) "CLK125mhZ_sim/CLK125mhZ.vo"]
