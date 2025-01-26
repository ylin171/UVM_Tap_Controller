// tap_agent.sv
class tap_agent extends uvm_agent;
    `uvm_component_utils(tap_agent)

    tap_driver drv;
    tap_monitor mon;
    tap_sequencer seqr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        `uvm_info("Agent_Class", "Inside Constructor", UVM_HIGH)
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = tap_driver::type_id::create("drv", this);
        mon = tap_monitor::type_id::create("mon", this);
        seqr = tap_sequencer::type_id::create("seqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask
endclass
