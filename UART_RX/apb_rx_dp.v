/* ----------------------------------------
		!!! RX Control module !!!
	----------------------------------------
	
	Receive data bits
	
	
*/

module apb_rx_dp
(
	// Inputs:
	input wire			rstn,
	input wire			sel,
	input wire			rx_en,
	input wire			rx_in,
	input wire			start_bit,
	input wire			end_bit,
	input wire [9:0]  bit_cnto,
	input wire [9:0]  data_bit,
	
	// Outputs:
	output reg [31:0] rx_data
);


/* -----------------------
	Internal Data variables
	----------------------- */
	

/* ---------
	Data Path
	---------- */	
always @ *
begin

	casex ({rstn, sel, rx_en, start_bit, end_bit, data_bit})
	
		{1'b0, 1'bx, 1'bx, 1'bx, 1'bx, 10'bx}: rx_data <= 32'bx; // Reset
																
		
		{1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 10'd0}: rx_data[0] <= rx_in; // RX data bit 0
		{1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 10'd1}: rx_data[0] <= rx_in; // RX data bit 1
		{1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 10'd2}: rx_data[0] <= rx_in; // RX data bit 2
		{1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 10'd3}: rx_data[0] <= rx_in; // RX data bit 3
		{1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 10'd4}: rx_data[0] <= rx_in; // RX data bit 4
		{1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 10'd5}: rx_data[0] <= rx_in; // RX data bit 5
		{1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 10'd6}: rx_data[0] <= rx_in; // RX data bit 6
		{1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 10'd7}: rx_data[0] <= rx_in; // RX data bit 7
		{1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 10'd8}: rx_data[0] <= rx_in; // RX data bit 8
		{1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 10'd9}: rx_data[0] <= rx_in; // RX data bit 9
		
		
		{1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 10'bx}: rx_data <= 32'b0;   // Start bit													
		{1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 10'bx}: rx_data <= rx_data; // End bit
		
		default: rx_data = rx_data;
		
	endcase

end

endmodule
