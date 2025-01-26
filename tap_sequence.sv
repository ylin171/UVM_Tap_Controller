// Object class


class tap_reset_sequence extends uvm_sequence;
    `uvm_object_utils(tap_reset_sequence)
    
    tap_sequence_item reset_pkt;
    
    //--------------------------------------------------------
    //Constructor
    //--------------------------------------------------------
    function new(string name= "tap_reset_sequence");
      super.new(name);
      `uvm_info("BASE_SEQ", "Inside Constructor!", UVM_HIGH)
    endfunction
    
    
    //--------------------------------------------------------
    //Body Task
    //--------------------------------------------------------
    task body();
      `uvm_info("BASE_SEQ", "Inside body task!", UVM_HIGH)
      
      reset_pkt = tap_sequence_item::type_id::create("reset_pkt");
      start_item(reset_pkt);
      reset_pkt.randomize() with {TRST==1;}; // set as a reset sequence
      finish_item(reset_pkt);
          
    endtask: body
    
    
  endclass: tap_reset_sequence
  
  
  
class tap_test_sequence extends tap_reset_sequence;
    `uvm_object_utils(tap_test_sequence)
    
    tap_sequence_item item;
    
    //--------------------------------------------------------
    //Constructor
    //--------------------------------------------------------
    function new(string name= "tap_test_sequence");
      super.new(name);
      `uvm_info("TEST_SEQ", "Inside Constructor!", UVM_HIGH)
    endfunction
    
    
    //--------------------------------------------------------
    //Body Task
    //--------------------------------------------------------
    task body();
      `uvm_info("TEST_SEQ", "Inside body task!", UVM_HIGH)
      
      item = tap_sequence_item::type_id::create("item");
      start_item(item);
      item.randomize() with {TRST==0;};
      finish_item(item);
          
    endtask: body
    
    
endclass: tap_test_sequence