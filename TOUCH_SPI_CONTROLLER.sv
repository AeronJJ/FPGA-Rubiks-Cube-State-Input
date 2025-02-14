module TOUCH_SPI_CONTROLLER (
	input clk_1MHz,
	input t_sdo,
	input t_irq,
	output t_cs,
	output t_sdi,
	output t_sck,
	output reg [11:0] x_data = 12'b0,
	output reg [11:0] y_data = 12'b0,
	output reg newData,
	
	input rst_n
);

reg t_en = 1'b0;
reg [7:0] touch_data_in = 8'b0;
wire t_busy;
wire [15:0] touch_data;
wire touch_data_valid;


TOUCH_SPI_MASTER touch (
	clk_1MHz, // 4MHz maximum, sck will be half this frequency and max spi clk frequency is 2MHz
	t_en,
	touch_data_in,
	t_sdo,
	t_irq,
	
	t_busy,
	touch_data,
	
	t_cs,
	t_sdi,
	t_sck,
	touch_data_valid,
	
	rst_n
);

reg data_read = 1'b0;

reg [23:0] delay_left = 24'b0;
localparam CLK_FREQ_MHz = 1;

(* syn_preserve = 1, syn_encoding = "none" *) reg [2:0] current_state;
reg [2:0] next_state;

localparam s_IDLE = 3'b000;
localparam s_READ_X = 3'b001;
localparam s_SET_X = 3'b010;
localparam s_READ_Y = 3'b011;
localparam s_SET_Y = 3'b100;

reg [23:0] timeout = 24'b0; // Crude implementation of timeout tracking, implemented to fix weird state bug in this module, it did not fix it so reset logic was implemented instead


always @ (posedge clk_1MHz or negedge rst_n) begin
//always @ (posedge clk_1MHz) begin
	if (~rst_n) begin
		current_state <= s_IDLE;
		t_en <= 1'b0;
		newData <= 1'b0;
		timeout <= 24'b0;
		delay_left <= 24'b0;
		touch_data_in <= 8'b0;
		data_read <= 1'b0;
		x_data <= 12'b0;
		y_data <= 12'b0;
	end
	else begin
		current_state <= next_state;
		t_en <= 1'b0;
		newData <= 1'b0;
		if (timeout > 24'b0) begin
			timeout <= timeout - 1'b1;
		end
		if (delay_left > 24'b0) begin
			delay_left <= delay_left - 1'b1; // Wait for delay to count down
		end
		else if (~t_busy && ~t_en) begin
			case (current_state)
				s_IDLE: begin
					delay_left <= 24'b0;
					touch_data_in <= 8'b0;
					t_en <= 1'b0;
					data_read <= 1'b0;
				end
				
				s_READ_X: begin
					touch_data_in <= 8'h09; // Read x
					t_en <= 1'b1;
					data_read <= 1'b0;
					delay_left <= 24'(CLK_FREQ_MHz*50); // Approx 50us
					timeout <= 24'(CLK_FREQ_MHz*150000);
				end
				
				s_SET_X: begin
					if (touch_data_valid || ~timeout) begin
						timeout <= 24'b0;
						x_data <= touch_data[15:4];
						data_read <= 1'b1;
					end
				end
				
				s_READ_Y: begin
					touch_data_in <= 8'h0B; // Read y
					t_en <= 1'b1;
					data_read <= 1'b0;
					delay_left <= 24'(CLK_FREQ_MHz*50); // Approx 50us
					timeout <= 24'(CLK_FREQ_MHz*150000);
				end
				
				s_SET_Y: begin
					if (touch_data_valid || ~timeout) begin
						timeout <= 24'b0;
						y_data <= touch_data[15:4];
						data_read <= 1'b1;
						delay_left <= 24'(CLK_FREQ_MHz*150000); // Approx 150ms
						newData <= 1'b1;
					end
				end
				
				default: begin
					current_state <= s_IDLE;
				end
			endcase
		end
	end
end

always @ (*) begin
	//next_state = current_state;
	if (~rst_n) begin
		next_state = s_IDLE;
	end
	else begin
		next_state = current_state;
	end
	case (current_state)
		s_IDLE: begin
//			if (~t_busy && ~t_en && ~t_irq && ~delay_left) begin
			if (~t_busy && ~t_en && ~t_irq) begin
				next_state = s_READ_X;
			end
		end
		
		s_READ_X: begin
			next_state = s_SET_X;
		end
		
		s_SET_X: begin
			if (data_read) begin
				next_state = s_READ_Y;
			end
		end
		
		s_READ_Y: begin
			next_state = s_SET_Y;
		end
		
		s_SET_Y: begin
			if (data_read) begin
				next_state = s_IDLE;
			end
		end
		
		default: begin
			next_state = s_IDLE;
		end
	endcase
end

endmodule
