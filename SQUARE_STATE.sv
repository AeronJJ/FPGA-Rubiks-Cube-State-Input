module SQUARE_STATE (
	input [8:0] isX, 
	input [7:0] isY,
	input [2:0] colourSet,
	output isSet, 
	output [2:0] colour
);

parameter x = 0;
parameter y = 0;
parameter length = 26;
parameter border = 3;

// If isX > x + length && isY > y + length then isSet = true
assign isSet = (isX > x) && (isX < (x + length)) && (isY > y) && (isY < (y + length));
assign colour = (isX < (x + border)) || (isX > (x + length - border)) || (isY < (y + border)) || (isY > (y + length - border)) ? 3'b000 : colourSet;

endmodule
