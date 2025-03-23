module ASYNC_FIFO_FULL_FRAME (
	clk,
	w_data,
	w_en,
	w_bufferIndex,
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
input [16:0] w_bufferIndex;
//output reg [15:0] r_data; // UNCOMMENT HERE
output [15:0] r_data;
input r_en;
input [8:0] r_x;
input [7:0] r_y;
input [16:0] r_bufferIndex;
input vsync;
output reg d_available = 1'b0;
//


/**/
reg [15:0] window [8:0];

SOBEL_FILTER_RGB565 filter (
	r_en,
	window,
	r_data
);

// 
localparam width = 76800;
localparam mem_length = width/3; // 25600
localparam lcd_width = 320;

reg [15:0] mem_0 [0:mem_length-1];
reg [15:0] mem_1 [0:mem_length-1];
reg [15:0] mem_2 [0:mem_length-1];

wire [14:0] r_memory_index;
wire [14:0] w_memory_index;

wire [1:0] r_data_selector;
wire [1:0] w_data_selector;

always_comb begin
	r_memory_index = (r_bufferIndex/(3*lcd_width)) * lcd_width + (r_bufferIndex%lcd_width);
	w_memory_index = (w_bufferIndex/(3*lcd_width)) * lcd_width + (w_bufferIndex%lcd_width);
	
	r_data_selector = (r_bufferIndex%(3*lcd_width)) / lcd_width;
	w_data_selector = (w_bufferIndex%(3*lcd_width)) / lcd_width;

/*
	case (r_data_selector)
		2'b00: 
			r_memory_index = r_bufferIndex / 3;
		end
		
		2'b01:
			r_memory_index = (r_bufferIndex-320) / 3;
		end
		
		2'b10:
			r_memory_index = (r_bufferIndex-640) / 3;
		end
	endcase
	
	case (w_data_selector)
		2'b00: 
			w_memory_index = w_bufferIndex / 3;
		end
		
		2'b01:
			w_memory_index = (w_bufferIndex-320) / 3;
		end
		
		2'b10:
			w_memory_index = (w_bufferIndex-640) / 3;
		end
	endcase
*/
end

//reg [15:0] data [0:width-1];
logic [15:0] read_data_0, read_data_1, read_data_2;

always_comb begin
	if (w_bufferIndex == 0 && r_bufferIndex > 0 && r_bufferIndex < 76800) begin
		d_available = 1'b1;
	end
	else if (r_bufferIndex > w_bufferIndex || w_bufferIndex == 0 || (w_bufferIndex == 76800 && r_bufferIndex == 0)) begin
		d_available = 1'b0;
	end
	else begin
		d_available = 1'b1;
	end
end

always_ff @ (posedge clk) begin
	/*if (r_bufferIndex >= w_bufferIndex-1'b1 || w_bufferIndex < 10) begin
		d_available <= 1'b0;
	end
	else begin
		d_available <= 1'b1;
	end*/
	
	if (write_posedge) begin
		//data[w_bufferIndex] <= w_data;
		if (w_data_selector == 2'b00) begin
			mem_0[w_memory_index] <= w_data;
		end
		else if (w_data_selector == 2'b01) begin
			mem_1[w_memory_index] <= w_data;
		end
		else if (w_data_selector == 2'b10) begin
			mem_2[w_memory_index] <= w_data;
		end
	end
	
	if (read_posedge) begin
		if (d_available) begin
			/*
			r_data <= data[r_bufferIndex]; // UNCOMMENT THIS ONE
			*/
			
			/*if (r_bufferIndex >= 640) begin
				window <= '{data[r_bufferIndex-642], data[r_bufferIndex-641], data[r_bufferIndex-640], 
								data[r_bufferIndex-322], data[r_bufferIndex-321], data[r_bufferIndex-320], 
								data[r_bufferIndex-2], data[r_bufferIndex-1], data[r_bufferIndex]};*/
								
				/*read_data_0 <= data[r_bufferIndex - 640];  
            read_data_1 <= data[r_bufferIndex - 320];
            read_data_2 <= data[r_bufferIndex];*/

				read_data_0 <= mem_0[r_memory_index];
				read_data_1 <= mem_1[r_memory_index];
				read_data_2 <= mem_2[r_memory_index];
								
				window[0] <= window[1];
				window[1] <= window[2];
				//window[2] <= read_data_0;
				
				window[3] <= window[4];
				window[4] <= window[5];
				//window[5] <= read_data_1;
				
				window[6] <= window[7];
				window[7] <= window[8];
				//window[8] <= read_data_2;
				
				case (r_data_selector) 
					2'b00: begin
						/*window[2] <= read_data_0;
						window[5] <= read_data_1;
						window[8] <= read_data_2;*/
						
						window[2] <= read_data_1;
						window[5] <= read_data_2;
						window[8] <= read_data_0;
						
						/*window[2] <= read_data_2;
						window[5] <= read_data_0;
						window[8] <= read_data_1;*/
					end
					
					2'b01: begin
						/*window[2] <= read_data_1;
						window[5] <= read_data_2;
						window[8] <= read_data_0;*/
						
						window[2] <= read_data_2;
						window[5] <= read_data_0;
						window[8] <= read_data_1;
						
						/*window[2] <= read_data_0;
						window[5] <= read_data_1;
						window[8] <= read_data_2;*/
					end
					
					2'b10: begin
						/*window[2] <= read_data_2;
						window[5] <= read_data_0;
						window[8] <= read_data_1;*/
						
						window[2] <= read_data_0;
						window[5] <= read_data_1;
						window[8] <= read_data_2;
						
						/*window[2] <= read_data_1;
						window[5] <= read_data_2;
						window[8] <= read_data_0;*/
					end
				endcase
			//end
			
		end
	end
end



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
