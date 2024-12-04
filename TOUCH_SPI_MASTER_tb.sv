`timescale 10ns / 100ps
module TOUCH_SPI_MASTER_tb;

reg clk_1MHz; // 4MHz maximum, sck will be half this frequency and max spi clk frequency is 2MHz
reg en;
reg [7:0] data_in;
reg i_sdo;
reg i_irq;

wire busy;
wire [15:0] data_out;

wire o_cs;
wire o_sdi;
wire o_sck;
wire data_valid;

TOUCH_SPI_MASTER dut (
	clk_1MHz,
	en,
	data_in,
	i_sdo,
	i_irq,
	busy,
	data_out,
	o_cs,
	o_sdi,
	o_sck,
	data_valid
);

always #5 clk_1MHz = ~clk_1MHz;

initial begin
	clk_1MHz = 1'b1;
	en = 1'b0;
	data_in = 8'b11010000;
	i_sdo = 1'b1;
	i_irq = 1'b0;
	#100;
	en = 1'b1;
	#100;
	en = 1'b0;
	#10000;
	$stop;
end

endmodule
