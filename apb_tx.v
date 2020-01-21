/* ----------------------------------------
		!!! UART APB TX Top module !!!
	----------------------------------------
	
	Transmit 8/10 bit (depending on mode)
	Transmit bit-by-bit according to baudrate
	
	Control Path:
	
	Data Path:
*/

module apb_tx
(
	// Input:
	input wire			clk,
	input wire			rstn,		// active LOW to reset
	input wire			sel,		// activate apb_tx module
	input wire			set,		// set DUTY & PERIOD. enable PWM
	input wire 			mode,		// switch between 8 bit & 10 bit tx
	input wire [9:0]  din,		// input data for transmission
	input wire [19:0] baud,		// bauddiv
	
	// Output:
	output wire tx_en,	// enable transmission
	output wire tx_out	// transmitted data
);


/* -------------------
	internal wires/regs
	------------------- */
wire rst;	

wire [9:0] 	bit_cnto;
wire [9:0] 	bit_cntn;

wire			start_bit;
wire			end_bit;
wire [9:0]	data_bit;

wire [19:0] baud_cnto;
wire [19:0] baud_cntn;
wire			baud_clk;


/* ---------------------------
	connect CONTROl & DATA path
	--------------------------- */
apb_tx_cp tx_cp
(
	// Inputs:
	.rstn		 (rstn),			// active LOW to reset
	.sel		 (sel),			// activate apb_tx module
	.set		 (set),			// set DUTY & PERIOD. enable PWM
	.baud_clk (baud_clk),	// signal to transmit next bit
	.bit_cnto (bit_cnto),	// # bit transmitted
	.mode		 (mode),			// switch between 8 bit & 10 bit tx
	
	// Outputs:
	.bit_cntn  (bit_cntn),		// index of bit transmitting now
	.tx_en	  (tx_en),			// signal HIGH to tx data
	.start_bit (start_bit),	// signal HIGH for tx start bit
	.end_bit	  (end_bit),		// signal HIGH for tx end bit
	.data_bit  (data_bit)		// which data bit to tx
);

apb_tx_dp tx_dp
(
	// Inputs:
	.rstn		  (rstn),		// active LOW to reset
	.tx_en	  (tx_en),		// signal to transmit data
	.bit_cnto  (bit_cnto),	// # bit transmitted
	.start_bit (start_bit),	// signal HIGH for tx start bit
	.end_bit	  (end_bit),	// signal HIGH for tx end bit
	.data_bit  (data_bit),	// which data bit to tx
	.din		  (din),
	
	// Outputs:
	.tx_out (tx_out)
);

baud_counter baud_counter
(
	// Inputs:
	.rstn		  (rstn),
	.en		  (tx_en),
	.baud 	  (baud),
	.baud_cnto (baud_cnto),
	
	// Outputs:
	.baud_cntn (baud_cntn),
	.baud_clk  (baud_clk)
);


/* ----------------
	connecting wires
	---------------- */ 
assign rst = ~rstn;

PipeReg #(10) bit_cnt
(
	.CLK (clk),
	.RST (rst),
	.EN  (1'b1),
	.D	  (bit_cntn),
	.Q	  (bit_cnto)
);

PipeReg #(20) baud_cnt
(
	.CLK (clk),
	.RST (rst),
	.EN  (1'b1),
	.D	  (baud_cntn),
	.Q	  (baud_cnto)
);

endmodule
