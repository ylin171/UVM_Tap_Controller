// tap_sequence_item.sv
class tap_sequence_item extends uvm_sequence_item;
    `uvm_object_utils(tap_sequence_item)

    // inputs to the DUT: 
    rand logic TRST, TMS;

    // outputs from the DUT: 
    // Note that we only have 1 output pin called state
    logic [3:0] previous_state; // receive the current output as the current state right at the time of TCLK and TMS input
    logic [3:0] next_state; // receive the responded output, 1 clk after the TCLK and TMS input

    function new(string name="tap_sequence_item");
        super.new(name);
    endfunction

endclass
