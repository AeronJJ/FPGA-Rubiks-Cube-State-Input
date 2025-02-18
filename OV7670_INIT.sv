module OV7670_INIT (
	input clk_800KHz,
	input clk_800KHz_30,
	input rst_n,
	output t_SDA,
	input r_SDA,
	output drive_SDA,
	output c_SCL,
	
	output reg init_done
);

// IO Setup

//


// SCCB Setup
reg [7:0] cam_addr_send;
reg [7:0] cam_data_send;
reg cam_en;

wire cam_ready;
wire cam_busy;
wire cam_ack;

OV7670_SCCB cam (
	clk_800KHz, // 800 KHz maximum
	clk_800KHz_30,
	t_SDA,
	r_SDA,
	drive_SDA,
	c_SCL,	// 400 KHz maximum
	
	cam_addr_send,
	cam_data_send,
	cam_en,
	cam_ready,
	cam_busy,
	cam_ack
);
//


// Init messages
//localparam INIT_SEQ_LEN = 81;
localparam INIT_SEQ_LEN = 78;
reg [6:0] init_index = 7'b0;
//reg [15:0] INIT_SEQ [0:INIT_SEQ_LEN-1] = '{16'h12_80};
reg [15:0] INIT_SEQ [0:INIT_SEQ_LEN-1] = '{
	16'h12_80,  //reset all register to default values
	16'h12_04,  //set output format to RGB
	16'h15_20,  //pclk will not toggle during horizontal blank
	16'h40_d0,	//RGB565

	// These are values scalped from https://github.com/jonlwowski012/OV7670_NEXYS4_Verilog/blob/master/ov7670_registers_verilog.v
	16'h12_04, // COM7,     set RGB color output
	//16'h11_80, // CLKRC     internal PLL matches input clock
	16'h11_C0,
	16'h0C_00, // COM3,     default settings
	16'h3E_00, // COM14,    no scaling, normal pclock
	16'h04_00, // COM1,     disable CCIR656
	16'h40_d0, //COM15,     RGB565, full output range
	16'h3a_04, //TSLB       set correct output data sequence (magic)
	16'h14_18, //COM9       MAX AGC value x4 0001_1000
	16'h4F_B3, //MTX1       all of these are magical matrix coefficients
	16'h50_B3, //MTX2
	16'h51_00, //MTX3
	16'h52_3d, //MTX4
	16'h53_A7, //MTX5
	16'h54_E4, //MTX6
	16'h58_9E, //MTXS
	16'h3D_C0, //COM13      sets gamma enable, does not preserve reserved bits, may be wrong?
	16'h17_14, //HSTART     start high 8 bits
	16'h18_02, //HSTOP      stop high 8 bits //these kill the odd colored line
	16'h32_80, //HREF       edge offset
	16'h19_03, //VSTART     start high 8 bits
	16'h1A_7B, //VSTOP      stop high 8 bits
	16'h03_0A, //VREF       vsync edge offset
	16'h0F_41, //COM6       reset timings
	16'h1E_00, //MVFP       disable mirror / flip //might have magic value of 03
	//16'h1E_03, //MVFP       disable mirror / flip //might have magic value of 03
	16'h33_0B, //CHLF       //magic value from the internet
	16'h3C_78, //COM12      no HREF when VSYNC low
	16'h69_00, //GFIX       fix gain control
	16'h74_00, //REG74      Digital gain control
	16'hB0_84, //RSVD       magic value from the internet *required* for good color
	16'hB1_0c, //ABLC1
	16'hB2_0e, //RSVD       more magic internet values
	16'hB3_80, //THL_ST
	//begin mystery scaling numbers
	16'h70_3a,
	16'h71_35,
	16'h72_11,
	16'h73_f0,
	16'ha2_02,
	//gamma curve values
	16'h7a_20,
	16'h7b_10,
	16'h7c_1e,
	16'h7d_35,
	16'h7e_5a,
	16'h7f_69,
	16'h80_76,
	16'h81_80,
	16'h82_88,
	16'h83_8f,
	16'h84_96,
	16'h85_a3,
	16'h86_af,
	16'h87_c4,
	16'h88_d7,
	16'h89_e8,
	//AGC and AEC
	16'h13_e0, //COM8, disable AGC / AEC
	16'h00_00, //set gain reg to 0 for AGC
	16'h10_00, //set ARCJ reg to 0
	16'h0d_40, //magic reserved bit for COM4
	16'h14_18, //COM9, 4x gain + magic bit
	16'ha5_05, // BD50MAX
	16'hab_07, //DB60MAX
	16'h24_95, //AGC upper limit
	16'h25_33, //AGC lower limit
	16'h26_e3, //AGC/AEC fast mode op region
	16'h9f_78, //HAECC1
	16'ha0_68, //HAECC2
	16'ha1_03, //magic
	16'ha6_d8, //HAECC3
	16'ha7_d8, //HAECC4
	16'ha8_f0, //HAECC5
	16'ha9_90, //HAECC6
	16'haa_94, //HAECC7
	16'h13_e5, //COM8, enable AGC / AEC
	16'h1E_23, //Mirror Image
	16'h69_06  //gain of RGB(manually adjusted)
	/*,
	16'h12_80,
	16'h70_B5,
	16'h71_3A*/
};
//


