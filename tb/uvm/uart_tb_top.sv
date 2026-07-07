module uart_tb_top;

	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import uart_package::*;

	bit clk, rst;

	uart_intf intf(clk, rst);

	uart  uart_inst (
		.clk			(intf.clk),
		.rst			(intf.rst),
		.data_snd	(intf.data_snd),
		.tx_valid	(intf.tx_valid),
		.tx				(intf.tx),
		.tx_ready	(intf.tx_ready),
		.data_rcv	(intf.data_rcv),
		.rx				(intf.rx),
		.rx_done	(intf.rx_done)
	);

	initial begin
		forever #(10ns) clk = ~clk; 
	end

	initial begin
		rst <= 1'b1;
		repeat(10) @(posedge clk);
		rst <= 1'b0;
	end

	initial begin
		uvm_config_db#(virtual uart_intf)::set(null, "*", "intf", intf);
		run_test("uart_test");
	end
endmodule