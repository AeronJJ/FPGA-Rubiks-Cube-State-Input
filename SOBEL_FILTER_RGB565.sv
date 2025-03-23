module SOBEL_FILTER_RGB565 (
	input clk,
	input [15:0] data [8:0],
	output [15:0] output_pixel
);
																																				
localparam logic signed [8:0] vert_kernel [8:0] =  '{ 9'd1,  9'd0,  9'b111111111,  // -1 in two’s complement
																		9'd2,  9'd0,  9'b111111110,  // -2 in two’s complement
																		9'd1,  9'd0,  9'b111111111   // -1 in two’s complement
																	 };
																		
																																				
localparam logic signed [8:0] horiz_kernel [8:0] = '{ 9'd1,  9'd2,  9'd1,
																		9'd0,  9'd0,  9'd0,
																		9'b111111111,  9'b111111110,  9'b111111111
																	 };

wire signed [8:0] grad_X_r;
wire signed [8:0] grad_X_g;
wire signed [8:0] grad_X_b;

wire signed [8:0] grad_Y_r;
wire signed [8:0] grad_Y_g;
wire signed [8:0] grad_Y_b;

wire [8:0] grad_r;
wire [8:0] grad_g;
wire [8:0] grad_b;

assign grad_r = ((grad_X_r < 0) ? -grad_X_r : grad_X_r) + ((grad_Y_r < 0) ? -grad_Y_r : grad_Y_r);
assign grad_g = ((grad_X_g < 0) ? -grad_X_g : grad_X_g) + ((grad_Y_g < 0) ? -grad_Y_g : grad_Y_g);
assign grad_b = ((grad_X_b < 0) ? -grad_X_b : grad_X_b) + ((grad_Y_b < 0) ? -grad_Y_b : grad_Y_b);

wire [15:0] internal_pixel;

localparam [8:0] high_threshold = 9'h040;
localparam [8:0] r_high_threshold = 9'h020;
localparam [8:0] g_high_threshold = 9'h040;
localparam [8:0] b_high_threshold = 9'h020;

assign internal_pixel = {grad_r[8:4], grad_g[8:3], grad_b[8:4]};

//assign output_pixel = internal_pixel;


assign output_pixel = (grad_r > r_high_threshold || grad_g > g_high_threshold || grad_b > b_high_threshold) ? 16'hFFFF : 16'h0000;

//assign output_pixel = corner_pixel;

//assign output_pixel = data[8];


//Convolution of Kernel with window:

assign grad_X_r = vert_kernel[8] * data[0][15:11] + 
						vert_kernel[7] * data[1][15:11] + 
						vert_kernel[6] * data[2][15:11] +
						                      
						vert_kernel[5] * data[3][15:11] + 
						vert_kernel[4] * data[4][15:11] + 
						vert_kernel[3] * data[5][15:11] + 
						                      
						vert_kernel[2] * data[6][15:11] + 
						vert_kernel[1] * data[7][15:11] + 
						vert_kernel[0] * data[8][15:11];
						
assign grad_X_g = vert_kernel[8] * data[0][10:5] + 
						vert_kernel[7] * data[1][10:5] + 
						vert_kernel[6] * data[2][10:5] +
						                      
						vert_kernel[5] * data[3][10:5] + 
						vert_kernel[4] * data[4][10:5] + 
						vert_kernel[3] * data[5][10:5] + 
						                      
						vert_kernel[2] * data[6][10:5] + 
						vert_kernel[1] * data[7][10:5] + 
						vert_kernel[0] * data[8][10:5];

assign grad_X_b = vert_kernel[8] * data[0][4:0] + 
						vert_kernel[7] * data[1][4:0] + 
						vert_kernel[6] * data[2][4:0] +
						                      
						vert_kernel[5] * data[3][4:0] + 
						vert_kernel[4] * data[4][4:0] + 
						vert_kernel[3] * data[5][4:0] + 
						                      
						vert_kernel[2] * data[6][4:0] + 
						vert_kernel[1] * data[7][4:0] + 
						vert_kernel[0] * data[8][4:0];
						
						
						
assign grad_Y_r = horiz_kernel[8] * data[0][15:11] + 
						horiz_kernel[7] * data[1][15:11] + 
						horiz_kernel[6] * data[2][15:11] +
						                      
						horiz_kernel[5] * data[3][15:11] + 
						horiz_kernel[4] * data[4][15:11] + 
						horiz_kernel[3] * data[5][15:11] + 
						                      
						horiz_kernel[2] * data[6][15:11] + 
						horiz_kernel[1] * data[7][15:11] + 
						horiz_kernel[0] * data[8][15:11];
						
assign grad_Y_g = horiz_kernel[8] * data[0][10:5] + 
						horiz_kernel[7] * data[1][10:5] + 
						horiz_kernel[6] * data[2][10:5] +
						                          
						horiz_kernel[5] * data[3][10:5] + 
						horiz_kernel[4] * data[4][10:5] + 
						horiz_kernel[3] * data[5][10:5] + 
						                          
						horiz_kernel[2] * data[6][10:5] + 
						horiz_kernel[1] * data[7][10:5] + 
						horiz_kernel[0] * data[8][10:5];
						
