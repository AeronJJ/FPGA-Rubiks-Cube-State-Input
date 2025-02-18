`timescale 1ns/100ps
module SKID_BUFFER_tb;

reg clk = 1'b0;
reg rst;

reg w_valid;
reg [15:0] w_data;
reg w_ready;

wire r_valid;
wire [15:0] r_data;
wire r_ready;


SKID_BUFFER dut (
	clk,
	rst,
	
	w_valid,
	w_data,
	w_ready,
	
	r_valid, // If data is ready to read
	r_data,
	r_ready
);

always #5 clk = ~clk;

initial begin
	
end


endmodule
