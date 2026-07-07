//-----------------------------------------------
//  UART transmitter
//-----------------------------------------------
module uart_tx #(
  parameter baud_rate = 115200,       // Set value baud rate for work with uart
  parameter freq_clk  = 50_000_000    // Working frequency
)(
  input  clk, rst,
  input  [7:0] data_snd,
  input  valid,     // Running work (enable)
  output tx,        // Port tx 
  output ready    	// Byte transmission is completed
);

//-----------------------------------------------
//  Parameters
//-----------------------------------------------
localparam duration = freq_clk / baud_rate;   // duration [sec] = 1 / baud rate [Hz] = 8,67 us (for baud rate = 115200)

localparam IDLE     = 0;
localparam TRANSMIT = 1;
localparam STOP     = 2;

integer cnt_baud_rate;

reg [7:0] data_r;
reg [3:0] cnt_send_bit;   // Counter sent bites
reg [1:0] state;
reg [1:0] next;
reg tx_r;
reg ready_r;
reg transmit_done;

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
    IDLE    : if ((valid) && (!ready_r)) next = TRANSMIT;
              else                       next = IDLE;
    TRANSMIT: if (transmit_done) 				 next = STOP;
              else                       next = TRANSMIT;
    STOP    : next = IDLE;
  endcase
end

// The main logic of putting bits on the line
always @(posedge clk) begin
  case(state)
    IDLE: begin
      if (valid) begin 
        data_r  <= data_snd;
				ready_r <= 1'b0;
      end else begin
        ready_r <= 1'b1;
      end
			tx_r           <= 1'b1;
			cnt_baud_rate  <= 32'd0;
			cnt_send_bit   <= 4'b0;
			transmit_done	 <= 1'b0;
    end
    TRANSMIT: begin
      cnt_baud_rate <= 32'd0;
      // Start bit 
      if (cnt_send_bit == 0) tx_r <= 1'b0;

      // We set the data bit on rx every duration  
	    if (cnt_baud_rate == duration) begin

        // Data transmission
        if (cnt_send_bit < 4'd8) begin
          tx_r         <= data_r[cnt_send_bit];   // Using LSB
          cnt_send_bit <= cnt_send_bit + 3'd1;
				end else begin

          // Setting the stop bit on rx and exit from state TRANSMIT
					if (cnt_send_bit == 4'd8) begin
						tx_r         <= 1'b1;
						cnt_send_bit <= cnt_send_bit + 3'd1;
          end else begin
            transmit_done <= 1'b1;
          end

				end
      end else cnt_baud_rate <= cnt_baud_rate + 32'd1;
    end
    STOP: begin
      ready_r	<= 1'b1;
      tx_r 		<= 1'b1;
    end
  endcase
end

assign tx = tx_r;
assign ready = ready_r;

endmodule