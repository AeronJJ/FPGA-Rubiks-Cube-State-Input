module LETTER_GENERATOR import FONT_DEFINITION::*; #(parameter xpos = 0, ypos = 0, size = 1, logic [0:FONT_WIDTH-1] letter [0:FONT_HEIGHT-1] = FONT_A) (
	input [8:0] x,
	input [7:0] y,
	output active
);

assign active = ((x-xpos) >= 0 && (y-ypos) >= 0 && (x-xpos) < FONT_WIDTH*(1<<(size-1)) && (y-ypos) < FONT_HEIGHT*(1<<(size-1)) && letter[(y-ypos)>>(size-1)][(x-xpos)>>(size-1)]) ? 1'b1 : 1'b0;
//assign active = ((x-xpos) >= 0 && (y-ypos) >= 0 && (x-xpos) < 8 && (y-ypos) < 8 && letter[(y-ypos)][(x-xpos)]) ? 1'b1 : 1'b0;

endmodule
