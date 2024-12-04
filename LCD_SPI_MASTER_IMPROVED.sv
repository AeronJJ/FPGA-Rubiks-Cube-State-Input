module LCD_SPI_MASTER_IMPROVED (
	i_en,
	i_cdr, // command/data 
	i_clk, // Input clock, ~100 MHz
	i_data, // 8 bit message input
	
	o_busy,
	
	o_cs,
	o_dcrs,
	o_sdi, // Data output pin
	o_sck // SPI clock ~50% of input clock
);

input i_en;
input i_cdr;
input i_clk;
input [7:0] i_data;

output reg o_busy = 1'b0;
output reg o_cs = 1'b1;
output reg o_dcrs;
output reg o_sdi;
output wire o_sck;

reg [7:0] internal_data;
reg [0:2] data_counter = 3'b0;
reg internal_sck = 1'b1;

wire [0:7] reversed_data;

assign reversed_data[0:7] = internal_data[7:0];
assign o_sck = internal_sck & ~o_cs;

always @ (posedge i_clk) begin
	if (i_en) begin // Load next byte in
		internal_data <= i_data;
		o_busy <= 1'b1;
	end
	
	if (o_busy) begin
		internal_sck <= !internal_sck; // Drive SPI clock
		
		if (internal_sck) begin // Operate when clock is high
			o_dcrs <= i_cdr; // Set command/data pin
			o_sdi <= reversed_data[data_counter]; // Send next data bit
			o_cs <= 1'b0; // Set chip select low
			data_counter <= data_counter + 1'b1; // Increment data counter
			o_busy <= ~&data_counter; // Busy flag is low if data counter bits are all ones
		end
	end
	else begin
		internal_sck <= 1'b1;
		if (internal_sck) o_cs <= 1'b1;
	end
end

endmodule
