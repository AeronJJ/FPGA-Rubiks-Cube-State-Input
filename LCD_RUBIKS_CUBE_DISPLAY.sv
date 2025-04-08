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
	rst_n,
	
	c_SCL,
	c_SDATA,
	c_VSYNC_noisy,
	c_HREF,
	c_PCLK,
	c_XCLK,
	c_DOUT,
	c_RST,
	c_PWRN
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

output c_SCL;
inout wire c_SDATA;
input c_VSYNC_noisy;
input c_HREF;
input c_PCLK;
output c_XCLK;
input [7:0] c_DOUT;
output c_RST;
output c_PWRN;

dual_boot u0 (
	.clk_clk       (MAX10_CLK1_50),   // clk.clk
	.reset_reset_n (1'b1) 				 // reset.reset_n
);

STEP_CONVERSION convert (
	switches[9:5],
	switches[4:0],
	leds
);

// Clock Assignments

wire clk_100MHz;
wire clk_1MHz;
wire clk_800KHz;
wire clk_800KHz_30;
wire clk_25MHz;
//wire clk_13MHz;
//wire clk_200MHz;

/*pll	pll_inst (
	.inclk0 ( MAX10_CLK1_50 ),
	.c0 ( clk_100MHz ),
	.c1 ( clk_1MHz )
	);*/

pll	pll_inst (
	.inclk0 ( MAX10_CLK1_50 ),
	.c0 ( clk_100MHz ),
	.c1 ( clk_1MHz ),
	.c2 ( clk_800KHz ),
	.c3 ( clk_800KHz_30 ),
	//.c4 ( clk_200MHz )
	.c4 ( clk_25MHz )
	//.c4 ( c_XCLK )
	);

assign c_XCLK = MAX10_CLK1_50;
//assign clk_25MHz = internal_xclk;
reg internal_xclk = 1'b0;

always @ (posedge MAX10_CLK1_50) begin
	internal_xclk = ~internal_xclk;
end

/*
assign clk_13MHz = internal_13clk;
reg internal_13clk = 1'b0;

always @ (posedge clk_25MHz) begin
	internal_13clk = ~internal_13clk;
end
*/

//


// Clean VSYNC:
wire c_VSYNC;
/*assign c_VSYNC = c_VSYNC_noisy;*/

SWITCH_DEBOUNCE #(.delay(6000)) vsync_debounce (
	MAX10_CLK1_50,
	c_VSYNC_noisy,
	c_VSYNC
);
//


// Camera - Net switch control
wire sw0_pos_edge_pulse;
wire sw0_neg_edge_pulse;
wire rst_lcd_mem_addr;

