`timescale 10ns / 100ps
module STEP_CONVERSION_tb;

reg [4:0] one_move_format_A;
reg [4:0] one_move_format_B;
wire [5:0] two_move_format;

STEP_CONVERSION dut (
	one_move_format_A,
	one_move_format_B,
	two_move_format
);

initial begin
	one_move_format_A = 5'b0; //000000
	one_move_format_B = 5'b0;
	#100
	one_move_format_A = 5'b01001; //010100
	one_move_format_B = 5'b11010;
	#100;
	one_move_format_A = 5'b11010; //111000
	one_move_format_B = 5'b10110; 
	#100;
	one_move_format_A = 5'b10001; //100110
	one_move_format_B = 5'b10110; 
	#100;
end

endmodule
