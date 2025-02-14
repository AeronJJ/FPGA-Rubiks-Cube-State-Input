`timescale 1ns / 100ps
module OV7670_SCCB_tb;

reg clk_800KHz; // 800 KHz maximum
wire o_SDC_400KHz;	// 400 KHz maximum

reg [7:0] data_in;
reg [7:0] addr_in;
reg en;
wire ready;
wire busy;
wire ack;

wire t_SDA;
reg r_SDA;
wire drive_SDA;

OV7670_SCCB dut (
	clk_800KHz, // 800 KHz maximum
	t_SDA,
	r_SDA,
	drive_SDA,
	o_SDC_400KHz,	// 400 KHz maximum
	
	addr_in,
	data_in,
	
	en,
	ready,
	busy,
	ack
);

always #5 clk_800KHz = ~clk_800KHz;

initial begin
	clk_800KHz = 1'b0;
	r_SDA = 1'b0;
	data_in = 8'hB3;
	addr_in = 8'h4F;
	en = 1'b0;
	#10;
	en = 1'b1;
	#50;
	en = 1'b0;
	#5000;
	en = 1'b1;
	#10000;
	en = 1'b0;
	
end

endmodule
