// test.sv
class tap_test extends uvm_test;
    `uvm_component_utils(tap_test)

    int numOfTests = 1000; // you can change this based on your need
    tap_env env; // from the block diagram, test contains env class

    // instantiate the sequences that we want to test, will be simulated at run phase: 
    tap_reset_sequence test_seq_reset;
    tap_test_sequence test_seq;

    //--------------------------------------------------------
    //Constructor
    //--------------------------------------------------------
    function new(string name = "tap_test", uvm_component parent);
        super.new(name, parent);
        `uvm_info("TEST_CLASS", "Inside Constructor!", UVM_HIGH)
    endfunction: new

    
    //--------------------------------------------------------
    //Build Phase
    //--------------------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TEST_CLASS", "Build Phase!", UVM_HIGH)

        env = tap_env::type_id::create("env", this); //create env class, under parent class "this class (alu_test)"

        // // Set verbosity to UVM_HIGH for all components under uvm_top, for debugging, commented if no need
        // uvm_top.set_report_verbosity_level(UVM_HIGH);

    endfunction: build_phase

    
    //--------------------------------------------------------
    //Connect Phase
    //--------------------------------------------------------
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("TEST_CLASS", "Connect Phase!", UVM_HIGH)

    endfunction: connect_phase

    
    //--------------------------------------------------------
    //Run Phase (run phase is built as "task" but not "function" since it involves and
    //record time progression of the simulation, at run phase of test class, the sequence
    //that we want to simulate will be raised and started. 
    //--------------------------------------------------------
    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("TEST_CLASS", "Run Phase!", UVM_HIGH)

        // Raise objection to keep the simulation running until the sequence completes
        phase.raise_objection(this);

        test_seq_reset = tap_reset_sequence::type_id::create("test_seq_reset");
        test_seq_reset.start(env.agt.seqr); // Start the sequence on the agent's sequencer
        #10;
        
        repeat(numOfTests) begin
            test_seq = tap_test_sequence::type_id::create("test_seq");
            test_seq.start(env.agt.seqr);
        end
        
        // Drop the objection once the sequence has finished
        phase.drop_objection(this);
    endtask: run_phase



endclass