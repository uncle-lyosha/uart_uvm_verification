module uart (
  input  clk, rst,
  input  [7:0] data_snd,
  input  tx_valid,       // Running work (enable)
  output tx,             // Port tx 
  output tx_ready,       // Byte transmission is completed
  output [7:0] data_rcv,
	input  rx,             // Port rx 
	output rx_done         // Byte receiving is completed
);

localparam baud_rate = 115200;       // Set value baud rate for work with uart
localparam freq_clk  = 50_000_000;   // Set the FPGA clock frequency

uart_tx #(
  .baud_rate(baud_rate),
  .freq_clk (freq_clk)
) uart_tx (
  .clk        (clk),  
  .rst        (rst),
  .data_snd   (data_snd),      
  .valid      (tx_valid), // Running work (enable)
  .ready      (tx_ready),
  .tx         (tx)
);

uart_rx #(
  .baud_rate(baud_rate),
  .freq_clk (freq_clk)
) uart_rx (
  .clk        (clk),  
  .rst        (rst),
  .data_rcv   (data_rcv),      
  .rx_done    (rx_done), // Running work (enable)
  .rx         (rx)        
);

endmodule