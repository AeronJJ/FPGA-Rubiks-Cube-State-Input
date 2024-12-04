module SQUARE_TOUCH ( 
	input [11:0] x_touch,
	input [11:0] y_touch,
	input active,
	output isTouched
);

parameter x_touch_corner = 0;
parameter y_touch_corner = 0;
parameter x_touch_length = 0;
parameter y_touch_length = 0;

assign isTouched = active ? (x_touch < x_touch_corner) && (x_touch > (x_touch_corner - x_touch_length)) && (y_touch < y_touch_corner) && (y_touch > (y_touch_corner - y_touch_length)) : 1'b0;

endmodule
