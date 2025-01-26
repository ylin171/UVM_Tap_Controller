class tap_coverage extends uvm_subscriber #(tap_sequence_item);
    `uvm_component_utils(tap_coverage)

    // Variables to hold the state and TMS values for sampling
    bit [3:0] previous_state;
    bit TMS;

    // Define a covergroup for TAP state transitions
    covergroup state_transition_cg;
        option.per_instance = 1; // unique coverage per instance

        // Coverpoint for current state
        state: coverpoint previous_state {
            bins reset = {4'd0};             // Test_logic_reset
            bins idle = {4'd1};              // Run_test_idle
            bins select_dr = {4'd2};         // Select_DR_scan
            bins capture_dr = {4'd3};        // Capture_DR
            bins shift_dr = {4'd4};          // Shift_DR
            bins exit1_dr = {4'd5};          // Exit1_DR
            bins pause_dr = {4'd6};          // Pause_DR
            bins exit2_dr = {4'd7};          // Exit2_DR
            bins update_dr = {4'd8};         // Update_DR
            bins select_ir = {4'd9};         // Select_IR_scan
            bins capture_ir = {4'd10};       // Capture_IR
            bins shift_ir = {4'd11};         // Shift_IR
            bins exit1_ir = {4'd12};         // Exit1_IR
            bins pause_ir = {4'd13};         // Pause_IR
            bins exit2_ir = {4'd14};         // Exit2_IR
            bins update_ir = {4'd15};        // Update_IR
        }

        // Coverpoint for TMS to capture transitions based on its value
        tms_val: coverpoint TMS {
            bins tms_low = {1'b0};           // TMS is 0
            bins tms_high = {1'b1};          // TMS is 1
        }

        //Cross coverage of state and TMS to capture all transitions
        state_x_tms: cross state, tms_val;

    endgroup : state_transition_cg

    // Constructor for the coverage class
    function new(string name="tap_coverage", uvm_component parent=null);
        super.new(name, parent);
        state_transition_cg = new();  // Initialize the covergroup
    endfunction

    // Write method to sample the coverage
    function void write(tap_sequence_item t);
        // Set values to the sampled fields before calling sample
        previous_state = t.previous_state;
        TMS = t.TMS;
        
        // Sample the covergroup without arguments
        state_transition_cg.sample();
    endfunction

endclass : tap_coverage



/*
Side Notes: 
Functional coverage in UVM allows you to observe and verify if all desired states and transitions in a design 
have been exercised. By defining coverage points and covergroups, we create a "map" of expected behavior. 
This can include transitions, specific states, or specific values of signals like TMS.

For the TAP controller:

We are interested in state transitions as the TMS signal controls them.
We define coverpoints for the STATE values and capture how each state transitions with different values of TMS.
We use cross-coverage to track transitions involving the current state and TMS.


1. Class Definition and Inheritance:
The tap_coverage class extends uvm_subscriber and links to tap_sequence_item, allowing it to observe 
transactions in the TAP state machine.

2. Covergroup Definition:
We create a covergroup called state_transition_cg with option.per_instance = 1. This option allows unique 
coverage per instance, useful if there are multiple TAP controllers in a system.

3. Coverpoints:
- State Coverpoint: The state coverpoint defines a bin for each possible state in the TAP state machine. 
    This lets us track whether each state has been visited at least once.
- TMS Coverpoint: The tms_val coverpoint monitors the TMS signal's value, recording each instance where TMS is 
    high (1) or low (0). 
    
4. Cross Coverage:
The state_x_tms cross coverage point captures all possible combinations of STATE and TMS. This ensures that 
transitions involving both STATE and TMS values are covered.

5. Sampling the Coverage:
The write method is invoked when a new sequence item is generated in the UVM environment.
state_transition_cg.sample(item); is called to sample the coverage data, logging the current state and TMS value.

This functional coverage will help ensure that every state and TMS condition combination in the TAP 
controller’s state machine is thoroughly tested.
*/

