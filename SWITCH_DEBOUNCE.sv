module SWITCH_DEBOUNCE #(parameter delay = 16'd65535) (
	clk,
	sw_in,
	sw_out
);

// Debounces switch signal
// Waits for 65535 clock cycles of constant switch logic value before switching output
// With a clock of 50 MHz, this equals to >1.3ms delay between switch changing states

input clk;
input sw_in;

output reg sw_out = 1'b0;

reg [15:0] counter;

always @ (posedge clk) begin
	if (sw_in == sw_out) begin
		counter <= 16'b0;
	end
	else begin
		counter <= counter + 1'b1;
		if (counter == delay) begin
			sw_out <= sw_in;
		end
		else begin
			sw_out <= 1'b0;
		end
	end
end

endmodule
