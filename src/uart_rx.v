//-----------------------------------------------
//  UART transmitter
//-----------------------------------------------
module uart_rx #(
	parameter baud_rate = 115200,       // Set value baud rate for work with uart
	parameter freq_clk  = 50_000_000    // Working frequency
)(
	input  clk, rst,
	output [7:0] data_rcv,
	input  rx,                          // Port rx 
	output rx_done                      // Byte receiving is completed
);

//-----------------------------------------------
//  Parameters
//-----------------------------------------------
localparam duration = freq_clk / baud_rate;   // duration [sec] = 1 / baud rate [Hz] = 8,67 us (for baud rate = 115200)

localparam IDLE = 0;
localparam WORK = 1;
localparam STOP = 2;

integer cnt_baud_rate;

reg [7:0] data_rcv_r;
reg [3:0] cnt_rcv_bit;
reg [1:0] state;
reg [1:0] next;
reg [2:0] rx_r_metastab;
reg detect_bit;
reg rx_done_r;
reg rx_r;

//-----------------------------------------------
//  Metastability
//-----------------------------------------------
always @(posedge clk) begin
	rx_r_metastab <= {rx_r_metastab[1:0], rx};
	rx_r 					<= rx_r_metastab[2];
end

//-----------------------------------------------
//  FSM implemented in 3 always block
//-----------------------------------------------
always @(posedge clk or posedge rst) begin
	if (rst) state <= IDLE;
	else     state <= next; 
end 

// Switching of state combination logic
always @(*) begin
	next = 2'bx;
	case (state)
		IDLE : if (detect_bit) next = WORK;
					 else            next = IDLE;
		WORK : if (rx_done_r)  next = IDLE;
					 else            next = WORK;
	endcase
end

always @(posedge clk) begin
	case (state)
		IDLE : begin
			if (rx_r == 1'b0) begin
				detect_bit 		<= 1'b1;
				cnt_baud_rate <= cnt_baud_rate + 32'd1;
			end else begin 
				detect_bit	<= 1'b0;
				cnt_baud_rate <= 32'd0;
			end
			data_rcv_r 		<= 8'd0;
			cnt_rcv_bit 	<= 4'd0;
			rx_done_r 		<= 1'b0;
		end
		WORK : begin
			cnt_baud_rate <= 32'd0;
			if (cnt_baud_rate == duration) begin
				cnt_rcv_bit <= cnt_rcv_bit + 4'd1;
				if ((cnt_rcv_bit == 4'd9)) begin
					rx_done_r <= 1'b1;	// Idle stop bit and finishing data receive 
					detect_bit	<= 1'b0;
				end				
			end else begin
				if ((cnt_baud_rate == (duration / 2)) && (cnt_rcv_bit >= 4'd1) && (cnt_rcv_bit <= 4'd8)) data_rcv_r <= {rx_r, data_rcv_r[7:1]}; 
				cnt_baud_rate <= cnt_baud_rate + 32'd1;
			end
		end
	endcase
end

assign data_rcv = data_rcv_r;
assign rx_done  = rx_done_r;

endmodule
