module HARRIS_CORNER_DETECTOR (
	input signed [8:0] I_x_r [8:0],
	input signed [8:0] I_x_g [8:0],
	input signed [8:0] I_x_b [8:0],
	input signed [8:0] I_y_r [8:0],
	input signed [8:0] I_y_g [8:0],
	input signed [8:0] I_y_b [8:0],
	output [15:0] pixel,
	output isCorner
);

localparam threshold = 25'h0FFFFFF;

wire signed [20:0] I_x_r_squared_sum;
wire signed [20:0] I_x_g_squared_sum;
wire signed [20:0] I_x_b_squared_sum;

assign I_x_r_squared_sum = I_x_r[0]*I_x_r[0] +
									I_x_r[1]*I_x_r[1] +
									I_x_r[2]*I_x_r[2] +
									I_x_r[3]*I_x_r[3] +
									I_x_r[4]*I_x_r[4] +
									I_x_r[5]*I_x_r[5] +
									I_x_r[6]*I_x_r[6] +
									I_x_r[7]*I_x_r[7] +
									I_x_r[8]*I_x_r[8];
									
assign I_x_g_squared_sum = I_x_g[0]*I_x_g[0] +
									I_x_g[1]*I_x_g[1] +
									I_x_g[2]*I_x_g[2] +
									I_x_g[3]*I_x_g[3] +
									I_x_g[4]*I_x_g[4] +
									I_x_g[5]*I_x_g[5] +
									I_x_g[6]*I_x_g[6] +
									I_x_g[7]*I_x_g[7] +
									I_x_g[8]*I_x_g[8];
									
assign I_x_b_squared_sum = I_x_b[0]*I_x_b[0] +
									I_x_b[1]*I_x_b[1] +
									I_x_b[2]*I_x_b[2] +
									I_x_b[3]*I_x_b[3] +
									I_x_b[4]*I_x_b[4] +
									I_x_b[5]*I_x_b[5] +
									I_x_b[6]*I_x_b[6] +
									I_x_b[7]*I_x_b[7] +
									I_x_b[8]*I_x_b[8];

wire signed [20:0] I_y_r_squared_sum;
wire signed [20:0] I_y_g_squared_sum;
wire signed [20:0] I_y_b_squared_sum;
									
assign I_y_r_squared_sum = I_y_r[0]*I_y_r[0] +
									I_y_r[1]*I_y_r[1] +
									I_y_r[2]*I_y_r[2] +
									I_y_r[3]*I_y_r[3] +
									I_y_r[4]*I_y_r[4] +
									I_y_r[5]*I_y_r[5] +
									I_y_r[6]*I_y_r[6] +
									I_y_r[7]*I_y_r[7] +
									I_y_r[8]*I_y_r[8];
									
assign I_y_g_squared_sum = I_y_g[0]*I_y_g[0] +
									I_y_g[1]*I_y_g[1] +
									I_y_g[2]*I_y_g[2] +
									I_y_g[3]*I_y_g[3] +
									I_y_g[4]*I_y_g[4] +
									I_y_g[5]*I_y_g[5] +
									I_y_g[6]*I_y_g[6] +
									I_y_g[7]*I_y_g[7] +
									I_y_g[8]*I_y_g[8];
									
assign I_y_b_squared_sum = I_y_b[0]*I_y_b[0] +
									I_y_b[1]*I_y_b[1] +
									I_y_b[2]*I_y_b[2] +
									I_y_b[3]*I_y_b[3] +
									I_y_b[4]*I_y_b[4] +
									I_y_b[5]*I_y_b[5] +
									I_y_b[6]*I_y_b[6] +
									I_y_b[7]*I_y_b[7] +
									I_y_b[8]*I_y_b[8];

wire signed [20:0] I_x_r_I_y_r_sum;
wire signed [20:0] I_x_g_I_y_g_sum;
wire signed [20:0] I_x_b_I_y_b_sum;
									
assign I_x_r_I_y_r_sum =   I_x_r[0]*I_y_r[0] +
									I_x_r[1]*I_y_r[1] +
									I_x_r[2]*I_y_r[2] +
									I_x_r[3]*I_y_r[3] +
									I_x_r[4]*I_y_r[4] +
									I_x_r[5]*I_y_r[5] +
									I_x_r[6]*I_y_r[6] +
									I_x_r[7]*I_y_r[7] +
									I_x_r[8]*I_y_r[8];
									
assign I_x_g_I_y_g_sum =   I_x_g[0]*I_y_g[0] +
									I_x_g[1]*I_y_g[1] +
									I_x_g[2]*I_y_g[2] +
									I_x_g[3]*I_y_g[3] +
									I_x_g[4]*I_y_g[4] +
									I_x_g[5]*I_y_g[5] +
									I_x_g[6]*I_y_g[6] +
									I_x_g[7]*I_y_g[7] +
									I_x_g[8]*I_y_g[8];
									
assign I_x_b_I_y_b_sum =   I_x_b[0]*I_y_b[0] +
									I_x_b[1]*I_y_b[1] +
									I_x_b[2]*I_y_b[2] +
									I_x_b[3]*I_y_b[3] +
									I_x_b[4]*I_y_b[4] +
									I_x_b[5]*I_y_b[5] +
									I_x_b[6]*I_y_b[6] +
									I_x_b[7]*I_y_b[7] +
									I_x_b[8]*I_y_b[8];

									
									
wire signed [23:0] det_I_r = I_x_r_squared_sum*I_y_r_squared_sum - I_x_r_I_y_r_sum*I_x_r_I_y_r_sum;
wire signed [23:0] det_I_g = I_x_g_squared_sum*I_y_g_squared_sum - I_x_g_I_y_g_sum*I_x_g_I_y_g_sum;
wire signed [23:0] det_I_b = I_x_b_squared_sum*I_y_b_squared_sum - I_x_b_I_y_b_sum*I_x_b_I_y_b_sum;

wire signed [24:0] R_r = det_I_r - ((I_x_r_squared_sum + I_y_r_squared_sum)*(I_x_r_squared_sum + I_y_r_squared_sum) >> 5);
wire signed [24:0] R_g = det_I_g - ((I_x_g_squared_sum + I_y_g_squared_sum)*(I_x_g_squared_sum + I_y_g_squared_sum) >> 5);
wire signed [24:0] R_b = det_I_b - ((I_x_b_squared_sum + I_y_b_squared_sum)*(I_x_b_squared_sum + I_y_b_squared_sum) >> 5);

wire internal_isCorner;

assign isCorner = internal_isCorner;

assign internal_isCorner = (R_r > threshold || R_g > threshold || R_b > threshold);
assign pixel = internal_isCorner ? 16'hFFFF : 16'h0000;
									
endmodule
