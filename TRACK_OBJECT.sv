module TRACK_OBJECT (
	input en,
	input [8:0] x,
	input [7:0] y,
	input [8:0] x_pos,
	input [7:0] y_pos,
	output [15:0] pixel,
	output square_active	
);

/* Instantiation Template
TRACK_OBJECT track (
	.en(),
	.x(),
	.y(),
	.x_pos(),
	.y_pos(),
	.pixel(),
	.square_active()	
);
*/

wire [2:0] sq_colour;
wire [2:0] pixel_colour;

assign sq_colour = en ? 3'b010 : 3'b100;

SQUARE_STATE_MOVABLE #(.length(5), .border(0)) sq (
	.isX(x), 
	.isY(y),
	.X_pos(x_pos),
	.Y_pos(y_pos),
	.colourSet(sq_colour),
	.isSet(square_active), 
	.colour(pixel_colour)
);

wire [15:0] currentColour;

assign pixel = square_active ? currentColour : 16'b0;

always_comb begin
	case (pixel_colour)
		3'b000: begin
			currentColour = 16'h0000; // Black
		end
		
		3'b010: begin
			currentColour = 16'h07E0; // Green
		end
		
		3'b011: begin
			currentColour = 16'h001F; // Blue
		end
		
		3'b100: begin
			currentColour = 16'hF800; // Red
		end
		
		3'b101: begin
			currentColour = 16'hFD68; // Orange
		end
		
		3'b111: begin
			currentColour = 16'hFFFF; // White
		end
		
		3'b110: begin
			currentColour = 16'hFFC0; // Yellow
		end
		
		default: begin
			currentColour = 16'h0000; // Black
		end
	endcase
end

endmodule
