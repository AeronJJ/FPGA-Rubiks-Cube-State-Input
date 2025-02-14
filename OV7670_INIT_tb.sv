`timescale 1ns / 100ps
module OV7670_INIT_tb;

reg clk_800KHz;
wire clk_800KHz_30;
reg rst_n;
wire c_SDATA;
wire c_SCL;
wire init_done;

wire t_SDA;
reg r_SDA;
wire drive_SDA;

OV7670_INIT dut (
	clk_800KHz,
	clk_800KHz_30,
	rst_n,
	t_SDA,
	r_SDA,
	drive_SDA,
	c_SCL,
	
	init_done
);

always #5 clk_800KHz = ~clk_800KHz;
assign clk_800KHz_30 = clk_800KHz;

initial begin
	clk_800KHz = 1'b0;
	rst_n = 1'b0;
	r_SDA = 1'b0;
	#100;
	rst_n = 1'b1;
end

endmodule
