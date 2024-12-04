module RUBIKS_CUBE_STATE_TOUCH (
	input clk,
	input active,
	input [11:0] x_touch,
	input [11:0] y_touch,
	input touch_input,
	input [2:0] new_colour,
	output reg [143:0] cube_state,
	output reg activate_colour_choice,
	input clk_50MHz
);

logic[47:0] sq_touched;
logic[5:0] ignore_touch;

SQUARE_TOUCH  #(.x_touch_corner(1485), .y_touch_corner(1898), .x_touch_length(148), .y_touch_length(195)) touch_sq0 (x_touch, y_touch,  active, sq_touched[0]);
SQUARE_TOUCH  #(.x_touch_corner(1338), .y_touch_corner(1898), .x_touch_length(148), .y_touch_length(195)) touch_sq1 (x_touch, y_touch,  active, sq_touched[1]);
SQUARE_TOUCH  #(.x_touch_corner(1190), .y_touch_corner(1898), .x_touch_length(148), .y_touch_length(195)) touch_sq2 (x_touch, y_touch,  active, sq_touched[2]);
SQUARE_TOUCH  #(.x_touch_corner(1485), .y_touch_corner(1703), .x_touch_length(148), .y_touch_length(195)) touch_sq3 (x_touch, y_touch,  active, sq_touched[3]);
SQUARE_TOUCH  #(.x_touch_corner(1338), .y_touch_corner(1703), .x_touch_length(148), .y_touch_length(195)) touch_sq4 (x_touch, y_touch,  active, ignore_touch[0]);
SQUARE_TOUCH  #(.x_touch_corner(1190), .y_touch_corner(1703), .x_touch_length(148), .y_touch_length(195)) touch_sq5 (x_touch, y_touch,  active, sq_touched[4]);
SQUARE_TOUCH  #(.x_touch_corner(1485), .y_touch_corner(1509), .x_touch_length(148), .y_touch_length(195)) touch_sq6 (x_touch, y_touch,  active, sq_touched[5]);
SQUARE_TOUCH  #(.x_touch_corner(1338), .y_touch_corner(1509), .x_touch_length(148), .y_touch_length(195)) touch_sq7 (x_touch, y_touch,  active, sq_touched[6]);
SQUARE_TOUCH  #(.x_touch_corner(1190), .y_touch_corner(1509), .x_touch_length(148), .y_touch_length(195)) touch_sq8 (x_touch, y_touch,  active, sq_touched[7]);

