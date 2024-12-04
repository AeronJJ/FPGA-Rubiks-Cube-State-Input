module COLOUR_CHOICE_LCD (
	input clk,
	input active,
	input [8:0] x_pixel,
	input [7:0] y_pixel,
	input [11:0] x_touch,
	input [11:0] y_touch,
	input touch_input,
	output [15:0] currentPixel_colourChoice,
	output reg [2:0] colour
);

localparam sqSize = 100;
localparam sqBorder = 5;

localparam sq00_x = 5;
localparam sq00_y = 15;
localparam sq01_x = 110;
localparam sq01_y = 15;
localparam sq02_x = 215;
localparam sq02_y = 15;

localparam sq10_x = 5;
localparam sq10_y = 125;
localparam sq11_x = 110;
localparam sq11_y = 125;
localparam sq12_x = 215;
localparam sq12_y = 125;

localparam NUM_SQUARES = 6;

logic [NUM_SQUARES-1:0] isSqSet;
logic [NUM_SQUARES-1:0][2:0] sqCol;

SQUARE_STATE #(.x(sq00_x), .y(sq00_y), .length(sqSize), .border(sqBorder)) colour_sq0 (x_pixel, y_pixel, {3'b100}, isSqSet[0], sqCol[0]);
SQUARE_STATE #(.x(sq01_x), .y(sq01_y), .length(sqSize), .border(sqBorder)) colour_sq1 (x_pixel, y_pixel, {3'b101}, isSqSet[1], sqCol[1]);
SQUARE_STATE #(.x(sq02_x), .y(sq02_y), .length(sqSize), .border(sqBorder)) colour_sq2 (x_pixel, y_pixel, {3'b010}, isSqSet[2], sqCol[2]);
SQUARE_STATE #(.x(sq10_x), .y(sq10_y), .length(sqSize), .border(sqBorder)) colour_sq3 (x_pixel, y_pixel, {3'b011}, isSqSet[3], sqCol[3]);
SQUARE_STATE #(.x(sq11_x), .y(sq11_y), .length(sqSize), .border(sqBorder)) colour_sq4 (x_pixel, y_pixel, {3'b111}, isSqSet[4], sqCol[4]);
SQUARE_STATE #(.x(sq12_x), .y(sq12_y), .length(sqSize), .border(sqBorder)) colour_sq5 (x_pixel, y_pixel, {3'b110}, isSqSet[5], sqCol[5]);

logic[15:0] currentColour;
logic[2:0] colours;

logic[2:0] new_colour;
logic[5:0] sq_touched;

SQUARE_TOUCH #(.x_touch_corner(1923), .y_touch_corner(1808), .x_touch_length(568), .y_touch_length(748)) touch_sq00 (x_touch, y_touch, active, sq_touched[0]);
SQUARE_TOUCH #(.x_touch_corner(1326), .y_touch_corner(1808), .x_touch_length(568), .y_touch_length(748)) touch_sq01 (x_touch, y_touch, active, sq_touched[1]);
SQUARE_TOUCH #(.x_touch_corner(730),  .y_touch_corner(1808), .x_touch_length(568), .y_touch_length(748)) touch_sq02 (x_touch, y_touch, active, sq_touched[2]);
SQUARE_TOUCH #(.x_touch_corner(1923), .y_touch_corner(985),  .x_touch_length(568), .y_touch_length(748)) touch_sq10 (x_touch, y_touch, active, sq_touched[3]);
SQUARE_TOUCH #(.x_touch_corner(1326), .y_touch_corner(985),  .x_touch_length(568), .y_touch_length(748)) touch_sq11 (x_touch, y_touch, active, sq_touched[4]);
SQUARE_TOUCH #(.x_touch_corner(730),  .y_touch_corner(985),  .x_touch_length(568), .y_touch_length(748)) touch_sq12 (x_touch, y_touch, active, sq_touched[5]);

always_comb begin
	currentColour = 16'b0;
	colours = 3'b0;
	for (int i = 0; i < NUM_SQUARES; i = i + 1) begin
		colours |= sqCol[i];
	end
	case (colours)
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
			currentColour = 16'hFC0A; // Orange
		end
		
		3'b111: begin
			currentColour = 16'hFFFF; // White
		end
		
		3'b110: begin
			currentColour = 16'hDC05; // Yellow
		end
		
		default: begin
			currentColour = 16'h0000; // Black
		end
	endcase
	
	case (sq_touched)
		6'h01: begin
			new_colour = 3'b100;
		end
			
		6'h02: begin
			new_colour = 3'b101;
		end
		
		6'h04: begin
			new_colour = 3'b010;
		end
		
		6'h08: begin
			new_colour = 3'b011;
		end
		
		6'h10: begin
			new_colour = 3'b111;
		end
		
		6'h20: begin
			new_colour = 3'b110;
		end
		
		default: begin
			new_colour = 3'b0;
		end
	endcase
end

assign currentPixel_colourChoice = (isSqSet ? currentColour : 16'hFFFF);

//assign colour = (active && touch_input) ? new_colour : 3'b0;
//assign colour = new_colour;

localparam s_IDLE = 3'b000;
localparam s_WAIT = 3'b001;
localparam s_GETCOLOUR = 3'b010;
localparam s_DONE = 3'b011;

reg [2:0] current_state;
reg [2:0] next_state;

reg [23:0] delay_left = 24'b0;
localparam CLK_FREQ_MHz = 1;

always @ (posedge clk) begin
	current_state <= next_state;
	if (delay_left > 24'b0) begin
		delay_left <= delay_left - 1'b1; // Wait for delay to count down
	end
	else begin
		case (current_state)
			s_IDLE: begin
				colour <= 3'b0;
			end
			
			s_WAIT: begin
				delay_left <= 24'(CLK_FREQ_MHz*15000); // Approx 150ms
			end
			
			s_GETCOLOUR: begin
				if (touch_input) begin
					colour <= new_colour;
				end
			end	
			
			s_DONE: begin
				
			end
		
		endcase
	end
end

always @ (*) begin
	next_state = current_state;
	case (current_state)
		s_IDLE: begin
			if (active) begin
				next_state = s_WAIT;
			end
		end
		
		s_WAIT: begin
			next_state = s_GETCOLOUR;
		end
		
		s_GETCOLOUR: begin
			if (colour != 3'b0) begin
				next_state = s_DONE;
			end
		end	
		
		s_DONE: begin
			if (~active) begin
				next_state = s_IDLE;
			end
		end
		
		default: begin
			next_state = s_IDLE;
		end
	
	endcase
end

endmodule