// Misc
reg [23:0] delay_left = 24'b0;
//


// State Machine Setup
localparam s_IDLE 			= 3'b000;
localparam s_START_DELAY 	= 3'b001;
localparam s_START			= 3'b010;
localparam s_SET_REGISTER  = 3'b011;
localparam s_WAIT				= 3'b100;
localparam s_DONE				= 3'b101;
localparam s_INIT_DONE		= 3'b110;

reg [2:0] current_state = s_IDLE;
reg [2:0] next_state = s_IDLE;
//


// State Machine

always @ (posedge clk_800KHz or negedge rst_n) begin
	if (~rst_n) begin
		current_state <= s_IDLE;	
		cam_en <= 1'b0;
		init_index <= 7'b0;
		init_done <= 1'b0;
		delay_left <= 24'd0;
		cam_addr_send <= 8'b0;
		cam_data_send <= 8'b0;
	end
	else if (delay_left > 24'b0) begin
		delay_left <= delay_left - 1'b1; // Wait for delay to count down
	end
	else begin
		current_state <= next_state;
		case (current_state)
			s_IDLE: begin
				cam_en <= 1'b0;
				init_index <= 7'b0;
			end
			
			s_START_DELAY: begin
				delay_left <= 24'd536000; // Wait for camera to start-up ~0.67s
				//delay_left <= 24'd10; // Testbench
			end
		
			s_START: begin
				
			end
						
			s_SET_REGISTER: begin
				cam_addr_send <= INIT_SEQ[init_index][15:8];
				cam_data_send <= INIT_SEQ[init_index][7:0];
				init_index <= init_index + 1'b1;
				cam_en <= 1'b1;
			end
			
			s_WAIT: begin
				
			end
			
			s_DONE: begin
				cam_en <= 1'b0;
			end
			
			s_INIT_DONE: begin
				init_done <= 1'b1;
			end
			
		endcase
	end
end

always @ (*) begin
	next_state = current_state;
	case (current_state)
		s_IDLE: begin
			if (~init_done) begin
				next_state = s_START_DELAY;
			end
		end
		
		s_START_DELAY: begin
			if (delay_left == 24'b0) begin
				next_state = s_START;
			end
		end
		
		s_START: begin
			next_state = s_SET_REGISTER;
		end
					
		s_SET_REGISTER: begin
			next_state = s_WAIT;
		end
		
		s_WAIT: begin
			if (init_index == INIT_SEQ_LEN) begin
				next_state = s_DONE;
			end
			else if (cam_ready) begin
				next_state = s_SET_REGISTER;
			end
		end
		
		s_DONE: begin
			if (cam_ready) begin
				next_state = s_INIT_DONE;
			end
		end
		
		s_INIT_DONE: begin
			next_state = s_IDLE;
		end
		
	endcase
end
//



endmodule