SQUARE_TOUCH  #(.x_touch_corner(1928), .y_touch_corner(1314), .x_touch_length(148), .y_touch_length(195)) touch_sq9 (x_touch, y_touch,  active, sq_touched[32]);
SQUARE_TOUCH  #(.x_touch_corner(1781), .y_touch_corner(1314), .x_touch_length(148), .y_touch_length(195)) touch_sq10 (x_touch, y_touch, active, sq_touched[33]);
SQUARE_TOUCH  #(.x_touch_corner(1633), .y_touch_corner(1314), .x_touch_length(148), .y_touch_length(195)) touch_sq11 (x_touch, y_touch, active, sq_touched[34]);
SQUARE_TOUCH  #(.x_touch_corner(1485), .y_touch_corner(1314), .x_touch_length(148), .y_touch_length(195)) touch_sq12 (x_touch, y_touch, active, sq_touched[16]);
SQUARE_TOUCH  #(.x_touch_corner(1338), .y_touch_corner(1314), .x_touch_length(148), .y_touch_length(195)) touch_sq13 (x_touch, y_touch, active, sq_touched[17]);
SQUARE_TOUCH  #(.x_touch_corner(1190), .y_touch_corner(1314), .x_touch_length(148), .y_touch_length(195)) touch_sq14 (x_touch, y_touch, active, sq_touched[18]);
SQUARE_TOUCH  #(.x_touch_corner(1042), .y_touch_corner(1314), .x_touch_length(148), .y_touch_length(195)) touch_sq15 (x_touch, y_touch, active, sq_touched[8]);
SQUARE_TOUCH  #(.x_touch_corner(895),  .y_touch_corner(1314), .x_touch_length(148), .y_touch_length(195)) touch_sq16 (x_touch, y_touch, active, sq_touched[9]);
SQUARE_TOUCH  #(.x_touch_corner(747),  .y_touch_corner(1314), .x_touch_length(148), .y_touch_length(195)) touch_sq17 (x_touch, y_touch, active, sq_touched[10]);
SQUARE_TOUCH  #(.x_touch_corner(599),  .y_touch_corner(1314), .x_touch_length(148), .y_touch_length(195)) touch_sq18 (x_touch, y_touch, active, sq_touched[40]);
SQUARE_TOUCH  #(.x_touch_corner(451),  .y_touch_corner(1314), .x_touch_length(148), .y_touch_length(195)) touch_sq19 (x_touch, y_touch, active, sq_touched[41]);
SQUARE_TOUCH  #(.x_touch_corner(304),  .y_touch_corner(1314), .x_touch_length(148), .y_touch_length(195)) touch_sq20 (x_touch, y_touch, active, sq_touched[42]);
SQUARE_TOUCH  #(.x_touch_corner(1928), .y_touch_corner(1120), .x_touch_length(148), .y_touch_length(195)) touch_sq21 (x_touch, y_touch, active, sq_touched[35]);
SQUARE_TOUCH  #(.x_touch_corner(1781), .y_touch_corner(1120), .x_touch_length(148), .y_touch_length(195)) touch_sq22 (x_touch, y_touch, active, ignore_touch[1]);
SQUARE_TOUCH  #(.x_touch_corner(1633), .y_touch_corner(1120), .x_touch_length(148), .y_touch_length(195)) touch_sq23 (x_touch, y_touch, active, sq_touched[36]);
SQUARE_TOUCH  #(.x_touch_corner(1485), .y_touch_corner(1120), .x_touch_length(148), .y_touch_length(195)) touch_sq24 (x_touch, y_touch, active, sq_touched[19]);
SQUARE_TOUCH  #(.x_touch_corner(1338), .y_touch_corner(1120), .x_touch_length(148), .y_touch_length(195)) touch_sq25 (x_touch, y_touch, active, ignore_touch[2]);
SQUARE_TOUCH  #(.x_touch_corner(1190), .y_touch_corner(1120), .x_touch_length(148), .y_touch_length(195)) touch_sq26 (x_touch, y_touch, active, sq_touched[20]);
SQUARE_TOUCH  #(.x_touch_corner(1042), .y_touch_corner(1120), .x_touch_length(148), .y_touch_length(195)) touch_sq27 (x_touch, y_touch, active, sq_touched[11]);
SQUARE_TOUCH  #(.x_touch_corner(895),  .y_touch_corner(1120), .x_touch_length(148), .y_touch_length(195)) touch_sq28 (x_touch, y_touch, active, ignore_touch[3]);
SQUARE_TOUCH  #(.x_touch_corner(747),  .y_touch_corner(1120), .x_touch_length(148), .y_touch_length(195)) touch_sq29 (x_touch, y_touch, active, sq_touched[12]);
SQUARE_TOUCH  #(.x_touch_corner(599),  .y_touch_corner(1120), .x_touch_length(148), .y_touch_length(195)) touch_sq30 (x_touch, y_touch, active, sq_touched[43]);
SQUARE_TOUCH  #(.x_touch_corner(451),  .y_touch_corner(1120), .x_touch_length(148), .y_touch_length(195)) touch_sq31 (x_touch, y_touch, active, ignore_touch[4]);
SQUARE_TOUCH  #(.x_touch_corner(304),  .y_touch_corner(1120), .x_touch_length(148), .y_touch_length(195)) touch_sq32 (x_touch, y_touch, active, sq_touched[44]);
SQUARE_TOUCH  #(.x_touch_corner(1928), .y_touch_corner(925),  .x_touch_length(148), .y_touch_length(195)) touch_sq33 (x_touch, y_touch, active, sq_touched[37]);
SQUARE_TOUCH  #(.x_touch_corner(1781), .y_touch_corner(925),  .x_touch_length(148), .y_touch_length(195)) touch_sq34 (x_touch, y_touch, active, sq_touched[38]);
SQUARE_TOUCH  #(.x_touch_corner(1633), .y_touch_corner(925),  .x_touch_length(148), .y_touch_length(195)) touch_sq35 (x_touch, y_touch, active, sq_touched[39]);
SQUARE_TOUCH  #(.x_touch_corner(1485), .y_touch_corner(925),  .x_touch_length(148), .y_touch_length(195)) touch_sq36 (x_touch, y_touch, active, sq_touched[21]);
SQUARE_TOUCH  #(.x_touch_corner(1338), .y_touch_corner(925),  .x_touch_length(148), .y_touch_length(195)) touch_sq37 (x_touch, y_touch, active, sq_touched[22]);
SQUARE_TOUCH  #(.x_touch_corner(1190), .y_touch_corner(925),  .x_touch_length(148), .y_touch_length(195)) touch_sq38 (x_touch, y_touch, active, sq_touched[23]);
SQUARE_TOUCH  #(.x_touch_corner(1042), .y_touch_corner(925),  .x_touch_length(148), .y_touch_length(195)) touch_sq39 (x_touch, y_touch, active, sq_touched[13]);
SQUARE_TOUCH  #(.x_touch_corner(895),  .y_touch_corner(925),  .x_touch_length(148), .y_touch_length(195)) touch_sq40 (x_touch, y_touch, active, sq_touched[14]);
SQUARE_TOUCH  #(.x_touch_corner(747),  .y_touch_corner(925),  .x_touch_length(148), .y_touch_length(195)) touch_sq41 (x_touch, y_touch, active, sq_touched[15]);
SQUARE_TOUCH  #(.x_touch_corner(599),  .y_touch_corner(925),  .x_touch_length(148), .y_touch_length(195)) touch_sq42 (x_touch, y_touch, active, sq_touched[45]);
SQUARE_TOUCH  #(.x_touch_corner(451),  .y_touch_corner(925),  .x_touch_length(148), .y_touch_length(195)) touch_sq43 (x_touch, y_touch, active, sq_touched[46]);
SQUARE_TOUCH  #(.x_touch_corner(304),  .y_touch_corner(925),  .x_touch_length(148), .y_touch_length(195)) touch_sq44 (x_touch, y_touch, active, sq_touched[47]);

