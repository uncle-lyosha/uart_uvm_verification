class uart_monitor_tx extends uvm_monitor;
  `uvm_component_utils(uart_monitor_tx)

  virtual uart_intf intf;

  uart_ap uart_ap_i;
  uart_ap uart_ap_o;

  uart_sequence_item item_i;
  uart_sequence_item item_o;

  extern function new(string name = "uart_monitor_tx", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass

function uart_monitor_tx::new(string name = "uart_monitor_tx", uvm_component parent);
  super.new(name, parent);
endfunction

function void uart_monitor_tx::build_phase(uvm_phase phase);
  if(!uvm_config_db#(virtual uart_intf)::get(null, "", "intf", intf)) `uvm_fatal("BFM", "Failed to get intf in monitor_tx")
  uart_ap_i = new("uart_ap_i", this);
  uart_ap_o = new("uart_ap_o", this);
endfunction

task uart_monitor_tx::run_phase(uvm_phase phase);
  forever begin
    wait(intf.tx_ready == 1'b0)
    
    item_i = uart_sequence_item::type_id::create("item_i_tx");
    item_o = uart_sequence_item::type_id::create("item_o_tx");

    @(negedge intf.tx);
    item_i.data <= intf.data_snd;
    #(4340ns);
    assert(!intf.tx);
    #(4340ns);

    for(int i = 0; i < 8; i++) begin
      #(4340ns);
      item_o.data[i] <= intf.tx;
      #(4340ns);
    end
    #(4340ns);
    assert(intf.tx);

    uart_ap_i.write(item_i);
    uart_ap_o.write(item_o);
  end
endtask


class uart_monitor_rx extends uvm_monitor;
  `uvm_component_utils(uart_monitor_rx)

  virtual uart_intf intf;

  uart_ap uart_ap_i;
  uart_ap uart_ap_o;

  uart_sequence_item item_i;
  uart_sequence_item item_o;

  extern function new(string name = "uart_monitor_rx", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
endclass

function uart_monitor_rx::new(string name = "uart_monitor_rx", uvm_component parent);
  super.new(name, parent);
endfunction

function void uart_monitor_rx::build_phase(uvm_phase phase);
  if(!uvm_config_db#(virtual uart_intf)::get(null, "", "intf", intf)) `uvm_fatal("BFM", "Failed to get intf in monitor_rx")
  uart_ap_i = new("uart_ap_i", this);
  uart_ap_o = new("uart_ap_o", this);
endfunction

task uart_monitor_rx::run_phase(uvm_phase phase);
  forever begin
    item_i = uart_sequence_item::type_id::create("item_i_rx");
    item_o = uart_sequence_item::type_id::create("item_o_rx");

    @(negedge intf.rx);
    #(4340ns);
    assert(!intf.rx);
    #(4340ns);
    
    for(int i = 0; i < 8; i++) begin
      #(4340ns);
      item_i.data[i] = intf.rx;
      #(4340ns);
    end
    #(4340ns);
    assert(intf.rx);

    @(posedge intf.rx_done);
    item_o.data = intf.data_rcv;
    
    uart_ap_i.write(item_i);
    uart_ap_o.write(item_o);
  end
endtask