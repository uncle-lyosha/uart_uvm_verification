class uart_coverage extends uvm_subscriber #(uart_sequence_item);
  `uvm_component_utils(uart_coverage)

  uart_sequence_item item;
  int item_cnt;
  int cov_log_file_h;
  
  covergroup cov1;
    cp_data : coverpoint item.data {
      bins data_pkt_c [256] = {[0:255]};
    }
    cp_delay :coverpoint item.delay {
      bins delay_c [100] = {[1:2000]};
    }
  endgroup

  extern function new(string name, uvm_component parent);
  extern function void write(uart_sequence_item t);
  extern function void connect_phase(uvm_phase phase);
  extern function void final_phase(uvm_phase phase);
  
endclass

function void uart_coverage::connect_phase(uvm_phase phase);
  cov_log_file_h = $fopen("coverage_results.log", "w");
  
  this.set_report_default_file(cov_log_file_h);
  this.set_report_severity_action(UVM_INFO, UVM_LOG);
endfunction

function void uart_coverage::final_phase(uvm_phase phase);
  $fclose(cov_log_file_h);
endfunction

function uart_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  cov1 = new();
endfunction

function void uart_coverage::write (uart_sequence_item t);
  real current_coverage;

  item = t;
  item_cnt++;
  cov1.sample();
  current_coverage = $get_coverage();

  `uvm_info("COVERAGE", $sformatf("%0d Packets sampled, Coverage = %f%% ", item_cnt, current_coverage), UVM_MEDIUM)
endfunction