SQUARE_TOUCH  #(.x_touch_corner(1485), .y_touch_corner(731),  .x_touch_length(148), .y_touch_length(195)) touch_sq45 (x_touch, y_touch, active, sq_touched[24]);
SQUARE_TOUCH  #(.x_touch_corner(1338), .y_touch_corner(731),  .x_touch_length(148), .y_touch_length(195)) touch_sq46 (x_touch, y_touch, active, sq_touched[25]);
SQUARE_TOUCH  #(.x_touch_corner(1190), .y_touch_corner(731),  .x_touch_length(148), .y_touch_length(195)) touch_sq47 (x_touch, y_touch, active, sq_touched[26]);
SQUARE_TOUCH  #(.x_touch_corner(1485), .y_touch_corner(536),  .x_touch_length(148), .y_touch_length(195)) touch_sq48 (x_touch, y_touch, active, sq_touched[27]);
SQUARE_TOUCH  #(.x_touch_corner(1338), .y_touch_corner(536),  .x_touch_length(148), .y_touch_length(195)) touch_sq49 (x_touch, y_touch, active, ignore_touch[5]);
SQUARE_TOUCH  #(.x_touch_corner(1190), .y_touch_corner(536),  .x_touch_length(148), .y_touch_length(195)) touch_sq50 (x_touch, y_touch, active, sq_touched[28]);
SQUARE_TOUCH  #(.x_touch_corner(1485), .y_touch_corner(342),  .x_touch_length(148), .y_touch_length(195)) touch_sq51 (x_touch, y_touch, active, sq_touched[29]);
SQUARE_TOUCH  #(.x_touch_corner(1338), .y_touch_corner(342),  .x_touch_length(148), .y_touch_length(195)) touch_sq52 (x_touch, y_touch, active, sq_touched[30]);
SQUARE_TOUCH  #(.x_touch_corner(1190), .y_touch_corner(342),  .x_touch_length(148), .y_touch_length(195)) touch_sq53 (x_touch, y_touch, active, sq_touched[31]);

