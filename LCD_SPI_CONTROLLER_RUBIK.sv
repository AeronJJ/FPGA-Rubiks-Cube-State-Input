module LCD_SPI_CONTROLLER_RUBIK (
	i_clk_100MHz,
	
	bufferData,
	bufferClk,
	
	o_cs,
	o_dcrs,
	o_sdi,
	o_sck,
	o_lcdrst,
	
	pixel_available,
	rst_coord
);


input [15:0] bufferData;
output reg bufferClk;

reg lowByte = 1'b1;
assign bufferClk = pixel_available ? !lowByte : 1'b0;
//assign bufferClk = !lowByte;

output o_cs;
output o_dcrs;
output o_sdi;
output o_sck;
output reg o_lcdrst;

input i_clk_100MHz;

input pixel_available;
input rst_coord;
	
localparam CLK_FREQ_MHz = 100;

reg i_en;
reg [7:0] i_data;
reg i_cdr;

wire o_busy;
wire [7:0] o_data;

LCD_SPI_MASTER_IMPROVED spi (
	i_en,
	i_cdr, // 2 bits, command/data and send/send+receive.
	i_clk_100MHz,
	i_data,
	
	o_busy,
	
	o_cs,
	o_dcrs,
	o_sdi,
	o_sck
);

//localparam INIT_SEQ_LEN = 52;
localparam INIT_SEQ_LEN = 181;
reg[7:0] init_counter = 6'b0;
reg[8:0] INIT_SEQ [0:INIT_SEQ_LEN-1] = '{
	// Sequence of Init messages, consists of both commands and parameters:
	// Commands:  |  Paramaters....
	{1'b0, 8'h28}, // Turn off Display
	{1'b0, 8'hCF}, {1'b1, 8'h00}, {1'b1, 8'h83}, {1'b1, 8'h30}, // Power control B
	{1'b0, 8'hED}, {1'b1, 8'h64}, {1'b1, 8'h03}, {1'b1, 8'h12}, {1'b1, 8'h81}, // Power on sequence control
	{1'b0, 8'hE8}, {1'b1, 8'h85}, {1'b1, 8'h01}, {1'b1, 8'h79}, // Driver timing control A
	{1'b0, 8'hCB}, {1'b1, 8'h39}, {1'b1, 8'h2C}, {1'b1, 8'h00}, {1'b1, 8'h34}, {1'b1, 8'h02}, // Power control A
	{1'b0, 8'hF7}, {1'b1, 8'h20}, // Pump ratio control
	{1'b0, 8'hEA}, {1'b1, 8'h00}, {1'b1, 8'h00}, // Driver timing control B
	{1'b0, 8'hC0}, {1'b1, 8'h26}, // Power Control 1
	{1'b0, 8'hC1}, {1'b1, 8'h11}, // Power Control 2
	{1'b0, 8'hC5}, {1'b1, 8'h35}, {1'b1, 8'h3E}, // VCOM Control 1
	{1'b0, 8'hC7}, {1'b1, 8'hBE}, // VCOM Control 2
	{1'b0, 8'h3A}, {1'b1, 8'h55}, // COLMOD: Pixel Format Set (16 bit mode)
	{1'b0, 8'hB1}, {1'b1, 8'h00}, {1'b1, 8'h1B}, // Frame Rate Control
	{1'b0, 8'h26}, {1'b1, 8'h01}, // Gamma Set
	{1'b0, 8'h51}, {1'b1, 8'hFF}, // Write Display Brightness
	{1'b0, 8'hB7}, {1'b1, 8'h07}, // Entry Mode Set
	{1'b0, 8'hB6}, {1'b1, 8'h0A}, {1'b1, 8'h82}, {1'b1, 8'h27}, {1'b1, 8'h00}, // Display Function Control
	{1'b0, 8'h29}, // Display ON
	//{1'b0, 8'h2C}  // Start Memory-Write
	
	{1'b0, 8'h2D}, {1'b1, 8'h0}, {1'b1, 8'h2}, {1'b1, 8'h4}, {1'b1, 8'h6}, {1'b1, 8'h8}, {1'b1, 8'hA}, {1'b1, 8'hC}, {1'b1, 8'hE}, {1'b1, 8'h10}, {1'b1, 8'h12}, {1'b1, 8'h14}, {1'b1, 8'h16}, {1'b1, 8'h18}, {1'b1, 8'h1A}, {1'b1, 8'h1C}, {1'b1, 8'h1E}, {1'b1, 8'h20}, {1'b1, 8'h22}, {1'b1, 8'h24}, {1'b1, 8'h26}, {1'b1, 8'h28}, {1'b1, 8'h2A}, {1'b1, 8'h2C}, {1'b1, 8'h2E}, {1'b1, 8'h30}, {1'b1, 8'h32}, {1'b1, 8'h34}, {1'b1, 8'h36}, {1'b1, 8'h38}, {1'b1, 8'h3A}, {1'b1, 8'h3C}, {1'b1, 8'h3E}, 
						{1'b1, 8'h0}, {1'b1, 8'h1}, {1'b1, 8'h2}, {1'b1, 8'h3}, {1'b1, 8'h4}, {1'b1, 8'h5}, {1'b1, 8'h6}, {1'b1, 8'h7}, {1'b1, 8'h8}, {1'b1, 8'h9}, {1'b1, 8'hA}, {1'b1, 8'hB}, {1'b1, 8'hC}, {1'b1, 8'hD}, {1'b1, 8'hE}, {1'b1, 8'hF}, {1'b1, 8'h10}, {1'b1, 8'h11}, {1'b1, 8'h12}, {1'b1, 8'h13}, {1'b1, 8'h14}, {1'b1, 8'h15}, {1'b1, 8'h16}, {1'b1, 8'h17}, {1'b1, 8'h18}, {1'b1, 8'h19}, {1'b1, 8'h1A}, {1'b1, 8'h1B}, {1'b1, 8'h1C}, {1'b1, 8'h1D}, {1'b1, 8'h1E}, {1'b1, 8'h1F}, {1'b1, 8'h20}, {1'b1, 8'h21}, {1'b1, 8'h22}, {1'b1, 8'h23}, {1'b1, 8'h24}, {1'b1, 8'h25}, {1'b1, 8'h26}, {1'b1, 8'h27}, {1'b1, 8'h28}, {1'b1, 8'h29}, {1'b1, 8'h2A}, {1'b1, 8'h2B}, {1'b1, 8'h2C}, {1'b1, 8'h2D}, {1'b1, 8'h2E}, {1'b1, 8'h2F}, {1'b1, 8'h30}, {1'b1, 8'h31}, {1'b1, 8'h32}, {1'b1, 8'h33}, {1'b1, 8'h34}, {1'b1, 8'h35}, {1'b1, 8'h36}, {1'b1, 8'h37}, {1'b1, 8'h38}, {1'b1, 8'h39}, {1'b1, 8'h3A}, {1'b1, 8'h3B}, {1'b1, 8'h3C}, {1'b1, 8'h3D}, {1'b1, 8'h3E}, {1'b1, 8'h3F}, 
						{1'b1, 8'h0}, {1'b1, 8'h2}, {1'b1, 8'h4}, {1'b1, 8'h6}, {1'b1, 8'h8}, {1'b1, 8'hA}, {1'b1, 8'hC}, {1'b1, 8'hE}, {1'b1, 8'h10}, {1'b1, 8'h12}, {1'b1, 8'h14}, {1'b1, 8'h16}, {1'b1, 8'h18}, {1'b1, 8'h1A}, {1'b1, 8'h1C}, {1'b1, 8'h1E}, {1'b1, 8'h20}, {1'b1, 8'h22}, {1'b1, 8'h24}, {1'b1, 8'h26}, {1'b1, 8'h28}, {1'b1, 8'h2A}, {1'b1, 8'h2C}, {1'b1, 8'h2E}, {1'b1, 8'h30}, {1'b1, 8'h32}, {1'b1, 8'h34}, {1'b1, 8'h36}, {1'b1, 8'h38}, {1'b1, 8'h3A}, {1'b1, 8'h3C}, {1'b1, 8'h3E},
	{1'b0, 8'h2C}  // Start Memory-Write
};

