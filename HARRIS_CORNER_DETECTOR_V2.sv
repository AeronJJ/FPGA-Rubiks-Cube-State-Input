module HARRIS_CORNER_DETECTOR_V2 (
	input [15:0] window5x5 [24:0],
	output reg isCorner,
	output [15:0] pixel,
	input clk
);

// Get gradients of central 3x3 square:

wire signed [8:0] I_x_r [8:0];
wire signed [8:0] I_x_g [8:0];
wire signed [8:0] I_x_b [8:0];
wire signed [8:0] I_y_r [8:0];
wire signed [8:0] I_y_g [8:0];
wire signed [8:0] I_y_b [8:0];


wire [15:0] window3x3_0 [8:0];

assign window3x3_0[0] = window5x5[0];
assign window3x3_0[1] = window5x5[1];
assign window3x3_0[2] = window5x5[2];
assign window3x3_0[3] = window5x5[5];
assign window3x3_0[4] = window5x5[6];
assign window3x3_0[5] = window5x5[7];
assign window3x3_0[6] = window5x5[10];
assign window3x3_0[7] = window5x5[11];
assign window3x3_0[8] = window5x5[12];

SOBEL_FILTER_RGB565_V2 edge0 (
	//{window5x5[0:2], window5x5[5:7], window5x5[10:12]},
	/*{window5x5[0], window5x5[1], window5x5[2], 
	 window5x5[5], window5x5[6], window5x5[7], 
	 window5x5[10], window5x5[11], window5x5[12]},*/
	window3x3_0,
	I_x_r[0],
	I_x_g[0],
	I_x_b[0],
	I_y_r[0],
	I_y_g[0],
	I_y_b[0]
);


wire [15:0] window3x3_1 [8:0];

assign window3x3_1[0] = window5x5[1];
assign window3x3_1[1] = window5x5[2];
assign window3x3_1[2] = window5x5[3];
assign window3x3_1[3] = window5x5[6];
assign window3x3_1[4] = window5x5[7];
assign window3x3_1[5] = window5x5[8];
assign window3x3_1[6] = window5x5[11];
assign window3x3_1[7] = window5x5[12];
assign window3x3_1[8] = window5x5[13];

SOBEL_FILTER_RGB565_V2 edge1 (
	//{window5x5[1:3], window5x5[6:8], window5x5[11:13]},
	/*{window5x5[1], window5x5[2], window5x5[3], 
	 window5x5[6], window5x5[7], window5x5[8], 
	 window5x5[11], window5x5[12], window5x5[13]},*/
	window3x3_1,
	I_x_r[1],
	I_x_g[1],
	I_x_b[1],
	I_y_r[1],
	I_y_g[1],
	I_y_b[1]
);


wire [15:0] window3x3_2 [8:0];

assign window3x3_2[0] = window5x5[2];
assign window3x3_2[1] = window5x5[3];
assign window3x3_2[2] = window5x5[4];
assign window3x3_2[3] = window5x5[7];
assign window3x3_2[4] = window5x5[8];
assign window3x3_2[5] = window5x5[9];
assign window3x3_2[6] = window5x5[12];
assign window3x3_2[7] = window5x5[13];
assign window3x3_2[8] = window5x5[14];

SOBEL_FILTER_RGB565_V2 edge2 (
	//{window5x5[2:4], window5x5[7:9], window5x5[12:14]},
	/*{window5x5[2], window5x5[3], window5x5[4], 
	 window5x5[7], window5x5[8], window5x5[9], 
	 window5x5[12], window5x5[13], window5x5[14]},*/
	window3x3_2,
	I_x_r[2],
	I_x_g[2],
	I_x_b[2],
	I_y_r[2],
	I_y_g[2],
	I_y_b[2]
);


wire [15:0] window3x3_3 [8:0];

assign window3x3_3[0] = window5x5[5];
assign window3x3_3[1] = window5x5[6];
assign window3x3_3[2] = window5x5[7];
assign window3x3_3[3] = window5x5[10];
assign window3x3_3[4] = window5x5[11];
assign window3x3_3[5] = window5x5[12];
assign window3x3_3[6] = window5x5[15];
assign window3x3_3[7] = window5x5[16];
assign window3x3_3[8] = window5x5[17];

SOBEL_FILTER_RGB565_V2 edge3 (
	//{window5x5[5:7], window5x5[10:12], window5x5[15:17]},
	/*{window5x5[5], window5x5[6], window5x5[7], 
	 window5x5[10], window5x5[11], window5x5[12], 
	 window5x5[15], window5x5[16], window5x5[17]},*/
	window3x3_3,
	I_x_r[3],
	I_x_g[3],
	I_x_b[3],
	I_y_r[3],
	I_y_g[3],
	I_y_b[3]
);


