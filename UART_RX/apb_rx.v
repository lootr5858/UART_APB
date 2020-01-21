/* ----------------------------------------
		!!! UART APB RX Top module !!!
	----------------------------------------
	
	Receive 8/10 bit (depending on mode)
	Receive bit-by-bit according to baudrate
	Receive & store
	
	Control Path:
	
	Data Path:
*/

module apb_rx
(
	// Inputs:
	input wire			clk,
	input wire			rstn,
	input wire			sel,
	input wire			rx_en,
	input wire			mode,
	input wire [19:0] baud,
	input wire			rx_in,
	
	// Outputs:
	output wire [31:0] rx_data
);


/* -------------------
	internal wires/regs
	------------------- */
wire rst;
	
wire [9:0] bit_cnto;
wire [9:0]  bit_cntn;

wire			start_bit;
wire			end_bit;
wire [9:0]	data_bit;

wire [19:0] baud_cnto;
wire [19:0] baud_cntn;
wire		   baud_clk;


/* ---------------------------
	connect CONTROl & DATA path
	--------------------------- */
apb_rx_cp rx_cp
(
	// Inputs:
	.rstn		 (rstn),
	.sel		 (sel),
	.rx_en	 (rx_en),
	.mode		 (mode),
	.baud_clk (baud_clk),
	.bit_cnto (bit_cnto),
	
	// Outputs:
	.bit_cntn	(bit_cntn),
	.start_bit	(start_bit),
	.end_bit		(end_bit),
	.data_bit	(data_bit)
);

apb_rx_dp rx_dp
(
	// Inputs:
	.rstn			(rstn),
	.sel			(sel),
	.rx_en		(rx_en),
	.rx_in		(rx_in),
	.start_bit	(start_bit),
	.end_bit		(end_bit),
	.bit_cnto	(bit_cnto),
	.data_bit	(data_bit),
	
	// Outputs:
	.rx_data	(rx_data)
);

baud_counter baud_counter
(
	// Inputs:
	.rstn		  (rstn),
	.en		  (rx_en),
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
