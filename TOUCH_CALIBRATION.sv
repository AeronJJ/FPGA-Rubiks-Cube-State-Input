module TOUCH_CALIBRATION (
	input clk,
	input active,
	input [8:0] x_pixel,
	input [7:0] y_pixel,
	input [11:0] x_touch,
	input [11:0] y_touch,
	output [15:0] currentPixel_calibration
);

//320*240
localparam x_cal0 = 20;
localparam x_cal1 = 300;
localparam y_cal0 = 20;
localparam y_cal1 = 220;

//reg [11:0] x_touch_temp;
//reg [11:0] y_touch_temp;
//
//always @ (posedge clk) begin
//	if (active) begin
//		if (x_touch_temp != x_touch || y_touch_temp != y_touch) begin // Only change if touch values change
//			
//		end
//		else begin
//			x_touch_temp <= x_touch;
//			y_touch_temp <= y_touch;
//		end
//	end
//end

localparam NUM_SQUARES = 4;

logic [NUM_SQUARES-1:0] isSqSet;
logic [NUM_SQUARES-1:0][2:0] sqCol;

SQUARE_STATE #(.x(x_cal0), .y(y_cal0), .length(5), .border(0)) cali_sq0 (x_pixel, y_pixel, {3'b010}, isSqSet[0], sqCol[0]);
SQUARE_STATE #(.x(x_cal0), .y(y_cal1), .length(5), .border(0)) cali_sq1 (x_pixel, y_pixel, {3'b010}, isSqSet[1], sqCol[1]);
SQUARE_STATE #(.x(x_cal1), .y(y_cal0), .length(5), .border(0)) cali_sq2 (x_pixel, y_pixel, {3'b010}, isSqSet[2], sqCol[2]);
SQUARE_STATE #(.x(x_cal1), .y(y_cal1), .length(5), .border(0)) cali_sq3 (x_pixel, y_pixel, {3'b010}, isSqSet[3], sqCol[3]);

logic[15:0] currentColour;
logic[2:0] colours;
//logic setPixel;
always_comb begin
	currentColour = 16'b0;
	colours = 3'b0;
	//setPixel = 1'b0;
	for (int i = 0; i < NUM_SQUARES; i = i + 1) begin
		colours |= sqCol[i];
		//setPixel |= isSqSet[i];
	end
	case (colours)
		3'b000: begin
			currentColour = 16'h0000; // Black
		end
		
		3'b010: begin
			currentColour = 16'h07E0; // Green
		end
		
		3'b011: begin
			currentColour = 16'h001F; // Blue
		end
		
		3'b100: begin
			currentColour = 16'hF800; // Red
		end
		
		3'b101: begin
			currentColour = 16'hFC0A; // Orange
		end
		
		3'b111: begin
			currentColour = 16'hFFFF; // White
		end
		
		3'b110: begin
			currentColour = 16'hDC05; // Yellow
		end
		
		default: begin
			currentColour = 16'h0000; // Black
		end
	endcase
end

assign currentPixel_calibration = (isSqSet ? currentColour : 16'hFFFF);

endmodule
