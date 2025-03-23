module SOBEL_FILTER_RGB565_V2 (
	input [15:0] data [8:0],
	output signed [8:0] grad_X_r,
	output signed [8:0] grad_X_g,
	output signed [8:0] grad_X_b,

	output signed [8:0] grad_Y_r,
	output signed [8:0] grad_Y_g,
	output signed [8:0] grad_Y_b
);

localparam logic signed [8:0] vert_kernel [8:0] =  '{ 9'd1,  9'd0,  9'b111111111,  // -1 in two’s complement
																		9'd2,  9'd0,  9'b111111110,  // -2 in two’s complement
																		9'd1,  9'd0,  9'b111111111   // -1 in two’s complement
																	 };
																		
																																				
localparam logic signed [8:0] horiz_kernel [8:0] = '{ 9'd1,  9'd2,  9'd1,
																		9'd0,  9'd0,  9'd0,
																		9'b111111111,  9'b111111110,  9'b111111111
																	 };

//Convolution of Kernel with window:

assign grad_X_r = //vert_kernel[8] * '{4'b0, data[0][15:11]} + 
						vert_kernel[8] * data[0][15:11] + 
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

endmodule
