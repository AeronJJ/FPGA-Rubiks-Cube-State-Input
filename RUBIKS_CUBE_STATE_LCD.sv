module RUBIKS_CUBE_STATE_LCD(
	input[143:0] cube_state, // 144 bits describing current state of the Rubik's Cube
	input[8:0] x, // Current pixel position
	input[7:0] y,
	output[15:0] current_pixel // 16 bit colour of current pixel.
);

localparam NUM_SQUARES = 54;

logic [NUM_SQUARES-1:0] isSqSet;
logic [NUM_SQUARES-1:0][2:0] sqCol;

// Square instantiations, hardcoded coordinates and array indexes, generated with accompanying python script
SQUARE_STATE #(.x(82),  .y(3))   sq0  (x, y, cube_state[143:141], isSqSet[0],  sqCol[0]);
SQUARE_STATE #(.x(108), .y(3))   sq1  (x, y, cube_state[140:138], isSqSet[1],  sqCol[1]);
SQUARE_STATE #(.x(134), .y(3))   sq2  (x, y, cube_state[137:135], isSqSet[2],  sqCol[2]);
SQUARE_STATE #(.x(82),  .y(29))  sq3  (x, y, cube_state[134:132], isSqSet[3],  sqCol[3]);
SQUARE_STATE #(.x(108), .y(29))  sq4  (x, y, {3'b100},            isSqSet[4],  sqCol[4]);
SQUARE_STATE #(.x(134), .y(29))  sq5  (x, y, cube_state[131:129], isSqSet[5],  sqCol[5]);
SQUARE_STATE #(.x(82),  .y(55))  sq6  (x, y, cube_state[128:126], isSqSet[6],  sqCol[6]);
SQUARE_STATE #(.x(108), .y(55))  sq7  (x, y, cube_state[125:123], isSqSet[7],  sqCol[7]);
SQUARE_STATE #(.x(134), .y(55))  sq8  (x, y, cube_state[122:120], isSqSet[8],  sqCol[8]);
SQUARE_STATE #(.x(4),   .y(81))  sq9  (x, y, cube_state[47:45],   isSqSet[9],  sqCol[9]);
SQUARE_STATE #(.x(30),  .y(81))  sq10 (x, y, cube_state[44:42],   isSqSet[10], sqCol[10]);
SQUARE_STATE #(.x(56),  .y(81))  sq11 (x, y, cube_state[41:39],   isSqSet[11], sqCol[11]);
SQUARE_STATE #(.x(82),  .y(81))  sq12 (x, y, cube_state[95:93],   isSqSet[12], sqCol[12]);
SQUARE_STATE #(.x(108), .y(81))  sq13 (x, y, cube_state[92:90],   isSqSet[13], sqCol[13]);
SQUARE_STATE #(.x(134), .y(81))  sq14 (x, y, cube_state[89:87],   isSqSet[14], sqCol[14]);
SQUARE_STATE #(.x(160), .y(81))  sq15 (x, y, cube_state[119:117], isSqSet[15], sqCol[15]);
SQUARE_STATE #(.x(186), .y(81))  sq16 (x, y, cube_state[116:114], isSqSet[16], sqCol[16]);
SQUARE_STATE #(.x(212), .y(81))  sq17 (x, y, cube_state[113:111], isSqSet[17], sqCol[17]);
SQUARE_STATE #(.x(238), .y(81))  sq18 (x, y, cube_state[23:21],   isSqSet[18], sqCol[18]);
SQUARE_STATE #(.x(264), .y(81))  sq19 (x, y, cube_state[20:18],   isSqSet[19], sqCol[19]);
SQUARE_STATE #(.x(290), .y(81))  sq20 (x, y, cube_state[17:15],   isSqSet[20], sqCol[20]);
SQUARE_STATE #(.x(4),   .y(107)) sq21 (x, y, cube_state[38:36],   isSqSet[21], sqCol[21]);
SQUARE_STATE #(.x(30),  .y(107)) sq22 (x, y, {3'b010},            isSqSet[22], sqCol[22]);
SQUARE_STATE #(.x(56),  .y(107)) sq23 (x, y, cube_state[35:33],   isSqSet[23], sqCol[23]);
SQUARE_STATE #(.x(82),  .y(107)) sq24 (x, y, cube_state[86:84],   isSqSet[24], sqCol[24]);
SQUARE_STATE #(.x(108), .y(107)) sq25 (x, y, {3'b111},            isSqSet[25], sqCol[25]);
SQUARE_STATE #(.x(134), .y(107)) sq26 (x, y, cube_state[83:81],   isSqSet[26], sqCol[26]);
SQUARE_STATE #(.x(160), .y(107)) sq27 (x, y, cube_state[110:108], isSqSet[27], sqCol[27]);
SQUARE_STATE #(.x(186), .y(107)) sq28 (x, y, {3'b011},            isSqSet[28], sqCol[28]);
SQUARE_STATE #(.x(212), .y(107)) sq29 (x, y, cube_state[107:105], isSqSet[29], sqCol[29]);
SQUARE_STATE #(.x(238), .y(107)) sq30 (x, y, cube_state[14:12],   isSqSet[30], sqCol[30]);
SQUARE_STATE #(.x(264), .y(107)) sq31 (x, y, {3'b110},            isSqSet[31], sqCol[31]);
SQUARE_STATE #(.x(290), .y(107)) sq32 (x, y, cube_state[11:9],    isSqSet[32], sqCol[32]);
SQUARE_STATE #(.x(4),   .y(133)) sq33 (x, y, cube_state[32:30],   isSqSet[33], sqCol[33]);
SQUARE_STATE #(.x(30),  .y(133)) sq34 (x, y, cube_state[29:27],   isSqSet[34], sqCol[34]);
SQUARE_STATE #(.x(56),  .y(133)) sq35 (x, y, cube_state[26:24],   isSqSet[35], sqCol[35]);
SQUARE_STATE #(.x(82),  .y(133)) sq36 (x, y, cube_state[80:78],   isSqSet[36], sqCol[36]);
SQUARE_STATE #(.x(108), .y(133)) sq37 (x, y, cube_state[77:75],   isSqSet[37], sqCol[37]);
SQUARE_STATE #(.x(134), .y(133)) sq38 (x, y, cube_state[74:72],   isSqSet[38], sqCol[38]);
SQUARE_STATE #(.x(160), .y(133)) sq39 (x, y, cube_state[104:102], isSqSet[39], sqCol[39]);
SQUARE_STATE #(.x(186), .y(133)) sq40 (x, y, cube_state[101:99],  isSqSet[40], sqCol[40]);
SQUARE_STATE #(.x(212), .y(133)) sq41 (x, y, cube_state[98:96],   isSqSet[41], sqCol[41]);
SQUARE_STATE #(.x(238), .y(133)) sq42 (x, y, cube_state[8:6],     isSqSet[42], sqCol[42]);
SQUARE_STATE #(.x(264), .y(133)) sq43 (x, y, cube_state[5:3],     isSqSet[43], sqCol[43]);
SQUARE_STATE #(.x(290), .y(133)) sq44 (x, y, cube_state[2:0],     isSqSet[44], sqCol[44]);
SQUARE_STATE #(.x(82),  .y(159)) sq45 (x, y, cube_state[71:69],   isSqSet[45], sqCol[45]);
SQUARE_STATE #(.x(108), .y(159)) sq46 (x, y, cube_state[68:66],   isSqSet[46], sqCol[46]);
SQUARE_STATE #(.x(134), .y(159)) sq47 (x, y, cube_state[65:63],   isSqSet[47], sqCol[47]);
SQUARE_STATE #(.x(82),  .y(185)) sq48 (x, y, cube_state[62:60],   isSqSet[48], sqCol[48]);
SQUARE_STATE #(.x(108), .y(185)) sq49 (x, y, {3'b101},            isSqSet[49], sqCol[49]);
SQUARE_STATE #(.x(134), .y(185)) sq50 (x, y, cube_state[59:57],   isSqSet[50], sqCol[50]);
SQUARE_STATE #(.x(82),  .y(211)) sq51 (x, y, cube_state[56:54],   isSqSet[51], sqCol[51]);
SQUARE_STATE #(.x(108), .y(211)) sq52 (x, y, cube_state[53:51],   isSqSet[52], sqCol[52]);
SQUARE_STATE #(.x(134), .y(211)) sq53 (x, y, cube_state[50:48],   isSqSet[53], sqCol[53]);


