class uart_driver_tx extends uvm_driver #(uart_sequence_item);
  `uvm_component_utils(uart_driver_tx)

  virtual uart_intf intf;

  uart_sequence_item item;

  extern function new(string name = "uart_driver_tx", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  
  extern task driver_tx(uart_sequence_item item);
endclass

function uart_driver_tx::new(string name = "uart_driver_tx", uvm_component parent);
	super.new(name, parent);
endfunction

function void uart_driver_tx::build_phase(uvm_phase phase);
  if(!uvm_config_db#(virtual uart_intf)::get(null, "", "intf", intf)) `uvm_fatal("BFM", "Failed to get intf in drv_tx")
endfunction

task uart_driver_tx::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(item);

      driver_tx(item);

    seq_item_port.item_done();
  end
endtask

task uart_driver_tx::driver_tx(uart_sequence_item item);
  wait(intf.tx_ready == 1'b1)
  intf.tx_valid <= 1'b1;
  intf.data_snd <= item.data;

  repeat(2) @(posedge intf.clk);
  intf.tx_valid <= 1'b0;

  wait(intf.tx_ready == 1'b1);
  repeat(item.delay) #(150ns);
     
endtask


class uart_driver_rx extends uvm_driver #(uart_sequence_item);
  `uvm_component_utils(uart_driver_rx)

  virtual uart_intf intf;

  uart_sequence_item item;

  extern function new(string name = "uart_driver_rx", uvm_component parent);
  extern task run_phase(uvm_phase phase);
  extern function void build_phase(uvm_phase phase);

  extern task driver_rx(uart_sequence_item item);
endclass

function uart_driver_rx::new(string name = "uart_driver_rx", uvm_component parent);
	super.new(name, parent);
endfunction

function void uart_driver_rx::build_phase(uvm_phase phase);
  if(!uvm_config_db#(virtual uart_intf)::get(null, "", "intf", intf)) `uvm_fatal("BFM", "Failed to get intf in drv_rx")
endfunction

task uart_driver_rx::run_phase(uvm_phase phase);
  forever begin
    seq_item_port.get_next_item(item);

      driver_rx(item);
      
    seq_item_port.item_done();
  end
endtask

task uart_driver_rx::driver_rx(uart_sequence_item item);
  intf.rx <= 1'b1;
  repeat(item.delay) #(150ns);
  intf.rx <= 1'b0;
  #(8680ns);
  for(int i = 0; i < 8; i++) begin
    intf.rx <= item.data[i];
    #(8680ns);
  end
  intf.rx <= 1'b1;
  #(8680ns);
endtask



