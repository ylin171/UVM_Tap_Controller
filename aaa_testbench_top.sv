
// to set verbosity, run 
// vsim -sv_seed random +UVM_VERBOSITY=UVM_LOW -l sim.log aaa_tb_top 
// OR uncomment the set_report_verbosity_level at test.sv Build Phase

// in Modelsim, aaa_tb_top is the top design module name
`timescale 1ns/1ns
import uvm_pkg::*;
`include "uvm_macros.svh"

// include files, order is important, from lowest to topest level
`include "tap_interface.sv"
`include "tap_sequence_item.sv"
`include "tap_sequence.sv"
`include "tap_sequencer.sv"
`include "tap_driver.sv"
`include "tap_coverage.sv" // should include coverage first, since will be instantiated later on by monitor
`include "tap_monitor.sv"
`include "tap_agent.sv"
`include "tap_scoreboard.sv"
`include "tap_environment.sv"
`include "test.sv"

module aaa_tb_top;
    // instantiation: 
    logic TCLK;

    tap_interface intf(.TCLK(TCLK));

    tap_controller DUT(
        .TCLK(TCLK),
        .TMS(intf.TMS),
        .TRST(intf.TRST), 
        .STATE(intf.STATE)
    );


    initial begin
        // interface setting: 
        uvm_config_db #(virtual tap_interface)::set(null, "*", "vif", intf );    
    end


    // start the test: 
    initial begin
        run_test("tap_test");
    end


    // clock generation: 
    initial begin
        TCLK = 0;
        #5;
        forever begin
            TCLK = ~TCLK;
            #2;
        end
    end


    // max simulation time: 
    initial begin
        #1000000;
        $display("Finish due to too many clock cycles, please check design!\n");
        $finish;
    end

    

    
endmodule
