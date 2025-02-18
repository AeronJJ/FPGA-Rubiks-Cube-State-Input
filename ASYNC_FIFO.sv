module ASYNC_FIFO (
	clk,
	w_data,
	w_en,
	r_data,
	r_en,
	d_available
);

input clk;

input [15:0] w_data;
input w_en;
//output [15:0] r_data;
output reg [15:0] r_data;
input r_en;
output reg d_available = 1'b0;
/*
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
*/
localparam width = 200;
//localparam width = 76800;

reg [15:0] data [width-1:0];// = '0;

reg [8:0] write_pointer = 9'b0;
reg [8:0] read_pointer = 9'b0;

always_ff @ (posedge clk) begin
	if (read_pointer == write_pointer) begin
		d_available <= 1'b0;
	end
	else begin
		d_available <= 1'b1;
	end
	
	if (write_posedge) begin
		data[write_pointer] <= w_data;
		if (write_pointer == width-1) begin
			write_pointer <= 9'b0;
		end
		else begin
			write_pointer <= write_pointer + 1'b1;
		end
	end
	
	if (read_posedge) begin
		if (~d_available) begin
			read_pointer <= read_pointer;
		end
		else begin
			r_data = data[read_pointer];
			if (read_pointer == width-1) begin
				read_pointer <= 9'b0;
			end
			else begin
				read_pointer <= read_pointer + 1'b1;
			end
		end
	end
end

//always_ff @ (posedge clk) begin

//end

logic [3:0] dummy;

wire write_posedge;
wire read_posedge;


DETECT_SWITCH_EDGE_NOISY write_edge ( 
	w_en,
	clk,
	
	write_posedge,
	dummy[0],
	dummy[1]
);

DETECT_SWITCH_EDGE_NOISY read_edge ( 
	r_en,
	clk,
	
	read_posedge,
	dummy[2],
	dummy[3]
);

endmodule
