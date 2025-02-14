transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Aeron/Documents/University/ELEC3885/Github/FPGA-Rubiks-Cube-State-Input {C:/Users/Aeron/Documents/University/ELEC3885/Github/FPGA-Rubiks-Cube-State-Input/ASYNC_FIFO.sv}
vlog -sv -work work +incdir+C:/Users/Aeron/Documents/University/ELEC3885/Github/FPGA-Rubiks-Cube-State-Input {C:/Users/Aeron/Documents/University/ELEC3885/Github/FPGA-Rubiks-Cube-State-Input/ASYNC_FIFO_tb.sv}

vlog -sv -work work +incdir+C:/Users/Aeron/Documents/University/ELEC3885/Github/FPGA-Rubiks-Cube-State-Input {C:/Users/Aeron/Documents/University/ELEC3885/Github/FPGA-Rubiks-Cube-State-Input/ASYNC_FIFO_tb.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  ASYNC_FIFO_tb

add wave *
view structure
view signals
run -all
