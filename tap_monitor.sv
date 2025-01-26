// tap_monitor.sv
class tap_monitor extends uvm_monitor;
    `uvm_component_utils(tap_monitor)

    virtual tap_interface vif;
    tap_sequence_item item;


    tap_coverage cov; // for functional coverage

    uvm_analysis_port#(tap_sequence_item) monitor_port;

    function new(string name = "tap_monitor", uvm_component parent);
        super.new(name, parent);
        `uvm_info("MONITOR_CLASS", "inside constructor", UVM_HIGH)
    endfunction



    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("MONITOR CLASS", "build phase", UVM_HIGH)

        monitor_port = new("monitor_port", this);
        cov = tap_coverage::type_id::create("cov", this); 

        // set interface: 
        if(!(uvm_config_db #(virtual tap_interface)::get(this, "*", "vif", vif))) begin
            `uvm_error("MONITOR CLASS", "failed to get VIF from config DB!")
        end
    endfunction



    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("MONITOR CLASS", "connect_phase", UVM_HIGH)
    endfunction



    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("MONITOR CLASS", "run_phase", UVM_HIGH)


        wait(vif.TRST); // wait for reset = 1, which indicate the start of the testing
        forever begin
            item = tap_sequence_item::type_id::create("item");

            // monitor the inputs and the current state at the first clk
            @(posedge vif.TCLK);
            item.TRST = vif.TRST;
            item.TMS = vif.TMS;
            item.previous_state = vif.STATE; // monitor the current state

            cov.write(item); // send the current signals to functional coverage, write function

            `uvm_info("MONITOR CLASS", $sformatf("From DUT, TRST = %0d, TMS = %0d, currentState = %0d", item.TRST, item.TMS, item.previous_state), UVM_HIGH)

            // wait a clock and see how the output responds
            @(posedge vif.TCLK);
            // item.TRST_next = vif.TRST; // actually don't need to monitor the inputs at second clk, since now focus on whether output is correct 
            // item.TMS_next = vif.TMS;
            item.next_state = vif.STATE; // the state output at second clk will be the next state being calculated by the controller based on the inputs given at the first clk

            `uvm_info("MONITOR CLASS", $sformatf("From DUT, nextState = %0d", item.next_state), UVM_HIGH)

            // send item received to Scoreboard for comparison, will define write function there
            monitor_port.write(item);

            `uvm_info("MONITOR CLASS", "End of foerever loop", UVM_HIGH)
        end

    endtask
endclass

/* notes:
When using my approach of capturing the output state at the second clock, at this second clock, the TMS input will stay the same
as the TMS input at the first clk, so we will miss capturing the second clock state transition. That is, at second clock, the next_state
is actually the current_state, and its coresponding next state will be at the third clk if there was third clk. 

The missed state transition is ok because the functional coverage also only captures TMS and current_state at the first clk, 
so if the functional coverage reaches 100%, it means we have still succesfully covered all possible state transitions owing to enough
amounts of random sequences. 
*/
