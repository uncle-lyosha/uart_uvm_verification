package uart_package;

  import uvm_pkg::*;
	`include "uvm_macros.svh"

  `include "uart_sequence_item.svh"

  typedef uvm_sequencer #(uart_sequence_item) uart_sequencer_tx;
  typedef uvm_sequencer #(uart_sequence_item) uart_sequencer_rx;

  `include "uart_driver.svh"
  `include "uart_sequence.svh"

  typedef uvm_analysis_port #(uart_sequence_item) uart_ap;
  `include "uart_monitor.svh"

  `include "uart_scoreboard.svh"
  `include "uart_coverage.svh"

  `include "uart_agent.svh"

  `include "uart_env.svh"

  `include "uart_test.svh"

endpackage