module CORNER_TEST (
	input MAX10_CLK1_50,
	
	output o_cs,
	output o_dcrs,
	output o_sdi,
	output o_sck,
	output o_lcdrst,
	
	input t_sdo,
	input t_irq,
	output t_sdi,
	output t_sck,
	output t_cs,
	
	input [9:0] switches,
	output reg [5:0] leds,
	input rst_n,
	
	output c_SCL,
	inout wire c_SDATA,
	input c_VSYNC_noisy,
	input c_HREF,
	input c_PCLK,
	output c_XCLK,
	input [7:0] c_DOUT,
	output c_RST,
	output c_PWRN
);

dual_boot u0 (
	.clk_clk       (MAX10_CLK1_50),   // clk.clk
	.reset_reset_n (1'b1) 				 // reset.reset_n
);

// Clock Assignments

wire clk_100MHz;
wire clk_1MHz;
wire clk_800KHz;
wire clk_800KHz_30;
wire clk_25MHz;
wire clk_200MHz;

pll	pll_inst (
	.inclk0 ( MAX10_CLK1_50 ),
	.c0 ( clk_100MHz ),
	.c1 ( clk_1MHz ),
	.c2 ( clk_800KHz ),
	.c3 ( clk_800KHz_30 ),
	.c4 ( clk_200MHz )
	);

assign clk_25MHz = internal_xclk;
reg internal_xclk = 1'b0;

always @ (posedge MAX10_CLK1_50) begin
	internal_xclk = ~internal_xclk;
end

logic [15:0] window5x5 [24:0] = '{
    16'h0011, 16'h0022, 16'h0033, 16'h0044, 16'h0055,
    16'h0066, 16'h0077, 16'h0088, 16'h0099, 16'h00AA,
    16'h00BB, 16'h00CC, 16'h00DD, 16'h00EE, 16'h00FF,
    16'h0111, 16'h0222, 16'h0333, 16'h0444, 16'h0555,
    16'h0666, 16'h0777, 16'h0888, 16'h0999, 16'h0AAA
};

logic signed [8:0] random_numbers [15:0] = '{
    9'shF88,  // -120
    9'sh055,  //  85
    9'shF38,  // -200
    9'sh02D,  //  45
    9'sh07F,  //  127
    9'shFDD,  // -35
    9'sh0BE,  //  190
    9'shFA7,  // -89
    9'sh0FA,  //  250
    9'shF01,  // -255
    9'sh040,  //  64
    9'shFF6,  // -10
    9'shF9D,  // -99
    9'sh025,  //  37
    9'shF26,  // -222
    9'sh058   //  88
};

logic [1:0] mode;

always_ff @ (posedge MAX10_CLK1_50) begin
	mode = mode + 1'b1;
	case (mode)
		2'b00: begin
			dataa_sig = random_numbers[0];
			datab_sig = random_numbers[1];
			
			/*window3x3 =  '{16'h001F, 16'h0000, 16'h0000, 
								16'h001F, 16'h0000, 16'h0000, 
								16'h001F, 16'h0000, 16'h0000};*/
		end
		
		2'b01: begin
			dataa_sig = random_numbers[2];
			datab_sig = random_numbers[3];
			
			/*window3x3 = '{16'h1111, 16'h1222, 16'h1333, 16'h1444, 16'h1555,
      16'h1666, 16'h1777, 16'h1888, 16'h1999};*/
		end
		
		2'b10: begin
			dataa_sig = random_numbers[4];
			datab_sig = random_numbers[5];
			
			/*window3x3 = '{16'h4222, 16'h4333, 16'h4444, 16'h4555,
      16'h4666, 16'h4777, 16'h4888, 16'h4999, 16'h4AAA};*/
		end
		
		2'b11: begin
			dataa_sig = random_numbers[6];
			datab_sig = random_numbers[7];
			
			/*window3x3 = '{16'hA555, 16'hB444, 16'hC333, 16'hD222, 16'hE111,
      16'hF000, 16'h0F00, 16'h00F0, 16'h000F};*/
		end
	endcase
end

logic [8:0] dataa_sig;
logic [8:0] datab_sig;
logic [17:0] result_sig;

mult_9x9_signed	mult_9x9_signed_inst (
	.dataa ( dataa_sig ),
	.datab ( datab_sig ),
	.result ( result_sig )
	);
	
logic [15:0] window3x3 [8:0] = '{16'h0000, 16'h0000, 16'hFFFF, 
											16'h0000, 16'h0000, 16'hFFFF, 
											16'h0000, 16'h0000, 16'hFFFF};
	 
wire signed [8:0] grad_X_r;
wire signed [8:0] grad_X_g;	 
wire signed [8:0] grad_X_b;	 
wire signed [8:0] grad_Y_r;	 
wire signed [8:0] grad_Y_g;	 
wire signed [8:0] grad_Y_b;	

