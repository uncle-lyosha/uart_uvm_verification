`timescale 1ns / 100ps

module tb_top_uart_rx;

  // Parameters
  // localparam  baud_rate = 0;
  // localparam  freq_clk = 0;

  //Ports
  reg clk;
  reg rst;
  wire [7:0] data_rcv;
  reg rx;
  wire rx_done;

  uart_rx # (
    .baud_rate(),
    .freq_clk()
  )
  dut_uart_rx (
    .clk     (clk),
    .rst     (rst),
    .data_rcv(data_rcv),
    .rx      (rx),
    .done (rx_done)
  );

  initial begin
    rst = 1'b1;
    rx  = 1'b1;
    repeat (2) @(posedge clk);
    rst = 1'b0;
    run_uart(8'hBD);
    repeat (3000) @(posedge clk);
    $stop();
  end

  task run_uart(reg [7:0] data);
    #(8670);
    rx = 1'b0;
    for (int i = 0; i < 8; i = i + 1) begin
      #(8670);
      rx = data[i];
    end
    #(8670);
    rx = 1'b1;
  endtask

  initial begin
    clk = 1'b0;
    forever #(10) clk = ~clk; 
  end

endmodule