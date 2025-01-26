// tap_env.sv, all set
`include "uvm_macros.svh"
import uvm_pkg::*;

class tap_env extends uvm_env;
    `uvm_component_utils(tap_env)

    tap_agent agt;
    tap_scoreboard sb;

    // constructor: 
    function new(string name = "tap_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    // build phase: 
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = tap_agent::type_id::create("agt", this);
        sb = tap_scoreboard::type_id::create("sb", this);
    endfunction

    // connect phase: 
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // Connect monitor to scoreboard: 
        agt.mon.monitor_port.connect(sb.scoreboard_port);
    endfunction

    // run phase: 
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask
endclass
