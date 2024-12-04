`timescale 10ns / 100 ps
module SQUARE_TOUCH_tb;

reg [11:0] x_touch;
reg [11:0] y_touch;
wire isTouched;

SQUARE_TOUCH #(.x_touch_corner(670), .y_touch_corner(895), .x_touch_length(73), .y_touch_length(98)) dut ( 
	x_touch,
	y_touch,
	isTouched
);

initial begin
	x_touch = 12'd700;
	y_touch = 12'd700;
	#10;
	x_touch = 12'd669;
	y_touch = 12'd894;
	#10;
	x_touch = 12'd700;
	y_touch = 12'd700;
	#10;
	
end

endmodule
