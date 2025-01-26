// tap_driver.sv, all set
class tap_driver extends uvm_driver #(tap_sequence_item); // ? <tap_sequence_item>, using <> cause compile error
    `uvm_component_utils(tap_driver)

    virtual tap_interface vif; // Interface to drive signals
    tap_sequence_item item;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("tap_driver", "build phase", UVM_HIGH)

        // get virtual interface handle: 
        if(!(uvm_config_db #(virtual tap_interface)::get(this, "*", "vif", vif))) begin
            `uvm_error("DRIVER_CLASS", "failed to get VIF from confic DB!")
        end
    endfunction


    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("DRIVER_CLASS", "inside connect phase", UVM_HIGH)
    endfunction



    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("DRIVER_CLASS", "inside RUN phase", UVM_HIGH)

        // tap_sequence_item item;
        forever begin
            item = tap_sequence_item::type_id::create("item");

            seq_item_port.get_next_item(item);
            drive(item);
            seq_item_port.item_done();
        end
    endtask

    task drive(tap_sequence_item item);
        // driving the inputs
        @(posedge vif.TCLK);
        vif.TRST <= item.TRST;
        vif.TMS <= item.TMS;
    endtask
endclass
