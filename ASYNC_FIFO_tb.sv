`timescale 1ns / 100ps
module ASYNC_FIFO_tb;

reg [15:0] w_data;
reg w_en;
wire [15:0] r_data;
reg r_en;
wire d_available;

ASYNC_FIFO dut (
	w_data,
	w_en,
	r_data,
	r_en,
	d_available
);

initial begin
	w_data = 16'h4224;
	w_en = 1'b0;
	r_en = 1'b0;
	#10;
	w_en = 1'b1;
	#10;
	w_en = 1'b0;
	#10;
	r_en = 1'b1;
	#10;
	r_en = 1'b0;

end

endmodule
