class uart_agent_tx extends uvm_agent;
  `uvm_component_utils(uart_agent_tx)

  // virtual uart_intf intf;

  uart_sequencer_tx seqr_tx;
  uart_driver_tx    driver_tx;
  uart_monitor_tx   monitor_tx;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass

function uart_agent_tx::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void uart_agent_tx::build_phase(uvm_phase phase);
  seqr_tx    = uvm_sequencer#(uart_sequence_item)::type_id::create("seqr_tx", this);
  driver_tx  = uart_driver_tx::type_id::create("driver_tx", this);
  monitor_tx = uart_monitor_tx::type_id::create("monitor_tx", this);

  // driver_tx.intf  = this.intf;
  // monitor_tx.intf = this.intf;
endfunction

function void uart_agent_tx::connect_phase(uvm_phase phase);
  driver_tx.seq_item_port.connect(seqr_tx.seq_item_export);
endfunction

//----------------------------------------------------

class uart_agent_rx extends uvm_agent;
  `uvm_component_utils(uart_agent_rx)

  // virtual uart_intf intf;

  uart_sequencer_rx seqr_rx;
  uart_driver_rx    driver_rx;
  uart_monitor_rx   monitor_rx;

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass

function uart_agent_rx::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void uart_agent_rx::build_phase(uvm_phase phase);
  seqr_rx    = uvm_sequencer#(uart_sequence_item)::type_id::create("seqr_rx", this);
  driver_rx  = uart_driver_rx::type_id::create("driver_rx", this);
  monitor_rx = uart_monitor_rx::type_id::create("monitor_rx", this);

  // driver_rx.intf  = this.intf;
  // monitor_rx.intf = this.intf;
endfunction

function void uart_agent_rx::connect_phase(uvm_phase phase);
  driver_rx.seq_item_port.connect(seqr_rx.seq_item_export);
endfunction
