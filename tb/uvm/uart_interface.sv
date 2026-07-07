interface uart_intf(input bit clk, input bit rst);
  logic [7:0] data_snd;
  logic tx_valid;        // Running work (enable)
  logic tx;              // Port tx 
  logic tx_ready;        // Byte transmission is completed
  logic [7:0] data_rcv;
	logic rx;              // Port rx 
	logic rx_done;         // Byte receiving is completed
endinterface