localparam c_START = 3'b000;
localparam c_RESET_WAIT = 3'b001;
localparam c_DELAY = 3'b010;
localparam c_INIT = 3'b011;
localparam c_MEM_DELAY = 3'b100;
localparam c_DATA = 3'b101;
localparam c_GOTO11 = 3'b110;
//localparam c_DATA_HIGH = 3'b101;
//localparam c_DATA_LOW = 3'b110;

reg [2:0] current_state;
reg [2:0] next_state;

reg [23:0] delay_left = 24'b0;

always @ (posedge i_clk_100MHz) begin
	i_en <= 1'b0;
	//bufferClk <= 1'b0;
	current_state <= next_state;

	if (delay_left > 24'b0) begin
		delay_left <= delay_left - 1'b1; // Wait for delay to count down
	end
	else if (~o_busy && !i_en) begin // Waits for SPI to not be busy
		// State Machine Logic
		case (current_state)
			c_START: begin
				o_lcdrst <= 1'b0; // Reset LCD
				delay_left <= 24'(CLK_FREQ_MHz*100); // Wait for reset to propagate ~ 0.1ms
			end
			
			c_RESET_WAIT: begin
				o_lcdrst <= 1'b1; // Release reset
				delay_left <= 24'(CLK_FREQ_MHz*15000); // Wait for lcd to power-up ~ 150ms
			end
			
			c_DELAY: begin
				i_cdr <= 1'b0;
				i_data <= 8'h11; // Sleep Out
				i_en <= 1'b1;
				delay_left <= 24'(CLK_FREQ_MHz*15000); // Wait for lcd to exit sleep, > 120ms
			end
			
			c_INIT: begin
				i_cdr <= INIT_SEQ[init_counter][8];
				i_data <= INIT_SEQ[init_counter][7:0];
				i_en <= 1'b1;
				init_counter <= init_counter + 1'b1;
			end
			
			c_MEM_DELAY: begin
				delay_left <= 24'(CLK_FREQ_MHz*10000); // Wait for memory to become available for write ~10ms, is not necessary except in rare circumstances
			end
			
			c_DATA: begin
				// Continous loop that sends pixel data 1 byte at a time. Pixel data is two bytes.
				i_cdr <= 1'b1;
				i_data <= !lowByte ? bufferData[15:8] : bufferData[7:0];
				i_en <= 1'b1;
				lowByte <= !lowByte;
			end
			
			c_GOTO11: begin
				//{1'b0, 8'h2C}
				// Sends Memory Write message again which will reset memory address
				i_cdr <= 1'b0;
				i_data <= 8'h2C;
				i_en <= 1'b1;
				lowByte <= 1'b1;
			end
			
			/*c_DATA_HIGH: begin
				//if (pixel_available) begin
					//bufferClk <= 1'b1;
					i_cdr <= 1'b1;
					//i_data <= !lowByte ? bufferData[15:8] : bufferData[7:0];
					i_data <= bufferData[15:8];
					i_en <= 1'b1;
					lowByte <= 1'b1;
					//lowByte <= !lowByte;
				//end
			end
			
			c_DATA_LOW: begin
				i_cdr <= 1'b1;
				//i_data <= !lowByte ? bufferData[15:8] : bufferData[7:0];
				i_data <= bufferData[7:0];
				i_en <= 1'b1;
				lowByte <= 1'b0;
				//lowByte <= !lowByte;
			end*/
			
			default: begin
				current_state <= c_START; // This does nothing
			end
		endcase
	end
end

always @ (*) begin // Generate sensitivity list
	next_state = current_state;
	case (current_state)
		c_START: begin
			next_state = c_RESET_WAIT;
		end
		
		c_RESET_WAIT: begin
			if (delay_left == 24'b0) begin
				next_state = c_DELAY;
			end
			else begin
				next_state = c_RESET_WAIT;
			end
		end
		
		c_DELAY: begin
			if (delay_left == 24'b0) begin
				next_state = c_INIT;
			end
			else begin
				next_state = c_DELAY;
			end
		end
		
		c_INIT: begin
			if (init_counter < INIT_SEQ_LEN) begin
				next_state = c_INIT;
			end
			else begin
				next_state = c_MEM_DELAY;
			end
		end
		
		c_MEM_DELAY: begin
			//next_state = c_DATA_HIGH;
			next_state = c_DATA;
		end
			
		c_DATA: begin
			if (rst_coord) begin
				next_state = c_GOTO11;
			end
			else begin
				next_state = c_DATA;
			end
		end
			
		c_GOTO11: begin
			if (~o_busy) begin
				next_state = c_MEM_DELAY;
			end
		end
			
		/*c_DATA_HIGH: begin
			//if (lowByte) begin
				next_state = c_DATA_LOW;
			//end
		end
			
		c_DATA_LOW: begin
			next_state = c_DATA_HIGH;
		end*/
		
		default: begin
			next_state = c_START;
		end
	endcase
end

endmodule
