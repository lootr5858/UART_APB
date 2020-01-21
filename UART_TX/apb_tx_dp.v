/* ----------------------------------------
		!!! TX Control module !!!
	----------------------------------------
	
	Transmit data bits
	
	
*/

module apb_tx_dp
(
	// Inputs:
	input wire			rstn,			// active LOW to reset
	input wire			tx_en,		// signal to transmit data
	input wire [9:0]  bit_cnto,	// # bit transmitted
	input wire 			start_bit,	// signal HIGH for tx start bit
	input wire			end_bit,		// signal HIGH for tx end bit
	input wire [9:0]	data_bit,	// which data bit to tx
	input wire [9:0]  din,
	
	// Outputs:
	output reg tx_out
);


/* ---------
	Data Path
	---------- */	
always @ *
begin
		
	casex ({rstn, tx_en, start_bit, end_bit, data_bit})
	
		{1'b0, 1'bx, 1'bx, 1'bx, 10'bx}: tx_out = 1'b1;	// Reset
		
		{1'b1, 1'b1, 1'b0, 1'b0, 10'd0}: tx_out = din[0]; // Data bit 0
		{1'b1, 1'b1, 1'b0, 1'b0, 10'd1}: tx_out = din[1]; // Data bit 1
		{1'b1, 1'b1, 1'b0, 1'b0, 10'd2}: tx_out = din[2]; // Data bit 2
		{1'b1, 1'b1, 1'b0, 1'b0, 10'd3}: tx_out = din[3]; // Data bit 3
		{1'b1, 1'b1, 1'b0, 1'b0, 10'd4}: tx_out = din[4]; // Data bit 4
		{1'b1, 1'b1, 1'b0, 1'b0, 10'd5}: tx_out = din[5]; // Data bit 5
		{1'b1, 1'b1, 1'b0, 1'b0, 10'd6}: tx_out = din[6]; // Data bit 6
		{1'b1, 1'b1, 1'b0, 1'b0, 10'd7}: tx_out = din[7]; // Data bit 7
		{1'b1, 1'b1, 1'b0, 1'b0, 10'd8}: tx_out = din[8]; // Data bit 8
		{1'b1, 1'b1, 1'b0, 1'b0, 10'd9}: tx_out = din[9]; // Data bit 9
		
		{1'b1, 1'b1, 1'b1, 1'b0, 10'dx}: tx_out = 1'b0; // Start bit
		{1'b1, 1'b1, 1'b0, 1'b1, 10'dx}: tx_out = 1'b1; // End bit
		
		default: tx_out = 1'b1;
		
	endcase

end

endmodule
