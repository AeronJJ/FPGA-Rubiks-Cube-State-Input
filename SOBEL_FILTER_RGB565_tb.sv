`timescale 1ns/100ps
module SOBEL_FILTER_RGB565_tb;


reg [15:0] data [8:0];
wire [15:0] output_pixel;

SOBEL_FILTER_RGB565 dut (
	data,
	output_pixel
);

integer i;
initial begin
	for (i = 0; i < 9; i = i + 1) begin
		data[i] = 16'hF800;
	end
	#5;
	
	for (i = 0; i < 9; i = i + 1) begin
		data[i] = 16'h07E0;
	end
	#5;
	
	for (i = 0; i < 9; i = i + 1) begin
		data[i] = 16'h001F;
	end
	#5;
	
	for (i = 0; i < 9; i = i + 1) begin
		data[i] = 16'hFD68;
	end
	#5;
	data[0] = 16'hF800;
	data[1] = 16'hF800;
	data[2] = 16'hF800;
	data[3] = 16'hF800;
	data[4] = 16'hF800;
	data[5] = 16'hF800;
	data[6] = 16'h0000;
	data[7] = 16'h0000;
	data[8] = 16'h0000;
	#5;
	
	data[0] = 16'hFD68;
	data[1] = 16'hFD68;
	data[2] = 16'hFD68;
	data[3] = 16'hFD68;
	data[4] = 16'hFD68;
	data[5] = 16'hFD68;
	data[6] = 16'h0000;
	data[7] = 16'h0000;
	data[8] = 16'h0000;
	#5;
	
	data[0] = 16'hFD68;
	data[1] = 16'hFD68;
	data[2] = 16'h0000;
	data[3] = 16'hFD68;
	data[4] = 16'hFD68;
	data[5] = 16'h0000;
	data[6] = 16'hFD68;
	data[7] = 16'hFD68;
	data[8] = 16'h0000;
	#5;

end

endmodule
