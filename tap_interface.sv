// tap_interface.sv
interface tap_interface(input logic TCLK);

    // all the DUT pins except TCLK: 
    logic TRST, TMS;    // inputs
    logic [3:0] STATE;  // outputs

endinterface