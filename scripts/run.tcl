# TCL script
set test_name [lindex $argv 0]
set seed      [lindex $argv 1]
set is_cli    [lindex $argv 2]

set cov_dir   "sim_uvm/cov"
set cov_name  "${test_name}_seed_${seed}"

eval vsim -voptargs="+acc" -sv_seed $seed \
     +UVM_TESTNAME=$test_name \
     -coverage \
     work.uart_tb_top

if {$is_cli == 0} {
    echo "=== QuestaSim GUI Mode ==="
    add wave -group "uart_tx" -position end sim:/uart_tb_top/uart_inst/uart_tx/*
    add wave -group "uart_rx" -position end sim:/uart_tb_top/uart_inst/uart_rx/*
    
    run -all 

    wave zoomfull
} else {
    echo "=== QuestaSim CLI Mode ==="
    run -all

    echo "=== Saving coverage to $cov_dir/$cov_name.ucdb ==="
    coverage attribute -name TESTNAME -value $test_name
    coverage save "$cov_dir/$cov_name.ucdb"
    quit -f
}
