module OV7670_SCCB (
	input clk_800KHz, // 800 KHz maximum
	input clk_800KHz_30,
	output t_SDA,
	input r_SDA,
	output reg drive_SDA,
	output o_SDC_400KHz,	// 400 KHz maximum
	
	input [7:0] addr_in,
	input [7:0] data_in,
	input en,
	output ready,
	output reg busy,
	output reg ack
);

initial busy = 1'b0;
//initial ack = 1'b0;

reg [7:0] internal_data = 8'b0;
reg [7:0] internal_addr = 8'b0;
reg internal_clock = 1'b1;

wire [0:7] reversed_ID;
wire [0:7] reversed_data;
wire [0:7] reversed_addr;

assign reversed_ID[0:7] = 8'h42;
assign reversed_data[0:7] = internal_data[7:0];
assign reversed_addr[0:7] = internal_addr[7:0];

assign o_SDC_400KHz = (busy && data_index > 5'b0) ? internal_clock : 1'b1;

reg [4:0] data_index = 5'b0;

reg internal_SDA = 1'bz;
initial drive_SDA = 1'b0;

assign t_SDA = internal_SDA;

always @ (posedge clk_800KHz) begin
	//internal_clock = ~internal_clock;
	
	if (busy && ~internal_clock) begin
		if (data_index == 5'd9 || data_index == 5'd18 || data_index == 5'd27) begin
			drive_SDA = 1'b0;
			internal_SDA = 1'bz;
		end
		//else if (data_index == 5'd28) begin
		//	internal_SDA = 1'b1;
		//end
		else if (data_index == 5'd0) begin
			drive_SDA = 1'b1;
			internal_SDA = 1'b0;
		end
		else if (data_index < 5'd9) begin
			drive_SDA = 1'b1;
			internal_SDA = reversed_ID[data_index - 5'd1];
		end
		else if (data_index < 5'd18) begin
			drive_SDA = 1'b1;
			internal_SDA = reversed_addr[data_index - 5'd10];
		end
		else if (data_index < 5'd27) begin
			drive_SDA = 1'b1;
			internal_SDA = reversed_data[data_index - 5'd19];
		end
	end
	else if (busy && internal_clock) begin
		if (data_index == 5'd28) begin
			drive_SDA = 1'b1;
			internal_SDA = 1'b1;
		end
	end
	else if (~busy && ~internal_clock) begin
		drive_SDA = 1'b0;
		internal_SDA = 1'bz;
	end
end

always @ (posedge clk_800KHz_30) begin
	internal_clock = ~internal_clock;
end

reg [23:0] delay_left = 24'b0;
assign ready = (delay_left == 24'b0 && ~busy);

always @ (negedge internal_clock) begin
	if (delay_left > 24'b0) begin
		delay_left = delay_left - 1'b1; // Wait for delay to count down
		ack = 1'b0;
	end
	else if (en && ~busy) begin // Load next message in
		data_index = 5'b0;
		internal_data = data_in;
		internal_addr = addr_in;
		busy = 1'b1;
	end
	else if (data_index == 5'd9 || data_index == 5'd18) begin
		data_index = data_index + 5'd1;
		ack = ~r_SDA;
	end
	else if (data_index == 5'd28 && busy) begin
		data_index = 5'b0;
		ack = ~r_SDA;
		busy = 1'b0;
		delay_left = 24'd264;
	end
	else if (data_index == 5'd28) begin
		data_index = 5'b0;
	end
	else begin
		data_index = data_index + 5'd1;
		ack = 1'b0;
	end
end

endmodule
