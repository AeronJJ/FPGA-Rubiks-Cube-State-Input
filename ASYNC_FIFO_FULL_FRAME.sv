module ASYNC_FIFO_FULL_FRAME (
	clk,
	w_data,
	w_en,
	r_data,
	r_en,
	r_x,
	r_y,
	r_bufferIndex,
	d_available,
	vsync
);

// IO Setup
input clk;
input [15:0] w_data;
input w_en;
output reg [15:0] r_data;
input r_en;
input [8:0] r_x;
input [7:0] r_y;
input [16:0] r_bufferIndex;
input vsync;
output reg d_available = 1'b0;
//


// 
localparam width = 76800;

reg [15:0] data [width-1:0];// = '0;

reg [16:0] write_pointer = 16'b0;
//reg [8:0] read_pointer = 9'b0;
wire [16:0] read_pointer;// = 16'b0;

assign read_pointer = r_y*9'd320 + r_x;

always_ff @ (posedge clk) begin
	if (r_bufferIndex == write_pointer) begin
	//if (r_bufferIndex >= write_pointer) begin
		d_available <= 1'b0;
	end
	else begin
		d_available <= 1'b1;
	end
	
	if (vsync_negedge) begin
		write_pointer <= 9'b0;
	end
	else if (write_posedge) begin
		data[write_pointer] <= w_data;
		if (write_pointer == width-1) begin
			write_pointer <= 9'b0;
		end
		else begin
			write_pointer <= write_pointer + 1'b1;
		end
	end
	
	if (read_posedge) begin
	/*
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
	*/
		//if (d_available) begin
			//r_data <= data[read_pointer];
			r_data <= data[r_bufferIndex];
		//end
	end
end

/*always_comb begin
	if (r_bufferIndex >= write_pointer) begin
		d_available = 1'b0;
	end
	else begin
		d_available = 1'b1;
	end
end*/
//


// Detect edges of r_en and w_en and vsync
logic [5:0] dummy;

wire write_posedge;
wire read_posedge;
wire vsync_posedge;
wire vsync_negedge;

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

DETECT_SWITCH_EDGE_NOISY vsync_edge ( 
	vsync,
	clk,
	
	vsync_posedge,
	//dummy[4],
	vsync_negedge,
	dummy[5]
);
//

endmodule
