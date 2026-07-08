class uart_sequence extends uvm_sequence #(uart_sequence_item);
  `uvm_object_utils(uart_sequence)

  uart_sequence_item item;

  function new(string name = "uart_sequence");
    super.new(name);
  endfunction

  task body();
    item = uart_sequence_item::type_id::create("item");

    repeat(1000) begin
      start_item(item);

        assert(item.randomize());

      finish_item(item);
    end
  endtask
endclass