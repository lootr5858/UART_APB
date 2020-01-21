/*
	!!! --- Baudrate Generation module --- !!!
	
	Generate baudrateby bauddiv * clck
	Internal clock for TX/RX bits
*/

module baud_counter
(
	input wire			rstn,
	input wire			en,
	input wire [19:0] baud,
	input wire [19:0] baud_cnto,
	
	output reg [19:0] baud_cntn,
	output reg			baud_clk
);

wire reached;
wire valid_baud;

assign valid_baud = (baud >= 20'd16) ? 1'b1 : 1'b0;
assign reached = (baud_cnto == baud - 20'd1) ? 1'b1 : 1'b0;

always @ *
begin

	casex({rstn, en, valid_baud, reached})
	
		{1'b0, 1'bx, 1'bx, 1'bx}: begin
												baud_cntn = 20'b0;
												baud_clk  = 1'b0;
										  end
		
		{1'b1, 1'b0, 1'bx, 1'bx}: begin
												baud_cntn = 20'b0;
												baud_clk  = 1'b0;
										  end
										  
		{1'b1, 1'b1, 1'b0, 1'bx}: begin
												baud_cntn = 20'b0;
												baud_clk  = 1'b0;
										  end
										  
		{1'b1, 1'b1, 1'b1, 1'b0}: begin
												baud_cntn = baud_cnto + 20'b1;
												baud_clk  = 1'b0;
										  end
										  
		{1'b1, 1'b1, 1'b1, 1'b1}: begin
												baud_cntn = 20'b0;
												baud_clk  = 1'b1;
										  end

	endcase

end

endmodule
