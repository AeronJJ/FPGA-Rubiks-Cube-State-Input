//lpm_mult CBX_SINGLE_OUTPUT_FILE="ON" LPM_HINT="DEDICATED_MULTIPLIER_CIRCUITRY=NO,MAXIMIZE_SPEED=9" LPM_PIPELINE=0 LPM_REPRESENTATION="SIGNED" LPM_TYPE="LPM_MULT" LPM_WIDTHA=9 LPM_WIDTHB=9 LPM_WIDTHP=18 LPM_WIDTHS=1 clock dataa datab result
//VERSION_BEGIN 17.1 cbx_mgl 2017:10:25:18:08:29:SJ cbx_stratixii 2017:10:25:18:06:53:SJ cbx_util_mgl 2017:10:25:18:06:53:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 2017  Intel Corporation. All rights reserved.
//  Your use of Intel Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Intel Program License 
//  Subscription Agreement, the Intel Quartus Prime License Agreement,
//  the Intel FPGA IP License Agreement, or other applicable license
//  agreement, including, without limitation, that your use is for
//  the sole purpose of programming logic devices manufactured by
//  Intel and sold by Intel or its authorized distributors.  Please
//  refer to the applicable agreement for further details.



//synthesis_resources = lpm_mult 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  mgphm
	( 
	clock,
	dataa,
	datab,
	result) /* synthesis synthesis_clearbox=1 */;
	input   clock;
	input   [8:0]  dataa;
	input   [8:0]  datab;
	output   [17:0]  result;

	wire  [17:0]   wire_mgl_prim1_result;

	lpm_mult   mgl_prim1
	( 
	.clock(clock),
	.dataa(dataa),
	.datab(datab),
	.result(wire_mgl_prim1_result));
	defparam
		mgl_prim1.lpm_pipeline = 0,
		mgl_prim1.lpm_representation = "SIGNED",
		mgl_prim1.lpm_type = "LPM_MULT",
		mgl_prim1.lpm_widtha = 9,
		mgl_prim1.lpm_widthb = 9,
		mgl_prim1.lpm_widthp = 18,
		mgl_prim1.lpm_widths = 1,
		mgl_prim1.lpm_hint = "DEDICATED_MULTIPLIER_CIRCUITRY=NO,MAXIMIZE_SPEED=9";
	assign
		result = wire_mgl_prim1_result;
endmodule //mgphm
//VALID FILE
