module COORDINATE_COUNTER #(parameter x_count = 320, y_count = 240, x_width = 9, y_width = 8) (
	increment,
	rst,
	x,
	y,
	index
);

localparam size = x_count * y_count;

input increment;
input rst;
output reg[x_width-1:0] x = 9'b0; // Current pixel position
output reg[y_width-1:0] y = 8'b0;

output reg[16:0] index = 17'd0;

always_ff @ (posedge increment or posedge rst) begin
	if (rst) begin
		index <= 17'b0;
		x <= '0;
		y <= '0;
	end
	else if (index == size-1) begin
		index <= 17'b0;
		x <= '0;
		y <= '0;
	end
	else begin
		index <= index + 1'b1;
		if (x == x_count-1) begin
			x <= '0;
			y <= y + 1'b1;
		end
		else begin
			x <= x + 1'b1;
		end
	end
end

// + ~400 logic units:
//assign bufferIndex = (bufferIndex + 1'b1) % 17'(320*240); // Max buffer of 320*240
//wire[8:0] x = 9'(bufferIndex / 240); // x and y calculations
//wire[7:0] y = 8'(bufferIndex % 240);

endmodule