initial cube_state = 144'h9249246db6dbffffffb6db6d492492db6db6;

reg [143:0] updated_state;

reg [47:0] sq_touched_stored;

localparam s_IDLE = 3'b000;
localparam s_ACTIVE = 3'b001;
localparam s_STORE_TOUCH = 3'b010;
localparam s_WAIT_FOR_COLOUR = 3'b011;
localparam s_STORE_COLOUR = 3'b100;
localparam s_UPDATE_STATE = 3'b101;
localparam s_PUSH_STATE = 3'b110;

reg [2:0] current_state;
reg [2:0] next_state;
reg [2:0] next_colour_stored;

initial current_state = s_IDLE;
initial next_state = s_IDLE;

always @ (posedge clk) begin
	current_state <= next_state;
	case (current_state)
		s_IDLE: begin
			activate_colour_choice <= 1'b0;
			next_colour_stored <= 3'b0;
			updated_state <= 144'b0;
			sq_touched_stored <= 48'b0;
		end
		
		s_ACTIVE: begin
			activate_colour_choice <= 1'b0;
		end
		
		s_STORE_TOUCH: begin
			sq_touched_stored <= sq_touched;
		end
		
		s_WAIT_FOR_COLOUR: begin
			activate_colour_choice <= 1'b1;
		end
		
		s_STORE_COLOUR: begin
			activate_colour_choice <= 1'b1;
			next_colour_stored = new_colour;
		end
		
		s_UPDATE_STATE: begin
			activate_colour_choice <= 1'b0;
			// Iterate over each square (0 to 47)
			for (int i = 0; i < 48; i++) begin
				// Check if the square is touched
				if (sq_touched_stored[i]) begin
					 // If touched, update to new_colour
					 updated_state[(47-i)*3 +: 3] = next_colour_stored;
				end
				else begin
					 // If not touched, keep the current colour
					 updated_state[(47-i)*3 +: 3] = cube_state[(47-i)*3 +: 3];
				end
			end
		end
		
		s_PUSH_STATE: begin
			cube_state <= updated_state;
		end
	endcase
end

always @ (*) begin // State Control
	next_state = current_state;
	case (current_state)
		s_IDLE: begin
			if (active) begin
				next_state = s_ACTIVE;
			end
		end
		
		s_ACTIVE: begin
			if(sq_touched && touch_input) begin
				next_state = s_STORE_TOUCH;
			end
			else if (~active) begin
				next_state = s_IDLE;
			end
		end
		
		s_STORE_TOUCH: begin
			next_state = s_WAIT_FOR_COLOUR;
		end
		
		s_WAIT_FOR_COLOUR: begin
			next_state = s_STORE_COLOUR;
		end
		
		s_STORE_COLOUR: begin
			if (next_colour_stored != 3'b0) begin
				next_state = s_UPDATE_STATE;
			end
		end
		
		s_UPDATE_STATE: begin
			next_state = s_PUSH_STATE;
		end		
		
		s_PUSH_STATE: begin
			next_state = s_IDLE;
		end
		
		default: begin
			next_state = s_IDLE;
		end
	endcase
end

endmodule