reg[15:0] currentColour;
reg[2:0] colours;

always_comb begin
	//currentColour = 16'b0;
	colours = 3'b0;
	for (int i = 0; i < NUM_SQUARES; i = i + 1) begin
		// OR all square colours together
		colours |= sqCol[i]; // This assumes that none of the squares are overlapping and only one square module with output a colour thats not 3'b000
	end
	case (colours)
		3'b000: begin
			currentColour = 16'h0000; // Black
		end
		
		3'b010: begin
//			currentColour = 16'h001F; // Blue
//			currentColour = 16'h07E0; // Green - Working, dim

			//currentColour = 16'h00F8; // Green - BRIGHT // BGR && FLIPPED
			
			currentColour = 16'h07E0;
		end
		
		3'b011: begin
//			currentColour = 16'h07E0; // Green
//			currentColour = 16'h001F; // Blue - Working, dim
			
			//currentColour = 16'hE007; // Blue - BRIGHT // BGR && FLIPPED
			
			currentColour = 16'h001F;
end
		
		3'b100: begin
//			currentColour = 16'hF800; // Red - Working, dim

//			currentColour = 16'h1F00; // RED - BRIGHT
			
			//currentColour = 16'h1F00; // BGR && FLIPPED
			
			currentColour = 16'hF800;
		end
		
		3'b101: begin
//			currentColour = 16'hFC0A; // Orange - Working, dim
			
			//currentColour = 16'hFF03; 
			
			//currentColour = 16'h7F45; // BGR && FLIPPED
			
			currentColour = 16'hFD68;
		end
		
		3'b111: begin
			currentColour = 16'hFFFF; // White
		end
		
		3'b110: begin
//			currentColour = 16'hDC05; // Yellow - Working, dim
			
			//currentColour = 16'hFFC0; // Yellow
			
			//currentColour = 16'hDF07; // BGR && FLIPPED
			
			currentColour = 16'hFFC0;
		end
		
		default: begin
			currentColour = 16'h0000; // Black
		end
	endcase
end

assign current_pixel = (isSqSet ? currentColour : 16'hFFFF); // If the current pixel is within any of the squares, set the pixel colour to the colour of the square.

endmodule



