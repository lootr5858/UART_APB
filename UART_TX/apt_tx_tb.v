/* 
	----------------------------------------
			!!! UART APB TX Testbench !!!
	----------------------------------------
	
*/

module apb_tx_tb();


/* ---------------
	INPUT of apb_tx
	--------------- */
reg			clk;
reg			rstn;		// active LOW to reset
reg			sel;		// activate apb_tx module
reg			set;		// set DUTY & PERIOD. enable PWM
reg 			mode;		// switch between 8 bit & 10 bit tx
reg [9:0]  din;		// input data for transmission
reg [19:0] baud;		// bauddiv


/* ----------------
	OUTPUT of apb_tx
	---------------- */
wire tx_en;
wire tx_out;
	


/* ------------------
	testbench variable
	------------------ */
localparam period = 5;
localparam cycle = period * 2;


/* ---------------------
	test module instances
	--------------------- */
apb_tx tx
(
	// Inputs:
	.clk	(clk),
	.rstn	(rstn),
	.sel	(sel),
	.set	(set),
	.mode	(mode),
	.din	(din),
	.baud (baud),
	
	// Outputs:
	.tx_en  (tx_en),
	.tx_out (tx_out)
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
	sel  <= 1'b0;
	set  <= 1'b0;
	mode <= 1'b0;
	
	#(cycle * 2)
	
	rstn <= 1'b1;

end


/* ----------
	Simulation
	---------- */
initial
begin

	#(cycle * 2)
	
	sel  <= 1'b1;
	mode <= 1'b0;
	baud <= 20'd16;
	din <= 10'b00_0011_0101;
	
	#(cycle)
	
	sel <= 1'b0;
	
	#(cycle)
	
	sel <= 1'b1;
	set <= 1'b1;
	
	#(cycle * 200)
	
	sel <= 1'b0;
	set <= 1'b0;
	din <= 10'bx;
	baud <= 20'bx;
	
	#(cycle)
	
	sel  <= 1'b1;
	mode <= 1'b1;
	baud <= 20'd20;
	din <= 10'b11000_01010;
	
	#(cycle)
	
	sel <= 1'b0;
	
	#(cycle)
	
	sel <= 1'b1;
	set <= 1'b1;
	
	#(cycle * 300)
	
	sel <= 1'b0;
	set <= 1'b0;
	din <= 10'bx;
	baud <= 20'bx;
	
	#(cycle * 10)
	
	$finish();
	
end

endmodule
