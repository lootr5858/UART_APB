/* ----------------------------------------
		!!! RX Control module !!!
	----------------------------------------
	
	Append received data bit into correct bit in rx_data
	
*/

module apb_rx_cp
(
	// Inputs:
	input wire			rstn,
	input wire			sel,
	input wire			rx_en,
	input wire			mode,
	input wire			baud_clk,
	input wire [9:0]  bit_cnto,
	
	// Outputs:
	output reg  [9:0] bit_cntn,
	output wire			start_bit,
	output wire			end_bit,
	output reg  [9:0] data_bit
);


/* -------------------
	internal wires/regs
	------------------- */
localparam eight_bit = 9;
localparam ten_bit   = 11;
wire [9:0] upper_cnt;	
	
	
/* ----------------
	conditions check
	---------------- */	
assign upper_cnt = (mode		== 1'b1)		 ? ten_bit : eight_bit;
assign start_bit = (bit_cnto == 10'b0)		 ? 1'b1	  : 1'b0;
assign end_bit	  = (bit_cnto == upper_cnt) ? 1'b1	  : 1'b0;


/* -------------
	CONTROL Logic
	------------- */
always @ *
begin
		
		
	casex ({rstn, sel, rx_en, start_bit, end_bit, baud_clk})
		
		// reset
		{1'b0, 1'bx, 1'bx, 1'bx , 1'bx, 1'bx}: begin
																bit_cntn = 10'b0;
																data_bit = 10'bx;
															end
															
		// Data bit. Current bit
		{1'b0, 1'b1, 1'b1, 1'b0 , 1'b0, 1'b0}: begin
																bit_cntn = bit_cnto;
																data_bit = bit_cnto - 10'b1;
															end
															
		// Data bit. Next bit
		{1'b0, 1'b1, 1'b1, 1'b0 , 1'b0, 1'b1}: begin
																bit_cntn = bit_cnto + 10'b1;
																data_bit = bit_cnto - 10'b1;
															end
		
		// Start bit. Current bit
		{1'b0, 1'b1, 1'b1, 1'b1 , 1'b0, 1'b0}: begin
																bit_cntn = bit_cnto;
																data_bit = 10'bx;
															end
															
		// Start bit. Next bit.
		{1'b0, 1'b1, 1'b1, 1'b1 , 1'b0, 1'b1}: begin
																bit_cntn = bit_cnto + 10'b1;
																data_bit = 10'bx;
															end
		
		// End bit. Current bit
		{1'b0, 1'b1, 1'b1, 1'b0 , 1'b1, 1'b0}: begin
																bit_cntn = bit_cnto;
																data_bit = 10'bx;
															end
															
		// End bit. Next bit
		{1'b0, 1'b1, 1'b1, 1'b0 , 1'b1, 1'b1}: begin
																bit_cntn = bit_cnto;
																data_bit = 10'bx;
															end
		
		default: begin
						bit_cntn = 10'b0;
						data_bit = 10'bx;
					end
	
	endcase

end

endmodule	