# Переменные путей
SIM_DIR     = sim
COV_DIR     = $(SIM_DIR)/cov
SRC_DIR     = src
TB_DIR      = tb/uvm
SCRIPT_DIR	= scripts

# Настройки симуляции
TEST        = uart_test
SEED        = random
LOG_FILE    = sim.log

# Списки файлов для отслеживания инкрементальной компиляции
RTL_SRC     = $(wildcard $(SRC_DIR)/*.v)
UVM_SRC     = $(wildcard $(TB_DIR)/*.sv)
# TOP_SRC     = $(TB_DIR)/uart_tb_top.sv

# $(TB_DIR)/uart_interface.sv $(TB_DIR)/uart_package.sv
.PHONY: all clean compile run gui

all: run

# Создание необходимых директорий и компиляция (только при изменении файлов)
compile: $(SIM_DIR)/.compile_rtl $(SIM_DIR)/.compile_tb

$(SIM_DIR)/.compile_rtl: $(RTL_SRC)
	@mkdir -p $(SIM_DIR)
	vlib $(SIM_DIR)/work
	vmap work $(SIM_DIR)/work
	vlog -work work -incr $(RTL_SRC)
	@touch $@

$(SIM_DIR)/.compile_tb: $(SIM_DIR)/.compile_rtl
	vlog -work work -incr +incdir+$(TB_DIR) +define+UVM_NO_DEPRECATED -L uvm $(UVM_SRC)
	@touch $@

# Запуск в консольном режиме (CLI)
run: compile
	@mkdir -p $(COV_DIR)
	cd $(SIM_DIR) && vsim -c -do "set argv [list $(TEST) $(SEED) 1]; source ../$(SCRIPT_DIR)/run.tcl" -l $(LOG_FILE)

# Запуск в графическом режиме (GUI)
gui: compile
	@mkdir -p $(COV_DIR)
	cd $(SIM_DIR) && vsim -do "set argv [list $(TEST) $(SEED) 0]; source ../$(SCRIPT_DIR)/run.tcl" -l $(LOG_FILE)

clean:
	rm -rf $(SIM_DIR) vsim.wlf transcript modelsim.ini