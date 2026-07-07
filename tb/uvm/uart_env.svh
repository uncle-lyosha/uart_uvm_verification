class uart_env extends uvm_env;
	`uvm_component_utils(uart_env)

	// virtual uart_intf intf;

	uart_agent_tx agent_tx;
	uart_agent_rx agent_rx;

	uart_scrb scrb;

	uart_coverage cov_tx, cov_rx;

	extern function new(string name, uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
 
endclass

function uart_env::new(string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void uart_env::build_phase(uvm_phase phase);
	agent_rx = uart_agent_rx::type_id::create("agent_rx", this);
	agent_tx = uart_agent_tx::type_id::create("agent_tx", this);

	scrb = uart_scrb::type_id::create("scrb", this);

	cov_tx = uart_coverage::type_id::create("coverage_tx", this);
	cov_rx = uart_coverage::type_id::create("coverage_rx", this);

	// agent_rx.intf = this.intf;
	// agent_tx.intf = this.intf;
endfunction

function void uart_env::connect_phase(uvm_phase phase);
	agent_tx.monitor_tx.uart_ap_i.connect(scrb.uart_ap_tx_i);
	agent_tx.monitor_tx.uart_ap_o.connect(scrb.uart_ap_tx_o);

	agent_rx.monitor_rx.uart_ap_i.connect(scrb.uart_ap_rx_i);
	agent_rx.monitor_rx.uart_ap_o.connect(scrb.uart_ap_rx_o);

	agent_tx.monitor_tx.uart_ap_i.connect(cov_tx.analysis_export);
	agent_rx.monitor_rx.uart_ap_i.connect(cov_rx.analysis_export);
endfunction