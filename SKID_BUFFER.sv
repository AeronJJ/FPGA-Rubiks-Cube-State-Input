module SKID_BUFFER #(parameter width = 16) (
	clk,
	rst,
	
	w_valid,
	w_data,
	w_ready,
	
	r_valid, // If data is ready to read
	r_data,
	r_ready
);

input clk;
input rst;

input w_valid;
input [width-1:0] w_data;
input w_ready;

output reg r_valid = '0;
output reg [width-1:0] r_data = '0;
output reg r_ready;

reg internal_valid;
reg [width-1:0] internal_data;

always_ff @ (posedge clk) begin
	if (rst) begin
		internal_valid <= 1'b0;
	end
	else if ((w_valid && r_ready) && (r_valid && ~w_ready)) begin
		internal_valid <= 1'b1;
	end
	else if (w_ready) begin
		internal_valid <= 1'b0;
	end
end

always_ff @ (posedge clk) begin
	if (r_ready) begin
		internal_data <= w_data;
	end
end

always_comb begin
	r_ready = ~internal_valid;
	r_valid = w_valid || internal_valid;
	if (internal_valid) begin
		r_data = internal_data;
	end
	else begin
		r_data = w_data;
	end
end



endmodule
