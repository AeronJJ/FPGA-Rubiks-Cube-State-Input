module TEXT_GENERATOR 
	import FONT_DEFINITION::*, MSP2807_COLOURS::*;
	#(parameter xpos = 0, ypos = 0, size = 1, colour = MSP_BLACK, length = 4, logic [0:FONT_WIDTH-1] text [0:length-1][0:FONT_HEIGHT-1] = '{FONT_T, FONT_e, FONT_s, FONT_t}) 
(
	input en,
	input [8:0] x_pixel,
	input [7:0] y_pixel,
	output [15:0] pixel,
	output active
);

assign pixel = active ? colour : 16'h0000;//16'hFFFF;

reg [length-1:0] internal_active;
assign active = |internal_active;

genvar i;
generate
	for (i=0; i < length; i = i+1) begin : letter_generator
		//LETTER_GENERATOR #(.xpos(xpos + (FONT_WIDTH<<(size-1))*i - (1<<(size))*i), .ypos(ypos), .size(size), .letter(text[i])) letter (
		LETTER_GENERATOR #(.xpos(xpos + (FONT_WIDTH<<(size-1))*i), .ypos(ypos), .size(size), .letter(text[i])) letter (
			x_pixel,
			y_pixel,
			internal_active[i]
		);
	end
endgenerate


endmodule
