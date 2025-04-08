module OV7670_Cam (
	//MAX10_CLK1_50,
	clk_800KHz,
	clk_800KHz_30,
	clk_25MHz,
	
	c_SCL,
	c_SDATA,
	c_VSYNC,
	c_HREF,
	c_PCLK,
	c_XCLK,
	c_DOUT,
	c_RST,
	c_PWRN,
	
	rst_n,
	
	d_available,
	w_data,
	w_en,
	bufferIndex
);

// IO Setup
input clk_800KHz;
input clk_800KHz_30;
input clk_25MHz;

output c_SCL;
inout c_SDATA;
input c_VSYNC;
input c_HREF;
input c_PCLK;
output c_XCLK;
input [7:0] c_DOUT;

output reg c_RST;
output reg c_PWRN;


input rst_n;

input d_available;
output reg [15:0] w_data; // UNCOMMENT THIS
//output [15:0] w_data;
output reg w_en;
//output w_en_out;
//reg w_en;

//assign w_en_out = c_PCLK ? w_en : 1'b0;

output reg [16:0] bufferIndex;
//


// SDA Setup
wire r_SDA;
wire t_SDA;
wire drive_SDA;

assign c_SDATA = drive_SDA ? t_SDA : 1'bz;
assign r_SDA = c_SDATA;
//


// Clock setup
//wire clk_100MHz;
//wire clk_800KHz;
//wire clk_800KHz_30;
//wire clk_25MHz;

/*
pll	pll_inst (
	.inclk0 ( MAX10_CLK1_50 ),
	.c0 ( clk_100MHz ),
	.c1 ( clk_800KHz ),
	.c2 ( clk_800KHz_30 ),
	.c3 ( c_XCLK )
	);
*/
	
assign c_XCLK = clk_25MHz;
//


// Camera Init Setup
wire cam_init_done;
reg cam_rst_n;

OV7670_INIT cam_init (
	clk_800KHz,
	clk_800KHz_30,
	cam_rst_n,
	t_SDA,
	r_SDA,
	drive_SDA,
	c_SCL,
	
	cam_init_done
);
//

assign c_PWRN = 1'b0;

reg capture_data = 1'b0;

// State Machine Setup
localparam s_IDLE = 3'b000;
localparam s_INIT_START = 3'b001;
localparam s_CAM_INIT = 3'b010;
localparam s_DELAY = 3'b011;
localparam s_CAM_PIXEL_TRANSFER = 3'b100;

reg [2:0] current_state = s_IDLE;
reg [2:0] next_state = s_IDLE;
reg [23:0] delay_left = 24'b0;
//

