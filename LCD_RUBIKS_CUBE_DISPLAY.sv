module LCD_RUBIKS_CUBE_DISPLAY (
	MAX10_CLK1_50,
	
	o_cs,
	o_dcrs,
	o_sdi,
	o_sck,
	o_lcdrst,
	
	t_sdo,
	t_irq,
	t_sdi,
	t_sck,
	t_cs,
	
	switches,
	leds,
	rst_n
);

input MAX10_CLK1_50;

output o_cs;
output o_dcrs;
output o_sdi;
output o_sck;
output o_lcdrst;

input t_sdo;
input t_irq;
output t_sdi;
output t_sck;
output t_cs;

input [9:0] switches;
output reg [5:0] leds;

input rst_n;

dual_boot u0 (
	.clk_clk       (MAX10_CLK1_50),   // clk.clk
	.reset_reset_n (1'b1) 				 // reset.reset_n
);

STEP_CONVERSION convert (
	switches[9:5],
	switches[4:0],
	leds
);

wire clk_100MHz;
wire clk_1MHz;

pll	pll_inst (
	.inclk0 ( MAX10_CLK1_50 ),
	.c0 ( clk_100MHz ),
	.c1 ( clk_1MHz )
	);


reg[16:0] bufferIndex = 17'd0;
wire incBuffer;

reg[8:0] x = 9'b0; // Current pixel position
reg[7:0] y = 8'b0;

always_ff @ (posedge incBuffer) begin
	if (bufferIndex == 76799) begin
		bufferIndex <= 17'b0;
		x <= 9'b0;
		y <= 8'b0;
	end
	else begin
		bufferIndex <= bufferIndex + 1'b1;
		if (y == 239) begin
			y <= 8'b0;
			x <= x + 1'b1;
		end
		else begin
			y <= y + 1'b1;
		end
	end
end


// + ~400 logic units:
//assign bufferIndex = (bufferIndex + 1'b1) % 17'(320*240); // Max buffer of 320*240
//wire[8:0] x = 9'(bufferIndex / 240); // x and y calculations
//wire[7:0] y = 8'(bufferIndex % 240);


//wire[143:0] cube_state = 144'h9249246db6dbffffffb6db6d492492db6db6; // Solved State
wire[143:0] cube_state;
wire[15:0] currentPixel;
wire[15:0] currentPixel_cubestate;

RUBIKS_CUBE_STATE_LCD cube (
	cube_state,
	x,
	y,
	currentPixel_cubestate
);


/*
Red = 3'b100
Orange = 3'b101
Blue = 3'b010
Green = 3'b011
White = 3'b111
Yellow = 3'b110
Black = 3'b000
// Solved State = 144'h924924492492ffffff6db6dbdb6db6b6db6d 
*/

LCD_SPI_CONTROLLER_RUBIK lcd (
	clk_100MHz,
	
	currentPixel,
	incBuffer,
	
	o_cs,
	o_dcrs,
	o_sdi,
	o_sck,
	o_lcdrst
);

wire [11:0] x_data; // Touch coordinates
wire [11:0] y_data;
wire new_touch_input; // Pulses when touch detected and coordinates are ready for analysis

TOUCH_SPI_CONTROLLER touch (
	clk_1MHz,
	t_sdo,
	t_irq,
	t_cs,
	t_sdi,
	t_sck,
	x_data,
	y_data,
	new_touch_input,
	
	rst_n
);

//assign cube_state = (y_data > 450 && x_data > 450) ? 144'hE94D2556779A7FCAD4B9ACEE5BF57FD6475E : 144'h9249246db6dbffffffb6db6d492492db6db6;


reg active = 1'b0;
wire [15:0] currentPixel_calibration;

TOUCH_CALIBRATION calibration (
	clk_1MHz,
	active,
	x,
	y,
	x_data,
	y_data,
	currentPixel_calibration
);

//assign currentPixel = (y_data > 450 && x_data > 450) ? currentPixel_calibration : currentPixel_cubestate;
//assign currentPixel = 1'b1 ? currentPixel_calibration : currentPixel_cubestate;

reg colour_choice_active;
reg cube_state_active;
wire [15:0] currentPixel_colourChoice;
wire [2:0] new_colour;

COLOUR_CHOICE_LCD colour_choice (
	clk_1MHz,
	colour_choice_active,
	x,
	y,
	x_data,
	y_data,
	new_touch_input,
	currentPixel_colourChoice,
	new_colour
);

wire activate_colour_choice;

RUBIKS_CUBE_STATE_TOUCH state_touch (
	clk_1MHz,
	cube_state_active,
	x_data,
	y_data,
	new_touch_input,
	new_colour,
	cube_state,
	activate_colour_choice,
	MAX10_CLK1_50
);


// State machine to control which screen is being displayed, will be expanded in the future.
localparam s_IDLE = 2'b00;
localparam s_STATE_DISPLAY = 2'b01;
localparam s_COLOUR_CHOICE_DISPLAY = 2'b10;

reg [1:0] current_state;
reg [1:0] next_state;

initial current_state = s_IDLE;
initial next_state = s_IDLE;

assign currentPixel = cube_state_active ? currentPixel_cubestate : currentPixel_colourChoice;

always @ (posedge clk_1MHz) begin
	current_state <= next_state;
	case (current_state)
		s_IDLE: begin
			cube_state_active <= 1'b0;
			colour_choice_active <= 1'b0;
		end
		
		s_STATE_DISPLAY: begin
			cube_state_active <= 1'b1;
			colour_choice_active <= 1'b0;
		end
		
		s_COLOUR_CHOICE_DISPLAY: begin
			cube_state_active <= 1'b0;
			colour_choice_active <= 1'b1;
		end
	endcase
end

always @ (*) begin
	next_state = current_state;
	case (current_state)
		s_IDLE: begin
			next_state = s_STATE_DISPLAY;
		end
		
		s_STATE_DISPLAY: begin
			if (activate_colour_choice) begin
				next_state = s_COLOUR_CHOICE_DISPLAY;
			end
		end	
		
		s_COLOUR_CHOICE_DISPLAY: begin
			if (~activate_colour_choice) begin
				next_state = s_STATE_DISPLAY;
			end
		end
		
		default: begin
			next_state = s_IDLE;
		end
	endcase
end

endmodule