wire rst_corner;
assign rst_corner = sw0_neg_edge_pulse || (cam_active ? c_VSYNC : 1'b0);

DETECT_SWITCH_EDGE sw0_det ( 
	switches[0],
	MAX10_CLK1_50,
	
	sw0_pos_edge_pulse,
	sw0_neg_edge_pulse,
	rst_lcd_mem_addr
);
//



// Rubik's Cube Net pixel generator

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

//


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


// LCD interface

wire p_available;

wire [8:0] x;
wire [7:0] y;
wire incBuffer;
wire [16:0] bufferIndex;

assign p_available = cam_active ? d_available : 1'b1;

LCD_SPI_CONTROLLER_RUBIK lcd (
	clk_100MHz,
	
	currentPixel,
	incBuffer,
	
	o_cs,
	o_dcrs,
	o_sdi,
	o_sck,
	o_lcdrst,
	
	p_available,
	rst_corner,
	x,
	y,
	bufferIndex
);

//


// Touch panel interface

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

//


//assign cube_state = (y_data > 450 && x_data > 450) ? 144'hE94D2556779A7FCAD4B9ACEE5BF57FD6475E : 144'h9249246db6dbffffffb6db6d492492db6db6;


// Touch Screen Calibration (Not in use)

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

//



//assign currentPixel = (y_data > 450 && x_data > 450) ? currentPixel_calibration : currentPixel_cubestate;
//assign currentPixel = 1'b1 ? currentPixel_calibration : currentPixel_cubestate;

// Colour Choice pixel generator

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

//


// Rubik's Cube current state control

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

//


// State machine to control which screen is being displayed, will be expanded in the future.
// (Should be modularised)
localparam s_IDLE = 2'b00;
localparam s_STATE_DISPLAY = 2'b01;
localparam s_COLOUR_CHOICE_DISPLAY = 2'b10;
localparam s_CAM_VIEW = 2'b11;

(* syn_preserve = 1, syn_encoding = "none" *) reg [1:0] current_state;
reg [1:0] next_state;

initial current_state = s_IDLE;
initial next_state = s_IDLE;

reg cam_active = 1'b0;
wire [15:0] tempPixel;

assign currentPixel = cam_active ? r_data : tempPixel;
assign tempPixel = cube_state_active ? currentPixel_cubestate : currentPixel_colourChoice;

always @ (posedge clk_1MHz) begin
	current_state <= next_state;
	case (current_state)
		s_IDLE: begin
			cube_state_active <= 1'b0;
			colour_choice_active <= 1'b0;
			cam_active <= 1'b0;
		end
		
		s_STATE_DISPLAY: begin
			cube_state_active <= 1'b1;
			colour_choice_active <= 1'b0;
			cam_active <= 1'b0;
		end
		
		s_COLOUR_CHOICE_DISPLAY: begin
			cube_state_active <= 1'b0;
			colour_choice_active <= 1'b1;
			cam_active <= 1'b0;
		end
		
		s_CAM_VIEW: begin
			cube_state_active <= 1'b0;
			colour_choice_active <= 1'b0;
			cam_active <= 1'b1;
		end
		
	endcase
end


//always @ (*) begin
always_comb begin
	next_state = current_state;
	case (current_state)
		s_IDLE: begin
			next_state = s_STATE_DISPLAY;
		end
		
		s_STATE_DISPLAY: begin
			if (switches[0]) begin
				next_state = s_CAM_VIEW;
			end
			else if (activate_colour_choice) begin
				next_state = s_COLOUR_CHOICE_DISPLAY;
			end
		end	
		
		s_COLOUR_CHOICE_DISPLAY: begin
			if (~activate_colour_choice) begin
				next_state = s_STATE_DISPLAY;
			end
		end
		
		s_CAM_VIEW: begin
			if (~switches[0]) begin
				next_state = s_STATE_DISPLAY;
			end
		end
		
		
		default: begin
			next_state = s_IDLE;
		end
	endcase
end

//


// Camera interface and frame buffer

wire [15:0] w_data;
wire w_en;
wire [15:0] r_data;
wire r_en;
wire d_available;


/*ASYNC_FIFO fifo (
	MAX10_CLK1_50,
	w_data,
	w_en,
	r_data,
	incBuffer,
	d_available
);*/

/*
ASYNC_FIFO_FULL_FRAME fifo ( // frame buffer not a fifo
	MAX10_CLK1_50,
	w_data,
	w_en,
	cam_bufferIndex,
	r_data,
	incBuffer,
	x,
	y,
	bufferIndex,
	d_available,
	c_VSYNC
);*/


wire sw1;

SWITCH_DEBOUNCE sw1_debounce (
	MAX10_CLK1_50,
	switches[1],
	sw1
);

ASYNC_FRAME_BUFFER_CORNER_DETECTION frame_buffer (
	MAX10_CLK1_50,
	w_data,
	w_en,
	cam_bufferIndex,
	r_data,
	incBuffer,
	x,
	y,
	bufferIndex,
	d_available,
	c_VSYNC,
	sw1
);

wire [16:0] cam_bufferIndex;
wire c_XCLK_null;

OV7670_Cam cam (
	clk_800KHz,
	clk_800KHz_30,
	clk_25MHz,
	//clk_13MHz,
	
	c_SCL,
	c_SDATA,
	c_VSYNC,
	c_HREF,
	c_PCLK,
	c_XCLK_null,
	c_DOUT,
	c_RST,
	c_PWRN,
	
	rst_n,
	
	d_available,
	w_data,
	w_en,
	cam_bufferIndex
);

//

endmodule

