`uvm_analysis_imp_decl(_tx_i)
`uvm_analysis_imp_decl(_tx_o)
`uvm_analysis_imp_decl(_rx_i)
`uvm_analysis_imp_decl(_rx_o)

class uart_scrb extends uvm_scoreboard;
  `uvm_component_utils(uart_scrb)

  uvm_analysis_imp_tx_i #(uart_sequence_item, uart_scrb) uart_ap_tx_i;
  uvm_analysis_imp_tx_o #(uart_sequence_item, uart_scrb) uart_ap_tx_o;

  uvm_analysis_imp_rx_i #(uart_sequence_item, uart_scrb) uart_ap_rx_i;
  uvm_analysis_imp_rx_o #(uart_sequence_item, uart_scrb) uart_ap_rx_o;

  uart_sequence_item item_queue_tx_i[$];
  uart_sequence_item item_queue_tx_o[$];

  uart_sequence_item item_queue_rx_i[$];
  uart_sequence_item item_queue_rx_o[$];

  int log_file_h;

  extern function new(string name = "uart_scrb", uvm_component parent);
  extern function void build_phase(uvm_phase phase);

  // Writing in file
  extern function void connect_phase(uvm_phase phase);
  extern function void final_phase(uvm_phase phase);

  extern function void write_tx_i(uart_sequence_item item_tx);
  extern function void write_tx_o(uart_sequence_item item_tx);
  extern function void processing_tx();

  extern function void write_rx_i(uart_sequence_item item_rx);
  extern function void write_rx_o(uart_sequence_item item_rx);
  extern function void processing_rx();
endclass

function uart_scrb::new(string name = "uart_scrb", uvm_component parent);
  super.new(name, parent);
endfunction

function void uart_scrb::build_phase(uvm_phase phase);
  uart_ap_tx_i = new("uart_ap_tx_i", this); 
  uart_ap_tx_o = new("uart_ap_tx_o", this);

  uart_ap_rx_i = new("uart_ap_rx_i", this); 
  uart_ap_rx_o = new("uart_ap_rx_o", this); 
endfunction

// Creating and writing in scrb_result (../sim_uvm/*)
function void uart_scrb::connect_phase(uvm_phase phase);
  log_file_h = $fopen("scrb_results.log", "w");
  
  this.set_report_default_file(log_file_h);
  this.set_report_severity_action(UVM_INFO, UVM_LOG);
  this.set_report_severity_action(UVM_ERROR, UVM_DISPLAY | UVM_LOG);
endfunction

// Closing the file
function void uart_scrb::final_phase(uvm_phase phase);
  $fclose(log_file_h);
endfunction

function void uart_scrb::write_tx_i(uart_sequence_item item_tx);
  item_queue_tx_i.push_back(item_tx);
endfunction

function void uart_scrb::write_tx_o(uart_sequence_item item_tx);
  item_queue_tx_o.push_back(item_tx);
  processing_tx();
endfunction

function void uart_scrb::write_rx_i(uart_sequence_item item_rx);
  item_queue_rx_i.push_back(item_rx);
endfunction

function void uart_scrb::write_rx_o(uart_sequence_item item_rx);
  item_queue_rx_o.push_back(item_rx);
  processing_rx();
endfunction

function void uart_scrb::processing_tx();
  uart_sequence_item item_tx_i;
  uart_sequence_item item_tx_o;
  string data_str_tx;

  item_tx_i = item_queue_tx_i.pop_front();
  item_tx_o = item_queue_tx_o.pop_front();

  data_str_tx = {
    "\n", "actual:    data_snd = ", item_tx_i.convert2string(),
    "\n", "predicted: data_snd = ", item_tx_o.convert2string()
  };

  if(!item_tx_i.compare(item_tx_o))
    `uvm_error("FAIL", data_str_tx)
  else
    `uvm_info("PASS", data_str_tx, UVM_NONE)
endfunction

function void uart_scrb::processing_rx();
  uart_sequence_item item_rx_i;
  uart_sequence_item item_rx_o;
  string data_str_rx;

  item_rx_i = item_queue_rx_i.pop_front();
  item_rx_o = item_queue_rx_o.pop_front();

  data_str_rx = {
    "\n", "actual:    data_rcv = ", item_rx_i.convert2string(),
    "\n", "predicted: data_rcv = ", item_rx_o.convert2string()
  };

  if(!item_rx_i.compare(item_rx_o))
    `uvm_error("FAIL", data_str_rx)
  else
    `uvm_info("PASS", data_str_rx, UVM_NONE)
endfunction