wire [15:0] window3x3_4 [8:0];

assign window3x3_4[0] = window5x5[6];
assign window3x3_4[1] = window5x5[7];
assign window3x3_4[2] = window5x5[8];
assign window3x3_4[3] = window5x5[11];
assign window3x3_4[4] = window5x5[12];
assign window3x3_4[5] = window5x5[13];
assign window3x3_4[6] = window5x5[16];
assign window3x3_4[7] = window5x5[17];
assign window3x3_4[8] = window5x5[18];

SOBEL_FILTER_RGB565_V2 edge4 (
	//{window5x5[6:8], window5x5[11:13], window5x5[16:18]},
	/*{window5x5[6], window5x5[7], window5x5[8], 
	 window5x5[11], window5x5[12], window5x5[13], 
	 window5x5[16], window5x5[17], window5x5[18]},*/
	window3x3_4,
	I_x_r[4],
	I_x_g[4],
	I_x_b[4],
	I_y_r[4],
	I_y_g[4],
	I_y_b[4]
);

wire [8:0] grad_r;
wire [8:0] grad_g;
wire [8:0] grad_b;

assign grad_r = ((I_x_r[4] < 0) ? -I_x_r[4] : I_x_r[4]) + ((I_y_r[4] < 0) ? -I_y_r[4] : I_y_r[4]);
assign grad_g = ((I_x_g[4] < 0) ? -I_x_g[4] : I_x_g[4]) + ((I_y_g[4] < 0) ? -I_y_g[4] : I_y_g[4]);
assign grad_b = ((I_x_b[4] < 0) ? -I_x_b[4] : I_x_b[4]) + ((I_y_b[4] < 0) ? -I_y_b[4] : I_y_b[4]);

wire [15:0] output_pixel;

localparam [8:0] r_high_threshold = 9'h020;
localparam [8:0] g_high_threshold = 9'h040;
localparam [8:0] b_high_threshold = 9'h020;

assign output_pixel = (grad_r > r_high_threshold || grad_g > g_high_threshold || grad_b > b_high_threshold) ? 16'hFFFF : 16'h0000;




wire [15:0] window3x3_5 [8:0];

assign window3x3_5[0] = window5x5[7];
assign window3x3_5[1] = window5x5[8];
assign window3x3_5[2] = window5x5[9];
assign window3x3_5[3] = window5x5[12];
assign window3x3_5[4] = window5x5[13];
assign window3x3_5[5] = window5x5[14];
assign window3x3_5[6] = window5x5[17];
assign window3x3_5[7] = window5x5[18];
assign window3x3_5[8] = window5x5[19];

SOBEL_FILTER_RGB565_V2 edge5 (
	//{window5x5[7:9], window5x5[12:14], window5x5[17:19]},
	/*{window5x5[7], window5x5[8], window5x5[9], 
	 window5x5[12], window5x5[13], window5x5[14], 
	 window5x5[17], window5x5[18], window5x5[19]},*/
	window3x3_5,
	I_x_r[5],
	I_x_g[5],
	I_x_b[5],
	I_y_r[5],
	I_y_g[5],
	I_y_b[5]
);


wire [15:0] window3x3_6 [8:0];

assign window3x3_6[0] = window5x5[10];
assign window3x3_6[1] = window5x5[11];
assign window3x3_6[2] = window5x5[12];
assign window3x3_6[3] = window5x5[15];
assign window3x3_6[4] = window5x5[16];
assign window3x3_6[5] = window5x5[17];
assign window3x3_6[6] = window5x5[20];
assign window3x3_6[7] = window5x5[21];
assign window3x3_6[8] = window5x5[22];

SOBEL_FILTER_RGB565_V2 edge6 (
	//{window5x5[10:12], window5x5[15:17], window5x5[20:22]},
	/*{window5x5[10], window5x5[11], window5x5[12], 
	 window5x5[15], window5x5[16], window5x5[17], 
	 window5x5[20], window5x5[21], window5x5[22]},*/
	window3x3_6,
	I_x_r[6],
	I_x_g[6],
	I_x_b[6],
	I_y_r[6],
	I_y_g[6],
	I_y_b[6]
);


wire [15:0] window3x3_7 [8:0];

assign window3x3_7[0] = window5x5[11];
assign window3x3_7[1] = window5x5[12];
assign window3x3_7[2] = window5x5[13];
assign window3x3_7[3] = window5x5[16];
assign window3x3_7[4] = window5x5[17];
assign window3x3_7[5] = window5x5[18];
assign window3x3_7[6] = window5x5[21];
assign window3x3_7[7] = window5x5[22];
assign window3x3_7[8] = window5x5[23];