assign grad_Y_b = horiz_kernel[8] * data[0][4:0] + 
						horiz_kernel[7] * data[1][4:0] + 
						horiz_kernel[6] * data[2][4:0] +
						                          
						horiz_kernel[5] * data[3][4:0] + 
						horiz_kernel[4] * data[4][4:0] + 
						horiz_kernel[3] * data[5][4:0] + 
						                          
						horiz_kernel[2] * data[6][4:0] + 
						horiz_kernel[1] * data[7][4:0] + 
						horiz_kernel[0] * data[8][4:0];
						
localparam lcd_width = 320;

//(* ramstyle = "M20K" *) reg 

reg signed [8:0] grad_window_x_r [8:0];
reg signed [8:0] grad_window_x_g [8:0];
reg signed [8:0] grad_window_x_b [8:0];
reg signed [8:0] grad_window_y_r [8:0];
reg signed [8:0] grad_window_y_g [8:0];
reg signed [8:0] grad_window_y_b [8:0];
						
always_ff @ (posedge clk) begin
	grad_window_x_r[0] <= grad_window_x_r[1];
	grad_window_x_r[1] <= grad_window_x_r[2];
	grad_window_x_r[2] <= grad_window_x_r[3];
	grad_window_x_r[3] <= grad_window_x_r[4];
	grad_window_x_r[4] <= grad_window_x_r[5];
	grad_window_x_r[5] <= grad_window_x_r[6];
	grad_window_x_r[6] <= grad_window_x_r[7];
	grad_window_x_r[7] <= grad_window_x_r[8];
	grad_window_x_r[8] <= grad_X_r;
end

always_ff @ (posedge clk) begin
	grad_window_x_g[0] <= grad_window_x_g[1];
	grad_window_x_g[1] <= grad_window_x_g[2];
	grad_window_x_g[2] <= grad_window_x_g[3];
	grad_window_x_g[3] <= grad_window_x_g[4];
	grad_window_x_g[4] <= grad_window_x_g[5];
	grad_window_x_g[5] <= grad_window_x_g[6];
	grad_window_x_g[6] <= grad_window_x_g[7];
	grad_window_x_g[7] <= grad_window_x_g[8];
	grad_window_x_g[8] <= grad_X_g;
end

always_ff @ (posedge clk) begin
	grad_window_x_b[0] <= grad_window_x_b[1];
	grad_window_x_b[1] <= grad_window_x_b[2];
	grad_window_x_b[2] <= grad_window_x_b[3];
	grad_window_x_b[3] <= grad_window_x_b[4];
	grad_window_x_b[4] <= grad_window_x_b[5];
	grad_window_x_b[5] <= grad_window_x_b[6];
	grad_window_x_b[6] <= grad_window_x_b[7];
	grad_window_x_b[7] <= grad_window_x_b[8];
	grad_window_x_b[8] <= grad_X_b;
end

always_ff @ (posedge clk) begin
	grad_window_y_r[0] <= grad_window_y_r[1];
	grad_window_y_r[1] <= grad_window_y_r[2];
	grad_window_y_r[2] <= grad_window_y_r[3];
	grad_window_y_r[3] <= grad_window_y_r[4];
	grad_window_y_r[4] <= grad_window_y_r[5];
	grad_window_y_r[5] <= grad_window_y_r[6];
	grad_window_y_r[6] <= grad_window_y_r[7];
	grad_window_y_r[7] <= grad_window_y_r[8];
	grad_window_y_r[8] <= grad_Y_r;
end

always_ff @ (posedge clk) begin
	grad_window_y_g[0] <= grad_window_y_g[1];
	grad_window_y_g[1] <= grad_window_y_g[2];
	grad_window_y_g[2] <= grad_window_y_g[3];
	grad_window_y_g[3] <= grad_window_y_g[4];
	grad_window_y_g[4] <= grad_window_y_g[5];
	grad_window_y_g[5] <= grad_window_y_g[6];
	grad_window_y_g[6] <= grad_window_y_g[7];
	grad_window_y_g[7] <= grad_window_y_g[8];
	grad_window_y_g[8] <= grad_Y_g;
end

always_ff @ (posedge clk) begin
	grad_window_y_b[0] <= grad_window_y_b[1];
	grad_window_y_b[1] <= grad_window_y_b[2];
	grad_window_y_b[2] <= grad_window_y_b[3];
	grad_window_y_b[3] <= grad_window_y_b[4];
	grad_window_y_b[4] <= grad_window_y_b[5];
	grad_window_y_b[5] <= grad_window_y_b[6];
	grad_window_y_b[6] <= grad_window_y_b[7];
	grad_window_y_b[7] <= grad_window_y_b[8];
	grad_window_y_b[8] <= grad_Y_b;
end

wire [15:0] corner_pixel;
wire corner_detected;

HARRIS_CORNER_DETECTOR corner (
	grad_window_x_r,
	grad_window_x_g,
	grad_window_x_b,
	grad_window_y_r,
	grad_window_y_g,
	grad_window_y_b,
	corner_pixel,
	corner_detected
);

endmodule
