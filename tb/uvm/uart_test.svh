class uart_test extends uvm_test;
  `uvm_component_utils(uart_test)

  // virtual uart_intf intf;

  uart_sequence uart_sequence_tx;
  uart_sequence uart_sequence_rx;
  uart_env env;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass

function uart_test::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void uart_test::build_phase(uvm_phase phase);
  // if(!uvm_config_db#(virtual uart_intf)::get(null, "", "intf", intf)) `uvm_fatal("BFM", "Failed to get intf")

  env = uart_env::type_id::create("env", this);
  uart_sequence_tx = uart_sequence::type_id::create("uart_sequence_tx", this);
  uart_sequence_rx = uart_sequence::type_id::create("uart_sequence_rx", this);

  // env.intf = this.intf;
endfunction

task uart_test::run_phase(uvm_phase phase);
  phase.raise_objection(this);
    fork
      uart_sequence_tx.start(env.agent_tx.seqr_tx);
      uart_sequence_rx.start(env.agent_rx.seqr_rx);
    join
  phase.drop_objection(this);
endtask