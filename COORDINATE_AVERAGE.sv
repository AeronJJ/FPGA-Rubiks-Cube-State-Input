module COORDINATE_AVERAGE (
	input rst, // Connect to VSYNC
	input [8:0] x,
	input [7:0] y,
	input en,
	output reg [8:0] x_avg,
	output reg [7:0] y_avg,
	output reg active,
	input clk,
	input [16:0] index,
	input pxl_clk
);

/* Instantiation Template
COORDINATE_AVERAGE avg (
	.rst(), // Connect to VSYNC
	.x(),
	.y(),
	.en(),
	.x_avg(),
	.y_avg(),
	.active(),
	.clk(),
	.index()
);
*/

reg [17:0] counter;
reg [20:0] x_cummulative;
reg [20:0] y_cummulative;

//wire [8:0] internal_x_avg;
//wire [7:0] internal_y_avg;

//reg [20:0] internal_x_avg;
//reg [20:0] internal_y_avg;

//assign internal_x_avg = x_cummulative / counter;
//assign internal_y_avg = y_cummulative / counter;

//assign internal_x_avg = x_cummulative >> shift_amt;
//assign internal_y_avg = y_cummulative >> shift_amt;

/*
wire [4:0] shift_amt;
always_comb begin
    casez (counter)
        18'b1?????????????????: shift_amt = 17;
        18'b01????????????????: shift_amt = 16;
        18'b001???????????????: shift_amt = 15;
        18'b0001??????????????: shift_amt = 14;
        18'b00001?????????????: shift_amt = 13;
        18'b000001????????????: shift_amt = 12;
        18'b0000001???????????: shift_amt = 11;
        18'b00000001??????????: shift_amt = 10;
        18'b000000001?????????: shift_amt = 9;
        18'b0000000001????????: shift_amt = 8;
        18'b00000000001???????: shift_amt = 7;
        18'b000000000001??????: shift_amt = 6;
        18'b0000000000001?????: shift_amt = 5;
        18'b00000000000001????: shift_amt = 4;
        18'b000000000000001???: shift_amt = 3;
        18'b0000000000000001??: shift_amt = 2;
        18'b00000000000000001?: shift_amt = 1;
        18'b000000000000000001: shift_amt = 0;
        default: shift_amt = 0;
    endcase
end
*/

/*
always_comb begin
	if (counter >= 256 && counter < 512) begin
		internal_x_avg = x_cummulative[16:8];
		internal_y_avg = y_cummulative[15:8];
	end
	else if (counter >= 512 && counter < 1024) begin
		internal_x_avg = x_cummulative[17:9];
		internal_y_avg = y_cummulative[16:9];
	end
	else if (counter >= 1024 && counter < 2048) begin
		internal_x_avg = x_cummulative[18:10];
		internal_y_avg = y_cummulative[17:10];
	end
	else if (counter >= 2048 && counter < 4096) begin
		internal_x_avg = x_cummulative[19:11];
		internal_y_avg = y_cummulative[18:11];
	end
	else begin
		internal_x_avg = 9'h10F;
		internal_y_avg = 8'hF0;
	end
end
*/

wire rst_pos_edge_pulse;
wire rst_neg_edge_pulse;
wire rst_either;

DETECT_SWITCH_EDGE_NOISY rst_det ( 
	rst,
	clk,
	
	rst_pos_edge_pulse,
	rst_neg_edge_pulse,
	rst_either
);

always_ff @ (posedge pxl_clk or posedge rst_pos_edge_pulse) begin
//always_ff @ (posedge index[0] or posedge rst_pos_edge_pulse) begin
//always_ff @ (posedge en or posedge rst_pos_edge_pulse) begin
	if (rst_pos_edge_pulse) begin
		/*x_avg <= internal_x_avg;
		y_avg <= internal_y_avg;
		active <= internal_active;*/
		
		counter <= 18'b0;
		x_cummulative <= 21'b0;
		y_cummulative <= 21'b0;
	end
	else if (en) begin
		counter <= counter + 1'b1;
		x_cummulative <= x_cummulative + x;
		y_cummulative <= y_cummulative + y;
	end	
end

always_ff @ (posedge rst_neg_edge_pulse) begin
	//x_avg <= internal_x_avg;
	//y_avg <= internal_y_avg;
	
	/*if (counter >= 256 && counter < 512) begin
		x_avg <= x_cummulative[16:8];
		y_avg <= y_cummulative[15:8];
		active <= 1'b1;
	end
	else if (counter >= 512 && counter < 1024) begin
		x_avg <= x_cummulative[17:9];
		y_avg <= y_cummulative[16:9];
		active <= 1'b1;
	end
	else if (counter >= 1024 && counter < 2048) begin
		x_avg <= x_cummulative[18:10];
		y_avg <= y_cummulative[17:10];
		active <= 1'b1;
	end
	else if (counter >= 2048 && counter < 4096) begin
		x_avg <= x_cummulative[19:11];
		y_avg <= y_cummulative[18:11];
		active <= 1'b1;
	end*/
	if (counter >= 1028 && counter < 4096) begin
		x_avg <= x_cummulative/counter;
		y_avg <= y_cummulative/counter;
		active <= 1'b1;
	end
	else begin
		x_avg <= 9'h1FF;
		y_avg <= 8'hFF;
		active <= 1'b0;
	end
	
	//active <= internal_active;
end

/*
localparam lower_corner_threshold = 256;
localparam upper_corner_threshold = 4096;

wire internal_active;

always_comb begin
	if (counter >= lower_corner_threshold && counter < upper_corner_threshold) begin
		internal_active = 1'b1;
	end
	else begin
		internal_active = 1'b0;
	end
end
*/

endmodule
