`timescale 1ns / 100ps

module tb_top_uart_tx;

  // Parameters
  // localparam  baud_rate = 0;
  // localparam  freq_clk = 0;

  //Ports
  reg clk;
  reg rst;
  reg [7:0] data_to_send;
  reg tx_en;
  wire tx;
  wire tx_done;

  uart_tx # (
    .baud_rate(),
    .freq_clk()
  ) dut_uart_tx (
    .clk          (clk),
    .rst          (rst),
    .data_snd     (data_to_send),
    .valid        (tx_en),
    .tx           (tx),
    .ready        (tx_done)
  );

  initial begin
    rst = 1'b1;
    repeat (2) @(posedge clk);
    rst = 1'b0;
    tx_en = 1'b0;
    data_to_send = 8'hAE;
    @(posedge clk);
    tx_en = 1'b1;
    wait (dut_uart_tx.transmit_done == 1);

    repeat(3000) @(posedge clk);

    tx_en = 1'b0;
    data_to_send = 8'h0F;
    @(posedge clk);
    tx_en = 1'b1;
    wait (dut_uart_tx.transmit_done == 1);
    repeat(7000) @(posedge clk);
    $stop();
  end

  initial begin
    clk = 1'b0;
    forever #(10) clk = ~clk; 
  end
endmodule
