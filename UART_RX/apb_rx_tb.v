/* 
	----------------------------------------
			!!! UART APB RX Testbench !!!
	----------------------------------------
	
*/

module apb_rx_tb();

/* -------------------
	Essential variables
	------------------- */
localparam period = 5;
localparam cycle = period * 2;
	
reg clk;
reg rstn;
reg sel;
reg mode;

reg [19:0] baud;


/* ---------------
	apb RX variables
	--------------- */
// Inputs:
reg rx_en;	// set DUTY & PERIOD. enable PWM
reg rx_in;		// input data for transmission

// Outputs:
wire [31:0] rx_data;


/* ---------------------
	test module instances
	--------------------- */
apb_rx rx
(
	// Inputs:
	.clk	 (clk),
	.rstn	 (rstn),
	.sel	 (sel),
	.rx_en (rx_en),
	.mode	 (mode),
	.baud	 (baud),
	.rx_in (rx_in),
	
	// Outputs:
	.rx_data (rx_data)
);


/* ----------------
	Clock Generation
	---------------- */
initial clk <= 1'b1;
always #(period) clk <= ~clk;


/* -------------
	Reset Control
	------------- */
initial
begin
	
	rstn  <= 1'b0;
	sel   <= 1'b0;
	rx_en <= 1'b0;
	mode  <= 1'b0;
	
	#(cycle * 2)
	
	rstn <= 1'b1;

end


/* ----------
	Simulation
	---------- */
initial
begin

	#(cycle * 2)
	
	/* --- Cycle 1 ---
		Bauddiv = 16
		Mode	  = 8 bit
		Din	  = 10'b00_0011_0101
	*/
	sel  <= 1'b1;
	mode <= 1'b0;
	baud <= 20'd16;
	din <= 10'b00_0011_0101;
	
	#(cycle)
	
	sel <= 1'b0;
	
	#(cycle)
	// Start TX & RX
	sel 	<= 1'b1;
	set 	<= 1'b1;
	rx_en <= 1'b1;
	
	#(cycle * 160)
	
	// Stop TX & RX
	sel 	<= 1'b0;
	set 	<= 1'b0;
	rx_en <= 1'b0;
	din 	<= 10'bx;
	baud 	<= 20'bx;
	
	/* --- End of Cycle 1 --- */	
	
	#(cycle * 10)
	
	/* --- Cycle 2 ---
		Bauddiv = 20
		Mode	  = 10 bit
		Din	  = 10'b11000_01010
	*/
	
	sel  <= 1'b1;
	mode <= 1'b1;
	baud <= 20'd20;
	din <= 10'b11000_01010;
	
	#(cycle)
	
	sel <= 1'b0;
	
	#(cycle)
	
	// Start Tx & RX
	sel 	<= 1'b1;
	set 	<= 1'b1;
	rx_en <= 1'b1;
	
	#(cycle * 240)
	
	// Stop TX & RX
	sel <= 1'b0;
	set <= 1'b0;
	din <= 10'bx;
	baud <= 20'bx;
	
	/* --- End of Cycle 2 --- */	
	
	#(cycle * 10)
	
	$finish();

end

endmodule
