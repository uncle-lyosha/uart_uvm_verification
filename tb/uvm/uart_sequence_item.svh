class uart_sequence_item extends uvm_sequence_item;
  `uvm_object_utils(uart_sequence_item)

  randc bit [7:0] data;
  rand  int delay;
  bit       error;

  constraint uart_delay_c {
    delay inside {[0:2000]};
    soft error == 0;
  }

  extern function new(string name = "uart_sequence_item");
  extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
  extern function string convert2string();

endclass

function uart_sequence_item::new(string name = "uart_sequence_item");
  super.new(name);
endfunction

function string uart_sequence_item::convert2string(); // Просто функция для конвертирования значения в тип string 
  string s;
  s = $sformatf("%8b", data);
  return s;
endfunction

function bit uart_sequence_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  uart_sequence_item rhs_;

  if (!$cast(rhs_, rhs)) begin
    `uvm_error("COMP_MISTMATCH", "Error type of the comparing obkect")
    return 0;
  end else return((super.do_compare(rhs, comparer)) && (data == rhs_.data));
endfunction