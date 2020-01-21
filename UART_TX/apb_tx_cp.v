/* ----------------------------------------
		!!! TX Control module !!!
	----------------------------------------
	
	Determine data bit for transmission
	
*/

module apb_tx_cp
(
	// Inputs:
	input wire			rstn,			// active LOW to reset
	input wire			sel,			// activate apb_tx module
	input wire			set,			// set DUTY & PERIOD. enable PWM
	input wire			baud_clk,	// signal to transmit next bit
	input wire [9:0]  bit_cnto,	// # bit transmitted
	input wire			mode,			// switch between 8 bit & 10 bit tx
	
	// Outputs:
	output reg [9:0] bit_cntn,		// index of bit transmitting now
	output reg		  tx_en,			// signal HIGH to tx data
	output wire		  start_bit,	// signal HIGH for tx start bit
	output wire		  end_bit,		// signal HIGH for tx end bit
	output reg [9:0] data_bit		// which data bit to tx
);


/* -------------------
	internal wires/regs
	------------------- */
localparam eight_bit = 9;
localparam ten_bit   = 11;
wire [9:0]  upper_cnt;


/* ----------------
	conditions check
	---------------- */
assign upper_cnt = (mode	  == 1'b1)		 ? ten_bit : eight_bit;
assign start_bit = (bit_cnto == 10'b0)		 ? 1'b1 	  : 1'b0;
assign end_bit	  = (bit_cnto == upper_cnt) ? 1'b1 	  : 1'b0;


/* -------------
	CONTROL Logic
	------------- */
always @ *
begin
	
	casex ({rstn, sel, set, start_bit, end_bit, baud_clk})

		// reset
		{1'b0, 1'bx, 1'bx, 1'bx , 1'bx, 1'bx}: begin
																tx_en 	= 1'b0;
																bit_cntn = 10'b0;
																data_bit = 10'bx;
															end
	
		// Data bit. Current bit
		{1'b1, 1'b1, 1'b1, 1'b0 , 1'b0, 1'b0}: begin
																tx_en 	= 1'b1;
																bit_cntn = bit_cnto;
																data_bit = bit_cnto - 10'b1;
															end
		
		// Data bit. Prep next bit
		{1'b1, 1'b1, 1'b1, 1'b0 , 1'b0, 1'b1}: begin
																tx_en 	= 1'b1;
																bit_cntn = bit_cnto + 10'b1;
																data_bit = bit_cnto - 10'b1;
															end	
		
		// Start bit. Current bit
		{1'b1, 1'b1, 1'b1, 1'b1 , 1'b0, 1'b0}: begin
																tx_en 	= 1'b1;
																bit_cntn = bit_cnto;
																data_bit = 10'bx;
															end
		
		// Start bit. Prep next bit
		{1'b1, 1'b1, 1'b1, 1'b1 , 1'b0, 1'b1}: begin
																tx_en 	= 1'b1;
																bit_cntn = bit_cnto + 10'b1;
																data_bit = 10'bx;
															end					
		
		// End bit. Current bit
		{1'b1, 1'b1, 1'b1, 1'b0 , 1'b1, 1'b0}: begin
																tx_en 	= 1'b1;
																bit_cntn = bit_cnto;
																data_bit = 10'bx;
															end
											
		// End bit. Prep next bit			
		{1'b1, 1'b1, 1'b1, 1'b0 , 1'b1, 1'b1}: begin
																tx_en 	= 1'b1;
																bit_cntn = bit_cnto;
																data_bit = 10'bx;
															end					
		
		default: begin
						tx_en 	= 1'b0;
						bit_cntn = 10'b0;
						data_bit = 10'bx;
					end
	
	endcase

end

endmodule
