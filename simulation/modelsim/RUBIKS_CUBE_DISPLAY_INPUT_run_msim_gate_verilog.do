transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {RUBIKS_CUBE_DISPLAY_INPUT.vo}

vlog -sv -work work +incdir+C:/Users/Aeron/Documents/University/ELEC3885/Github/FPGA-Rubiks-Cube-State-Input {C:/Users/Aeron/Documents/University/ELEC3885/Github/FPGA-Rubiks-Cube-State-Input/SOBEL_FILTER_RGB565_tb.sv}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L gate_work -L work -voptargs="+acc"  SOBEL_FILTER_RGB565_tb

add wave *
view structure
view signals
run -all