always @ (posedge clk_800KHz or negedge rst_n) begin
	if (~rst_n) begin
		cam_rst_n <= 1'b1;
		current_state <= s_IDLE;
		capture_data <= 1'b0;
	end
	else if (delay_left > 24'b0) begin
		delay_left <= delay_left - 1'b1; // Wait for delay to count down
	end
	else begin
		current_state <= next_state;
		case (current_state)
			s_IDLE: begin
				cam_rst_n <= 1'b1;
				c_RST <= 1'b0;
				capture_data <= 1'b0;
			end
			
			s_INIT_START: begin
				cam_rst_n <= 1'b0;
				c_RST <= 1'b1;
				delay_left <= 24'd1600; // Wait ~2ms
			end
			
			s_CAM_INIT: begin
				cam_rst_n <= 1'b1;
			end
			
			s_DELAY: begin
				delay_left <= 24'd800000; // Wait 1 second for no particular reason
				//c_RST <= 1'b1;
			end
			
			s_CAM_PIXEL_TRANSFER: begin
				capture_data <= 1'b1;
			end
		endcase
	end
end

always @ (*) begin
	next_state = current_state;
	case (current_state)
		s_IDLE: begin
			next_state = s_INIT_START;
		end
		
		s_INIT_START: begin
			next_state = s_CAM_INIT;
		end
		
		s_CAM_INIT: begin
			if (cam_init_done) begin
				next_state = s_DELAY;
			end
		end
		
		s_DELAY: begin
			next_state = s_CAM_PIXEL_TRANSFER;
		end
		
		s_CAM_PIXEL_TRANSFER: begin
			next_state = s_CAM_PIXEL_TRANSFER;
		end
	endcase
end

reg [1:0] line_index = 2'b0;
reg [9:0] pixel_index = 10'b0;
localparam width = 640;
localparam height = 480;
//logic [15:0] line_1 [width-1:0];
//logic [15:0] line_2 [width-1:0];
//logic [15:0] line_3 [width-1:0];

logic first_byte = 1'b1;

logic [15:0] next_pixel = 16'b0;
logic [7:0] prev_byte = 8'b0;

/*
always @ (posedge c_PCLK) begin
	w_en = 1'b0;
	if (pixel_index == width) begin
		pixel_index = 10'b0;
		first_byte = 1'b1;
	end
	else if (capture_data && c_HREF) begin
		if (first_byte) begin
			if (line_index == 2'd0) begin
				//line_1[pixel_index][15:8] = c_DOUT;
				prev_byte = c_DOUT;
			end
			else if (line_index == 2'd1) begin
				//line_2[pixel_index][15:8] = c_DOUT;
				prev_byte = c_DOUT;
			end
			else if (line_index == 2'd2) begin
				//line_3[pixel_index][15:8] = c_DOUT;
				prev_byte = c_DOUT;
			end
		end
		else begin
			if (line_index == 2'd0) begin
				//line_1[pixel_index][7:0] = c_DOUT;
				//next_pixel = {line_1[pixel_index][15:8], c_DOUT};
				next_pixel = {prev_byte, c_DOUT};
			end
			else if (line_index == 2'd1) begin
				//line_2[pixel_index][7:0] = c_DOUT;
				//next_pixel = {line_2[pixel_index][15:8], c_DOUT};
				next_pixel = {prev_byte, c_DOUT};
			end
			else if (line_index == 2'd2) begin
				//line_3[pixel_index][7:0] = c_DOUT;
				//next_pixel = {line_3[pixel_index][15:8], c_DOUT};
				next_pixel = {prev_byte, c_DOUT};
			end
		end
		first_byte = ~first_byte;
		pixel_index = pixel_index + 1'b1;
		
		if (~d_available && first_byte) begin
			w_en = 1'b1;
			w_data = next_pixel;
		end
	end
end

always @ (posedge c_HREF) begin
	// Start new line
	if (line_index == 2'd2) begin
		line_index = 2'd0;
	end
	else begin
		line_index = line_index + 2'd1;
	end
end

*/

reg [1:0] skip_pixel = 2'b00; // skip_pixel[1] is the relevant signal
reg skip_row = 1'b0;

/*always @ (negedge c_HREF or posedge c_VSYNC) begin
	if (c_VSYNC) begin
		skip_row = 1'b0;
	end
	else begin
		skip_row = ~skip_row;
	end
end*/

always @ (negedge c_HREF) begin
	skip_row = ~skip_row;
end

always @ (posedge c_PCLK or negedge c_HREF or posedge c_VSYNC) begin
	if (c_VSYNC) begin
		bufferIndex <= 17'b0;
	end
//always @ (posedge c_PCLK or negedge c_HREF) begin
	else if (~c_HREF) begin
		//first_byte = 1'b1;
		skip_pixel = 2'b01;
	end
	else if (bufferIndex == 17'd76800) begin
		bufferIndex <= 17'b0;
	end
	else begin
		w_en = 1'b0;
		skip_pixel = skip_pixel + 1'b1;
		
		if (~skip_pixel[1] && ~skip_row) begin
			if (capture_data && c_HREF) begin
				if (first_byte) begin
					prev_byte = c_DOUT;
				end
				else begin
					next_pixel = {prev_byte, c_DOUT};
					bufferIndex <= bufferIndex + 1'b1;
				end
				pixel_index = pixel_index + 1'b1;
				
				if (first_byte) begin
					w_en = 1'b1;
					w_data = next_pixel;
				end
			end
		end
	end
end

always_ff @ (posedge c_PCLK or negedge c_HREF) begin
	if (~c_HREF) begin // Reset condition
		first_byte = 1'b1;
	end
	else if (c_PCLK) begin
		first_byte = ~first_byte;
	end
end

always @ (posedge c_HREF) begin
	// Start new line
	if (line_index == 2'd2) begin
		line_index = 2'd0;
	end
	else begin
		line_index = line_index + 2'd1;
	end
end

endmodule
