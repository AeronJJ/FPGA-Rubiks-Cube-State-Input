module STEP_CONVERSION (
	input [4:0] one_move_format_A,
	input [4:0] one_move_format_B,
	output [5:0] two_move_format
);

wire [2:0] and_inputs;
wire c;

xnor (and_inputs[0], one_move_format_A[4], one_move_format_B[4]);
xnor (and_inputs[1], one_move_format_A[3], one_move_format_B[3]);
xor (and_inputs[2], one_move_format_A[2], one_move_format_B[2]);
and (c, and_inputs[0], and_inputs[1], and_inputs[2]);

wire [1:0] mux_1_in;

assign mux_1_in = c ? one_move_format_B[1:0] : 2'b0;

assign two_move_format[5:4] = one_move_format_A[4:3];

assign two_move_format[3:2] = one_move_format_A[2] ? mux_1_in : one_move_format_A[1:0];

assign two_move_format[1:0] = ~one_move_format_A[2] ? mux_1_in : one_move_format_A[1:0];

endmodule
