module DETECT_SWITCH_EDGE_NOISY ( 
	sw,
	clk,
	
	pos_edge_pulse,
	neg_edge_pulse,
	either_edge_pulse
);

input sw;
input clk;
output reg pos_edge_pulse;
output reg neg_edge_pulse;
output either_edge_pulse;

initial pos_edge_pulse = 1'b0;
initial neg_edge_pulse = 1'b0;

assign either_edge_pulse = pos_edge_pulse || neg_edge_pulse;

reg [1:0] switch_state_c = 2'b0;
reg [1:0] switch_state_n = 2'b0;

always @ (posedge clk) begin
	switch_state_c <= switch_state_n;
	pos_edge_pulse <= 1'b0;
	neg_edge_pulse <= 1'b0;
	case (switch_state_c) 
		2'b00: begin
		
		end
		
		2'b01: begin
			pos_edge_pulse <= 1'b1;
		end
		
		2'b10: begin
		
		end
		
		2'b11: begin
			neg_edge_pulse <= 1'b1;
		end
		
	endcase
end

always @ (*) begin
	switch_state_n = switch_state_c;
	case (switch_state_c)
		2'b00: begin
			if (~sw) begin
				switch_state_n <= 2'b01;
			end
			else begin
				switch_state_n <= 2'b00;
			end
		end
		
		2'b01: begin
			switch_state_n <= 2'b10;
		end
		
		2'b10: begin
			if (sw) begin
				switch_state_n <= 2'b11;
			end
			else begin
				switch_state_n <= 2'b10;
			end
		end
		
		2'b11: begin
			switch_state_n <= 2'b00;
		end
	endcase
end

endmodule
