module ASYNC_FIFO (
	w_data,
	w_en,
	r_data,
	r_en,
	d_available
);

input [15:0] w_data;
input w_en;
output [15:0] r_data;
input r_en;
output reg d_available = 1'b0;

reg [15:0] data = 16'b0;

assign r_data = d_available ? data : 16'b0;

always @ (posedge w_en or posedge r_en) begin
	if (r_en) begin
		d_available <= 1'b0;
		data <= 16'b0;
	end
	else if (w_en) begin
		data <= w_data;
		d_available <= 1'b1;
	end
end

endmodule