SOBEL_FILTER_RGB565_V2 sobel (
	window3x3,
	grad_X_r,
	grad_X_g,
	grad_X_b,

	grad_Y_r,
	grad_Y_g,
	grad_Y_b
);

/*
logic [3:0] mode;

always_ff @ (posedge MAX10_CLK1_50) begin
	mode = mode + 1'b1;
	case (mode)
		4'b0000: begin
			window5x5 = '{
								16'h0011, 16'h0022, 16'h0033, 16'h0044, 16'h0055,
								16'h0066, 16'h0077, 16'h0088, 16'h0099, 16'h00AA,
								16'h00BB, 16'h00CC, 16'h00DD, 16'h00EE, 16'h00FF,
								16'h0111, 16'h0222, 16'h0333, 16'h0444, 16'h0555,
								16'h0666, 16'h0777, 16'h0888, 16'h0999, 16'h0AAA
							 };
		end
		
		4'b0001: begin
			window5x5 = '{16'h0011, 16'h0022, 16'h0033, 16'h0044, 16'h0055,
								16'h0066, 16'h0077, 16'h0088, 16'h0099, 16'h00AA,
								16'h00BB, 16'h00CC, 16'h00DD, 16'h00EE, 16'h00FF,
								16'h0111, 16'h0222, 16'h0333, 16'h0444, 16'h0555,
								16'h0666, 16'h0777, 16'h0888, 16'h0999, 16'h0AAA};
		end
		
		4'b0010: begin
			window5x5 = '{16'h1111, 16'h1222, 16'h1333, 16'h1444, 16'h1555,
      16'h1666, 16'h1777, 16'h1888, 16'h1999, 16'h1AAA,
      16'h1BBB, 16'h1CCC, 16'h1DDD, 16'h1EEE, 16'h1FFF,
      16'h2111, 16'h2222, 16'h2333, 16'h2444, 16'h2555,
      16'h2666, 16'h2777, 16'h2888, 16'h2999, 16'h2AAA};
		end
		
		4'b0011: begin
			window5x5 = '{16'h3210, 16'h3321, 16'h3432, 16'h3543, 16'h3654,
      16'h3765, 16'h3876, 16'h3987, 16'h3A98, 16'h3BA9,
      16'h3CBA, 16'h3DCB, 16'h3EDC, 16'h3FED, 16'h3FFE,
      16'h4111, 16'h4222, 16'h4333, 16'h4444, 16'h4555,
      16'h4666, 16'h4777, 16'h4888, 16'h4999, 16'h4AAA};
		end
		
		4'b0100: begin
			window5x5 = '{16'hAAAA, 16'hBBBB, 16'hCCCC, 16'hDDDD, 16'hEEEE,
      16'hFFFF, 16'h0001, 16'h0002, 16'h0003, 16'h0004,
      16'h0005, 16'h0006, 16'h0007, 16'h0008, 16'h0009,
      16'h100A, 16'h200B, 16'h300C, 16'h400D, 16'h500E,
      16'h600F, 16'h7010, 16'h8011, 16'h9012, 16'hA013};
		end
		
		4'b0101: begin
			window5x5 =  '{16'h0246, 16'h1357, 16'h2468, 16'h3579, 16'h468A,
      16'h579B, 16'h68AC, 16'h79BD, 16'h8ACE, 16'h9BDF,
      16'hACF0, 16'hBDF1, 16'hCEF2, 16'hDF03, 16'hE014,
      16'hF125, 16'h0236, 16'h1347, 16'h2458, 16'h3569,
      16'h467A, 16'h578B, 16'h689C, 16'h79AD, 16'h8ABE};
		end
		
		4'b0110: begin
			window5x5 = '{16'h0000, 16'h1111, 16'h2222, 16'h3333, 16'h4444,
      16'h5555, 16'h6666, 16'h7777, 16'h8888, 16'h9999,
      16'hAAAA, 16'hBBBB, 16'hCCCC, 16'hDDDD, 16'hEEEE,
      16'hFFFF, 16'h000F, 16'h00F0, 16'h0F00, 16'hF000,
      16'h1234, 16'h5678, 16'h9ABC, 16'hDEF0, 16'h1357};
		end
		
		4'b0111: begin
			window5x5 = '{16'h0FFF, 16'h1EEE, 16'h2DDD, 16'h3CCC, 16'h4BBB,
      16'h5AAA, 16'h6999, 16'h7888, 16'h8777, 16'h9666,
      16'hA555, 16'hB444, 16'hC333, 16'hD222, 16'hE111,
      16'hF000, 16'h0F00, 16'h00F0, 16'h000F, 16'h1110,
      16'h2221, 16'h3332, 16'h4443, 16'h5554, 16'h6665};
		end
		
		4'b1000: begin
			window5x5 = '{16'hFACE, 16'hBEEF, 16'hDEAD, 16'hCAFE, 16'hF00D,
      16'hFEED, 16'hBABE, 16'hC001, 16'hD00D, 16'hABCD,
      16'hDCBA, 16'h1001, 16'h2002, 16'h3003, 16'h4004,
      16'h5005, 16'h6006, 16'h7007, 16'h8008, 16'h9009,
      16'hA00A, 16'hB00B, 16'hC00C, 16'hD00D, 16'hE00E};
		end
		
		4'b1001: begin
			window5x5 = '{16'hFFFF, 16'hEEEE, 16'hDDDD, 16'hCCCC, 16'hBBBB,
      16'hAAAA, 16'h9999, 16'h8888, 16'h7777, 16'h6666,
      16'h5555, 16'h4444, 16'h3333, 16'h2222, 16'h1111,
      16'h0000, 16'h0011, 16'h0022, 16'h0033, 16'h0044,
      16'h0055, 16'h0066, 16'h0077, 16'h0088, 16'h0099};
		end
		
		4'b1010: begin
			window5x5 = '{16'h1234, 16'h2345, 16'h3456, 16'h4567, 16'h5678,
      16'h6789, 16'h789A, 16'h89AB, 16'h9ABC, 16'hABCD,
      16'hBCDE, 16'hCDEF, 16'hDEF0, 16'hEF01, 16'hF012,
      16'h0123, 16'h1234, 16'h2345, 16'h3456, 16'h4567,
      16'h5678, 16'h6789, 16'h789A, 16'h89AB, 16'h9ABC};
		end
		
		4'b1011: begin
			window5x5 =  '{16'h2468, 16'h3579, 16'h468A, 16'h579B, 16'h68AC,
      16'h79BD, 16'h8ACE, 16'h9BDF, 16'hACF0, 16'hBDF1,
      16'hCEF2, 16'hDF03, 16'hE014, 16'hF125, 16'h0236,
      16'h1347, 16'h2458, 16'h3569, 16'h467A, 16'h578B,
      16'h689C, 16'h79AD, 16'h8ABE, 16'h9ACD, 16'hABDE};
		end
		
		4'b1100: begin
			window5x5 = '{16'h1357, 16'h2468, 16'h3579, 16'h468A, 16'h579B,
      16'h68AC, 16'h79BD, 16'h8ACE, 16'h9BDF, 16'hACF0,
      16'hBDF1, 16'hCEF2, 16'hDF03, 16'hE014, 16'hF125,
      16'h1023, 16'h2134, 16'h3245, 16'h4356, 16'h5467,
      16'h6578, 16'h7689, 16'h879A, 16'h98AB, 16'hA9BC};
		end
		
		4'b1101: begin
			window5x5 = '{16'hAAAA, 16'hBBBB, 16'hCCCC, 16'hDDDD, 16'hEEEE,
      16'hFFFF, 16'hEEEE, 16'hDDDD, 16'hCCCC, 16'hBBBB,
      16'hAAAA, 16'h9999, 16'h8888, 16'h7777, 16'h6666,
      16'h5555, 16'h4444, 16'h3333, 16'h2222, 16'h1111,
      16'h0000, 16'h1111, 16'h2222, 16'h3333, 16'h4444};

		end
		
		4'b1110: begin
			window5x5 = '{16'hF000, 16'hE111, 16'hD222, 16'hC333, 16'hB444,
      16'hA555, 16'h9666, 16'h8777, 16'h7888, 16'h6999,
      16'h5AAA, 16'h4BBB, 16'h3CCC, 16'h2DDD, 16'h1EEE,
      16'h0FFF, 16'h1ABC, 16'h2BCD, 16'h3CDE, 16'h4DEF,
      16'h5E01, 16'h6F12, 16'h7013, 16'h8124, 16'h9235};
		end
		
		4'b1111: begin
			window5x5 = '{16'h0246, 16'h1357, 16'h2468, 16'h3579, 16'h468A,
      16'h579B, 16'h68AC, 16'h79BD, 16'h8ACE, 16'h9BDF,
      16'hACF0, 16'hBDF1, 16'hCEF2, 16'hDF03, 16'hE014,
      16'hF125, 16'h0236, 16'h1347, 16'h2458, 16'h3569,
      16'h467A, 16'h578B, 16'h689C, 16'h79AD, 16'h8ABE};
		end
		
	endcase
end

wire isCorner;
wire [15:0] corner_pixel;

HARRIS_CORNER_DETECTOR_V2 test (
	.window5x5(window5x5),
	.isCorner(isCorner),
	.pixel(corner_pixel)
);
*/

endmodule