SOBEL_FILTER_RGB565_V2 edge7 (
	//{window5x5[11:13], window5x5[16:18], window5x5[21:23]},
	/*{window5x5[11], window5x5[12], window5x5[13], 
	 window5x5[16], window5x5[17], window5x5[18], 
	 window5x5[21], window5x5[22], window5x5[23]},*/
	window3x3_7,
	I_x_r[7],
	I_x_g[7],
	I_x_b[7],
	I_y_r[7],
	I_y_g[7],
	I_y_b[7]
);


wire [15:0] window3x3_8 [8:0];

assign window3x3_8[0] = window5x5[12];
assign window3x3_8[1] = window5x5[13];
assign window3x3_8[2] = window5x5[14];
assign window3x3_8[3] = window5x5[17];
assign window3x3_8[4] = window5x5[18];
assign window3x3_8[5] = window5x5[19];
assign window3x3_8[6] = window5x5[22];
assign window3x3_8[7] = window5x5[23];
assign window3x3_8[8] = window5x5[24];

SOBEL_FILTER_RGB565_V2 edge8 (
	//{window5x5[12:14], window5x5[17:19], window5x5[22:24]},
	/*{window5x5[12], window5x5[13], window5x5[14], 
	 window5x5[17], window5x5[18], window5x5[19], 
	 window5x5[22], window5x5[23], window5x5[24]},*/
	window3x3_8,
	I_x_r[8],
	I_x_g[8],
	I_x_b[8],
	I_y_r[8],
	I_y_g[8],
	I_y_b[8]
);

// Harris Corner Detection:

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

									
									
//wire signed [23:0] det_I_r = I_x_r_squared_sum*I_y_r_squared_sum - I_x_r_I_y_r_sum*I_x_r_I_y_r_sum;
//wire signed [23:0] det_I_g = I_x_g_squared_sum*I_y_g_squared_sum - I_x_g_I_y_g_sum*I_x_g_I_y_g_sum;
//wire signed [23:0] det_I_b = I_x_b_squared_sum*I_y_b_squared_sum - I_x_b_I_y_b_sum*I_x_b_I_y_b_sum;

wire signed [41:0] det_I_r = I_x_r_squared_sum*I_y_r_squared_sum - I_x_r_I_y_r_sum*I_x_r_I_y_r_sum;
wire signed [41:0] det_I_g = I_x_g_squared_sum*I_y_g_squared_sum - I_x_g_I_y_g_sum*I_x_g_I_y_g_sum;
wire signed [41:0] det_I_b = I_x_b_squared_sum*I_y_b_squared_sum - I_x_b_I_y_b_sum*I_x_b_I_y_b_sum;

//wire signed [24:0] R_r = det_I_r - ((I_x_r_squared_sum + I_y_r_squared_sum)*(I_x_r_squared_sum + I_y_r_squared_sum) >> 5);
//wire signed [24:0] R_g = det_I_g - ((I_x_g_squared_sum + I_y_g_squared_sum)*(I_x_g_squared_sum + I_y_g_squared_sum) >> 5);
//wire signed [24:0] R_b = det_I_b - ((I_x_b_squared_sum + I_y_b_squared_sum)*(I_x_b_squared_sum + I_y_b_squared_sum) >> 5);

localparam k = 4;//5;

wire signed [47:0] R_r = det_I_r - ((I_x_r_squared_sum + I_y_r_squared_sum)*(I_x_r_squared_sum + I_y_r_squared_sum) >> k);
wire signed [47:0] R_g = det_I_g - ((I_x_g_squared_sum + I_y_g_squared_sum)*(I_x_g_squared_sum + I_y_g_squared_sum) >> k);
wire signed [47:0] R_b = det_I_b - ((I_x_b_squared_sum + I_y_b_squared_sum)*(I_x_b_squared_sum + I_y_b_squared_sum) >> k);

wire internal_isCorner;

//assign isCorner = internal_isCorner;
always_ff @ (negedge clk) begin
	isCorner <= internal_isCorner;
end


localparam signed r_threshold = 48'h0000005FFFFF;
localparam signed g_threshold = 48'h000005FFFFFF;
localparam signed b_threshold = 48'h0000005FFFFF;

assign internal_isCorner = (R_r > r_threshold || R_g > g_threshold || R_b > b_threshold);

//assign pixel = internal_isCorner ? 16'hFFFF : 16'h0000;
assign pixel = isCorner ? 16'hFFFF : 16'h0000;
//assign pixel = window5x5[24];
//assign pixel = window5x5[12];
//assign pixel = window5x5[18];
//assign pixel = output_pixel;

endmodule
