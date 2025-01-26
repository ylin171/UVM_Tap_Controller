class tap_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(tap_scoreboard)

    // TAP states defined as local parameters for readability and comparison
    localparam [3:0] Test_logic_reset = 4'd0;
    localparam [3:0] Run_test_idle = 4'd1;
    localparam [3:0] Select_DR_scan = 4'd2;
    localparam [3:0] Capture_DR = 4'd3;
    localparam [3:0] Shift_DR = 4'd4;
    localparam [3:0] Exit1_DR = 4'd5;
    localparam [3:0] Pause_DR = 4'd6;
    localparam [3:0] Exit2_DR = 4'd7;
    localparam [3:0] Update_DR = 4'd8;
    localparam [3:0] Select_IR_scan = 4'd9;
    localparam [3:0] Capture_IR = 4'd10;
    localparam [3:0] Shift_IR = 4'd11;
    localparam [3:0] Exit1_IR = 4'd12;
    localparam [3:0] Pause_IR = 4'd13;
    localparam [3:0] Exit2_IR = 4'd14;
    localparam [3:0] Update_IR = 4'd15;

    // UVM analysis implementation port for receiving transactions from monitor
    uvm_analysis_imp #(tap_sequence_item, tap_scoreboard) scoreboard_port;

    // Queue to store received items from the monitor
    tap_sequence_item transactions[$];

    // Constructor
    function new(string name = "tap_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scoreboard_port = new("scoreboard_port", this); // Construct port for monitor
    endfunction




    // Write method to handle incoming transactions
    function void write(tap_sequence_item item);
        transactions.push_back(item); // Store received item from monitor
    endfunction




    // Run phase for processing transactions
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            tap_sequence_item current_trans;
            wait(transactions.size() != 0); // Wait for available transactions
            current_trans = transactions.pop_front();
            compare(current_trans); // Perform comparison for the transaction
        end
    endtask




    // calculate expected state transitions based on the current state and inputs
    function [3:0] expected_next_state(input [3:0] current_state, input bit TMS, input bit TRST);
        if(TRST) begin
            expected_next_state = Test_logic_reset;
        end
        else begin
            case (current_state)
                Test_logic_reset: 
                    expected_next_state = TMS ? Test_logic_reset : Run_test_idle;
                Run_test_idle: 
                    expected_next_state = TMS ? Select_DR_scan : Run_test_idle;
                Select_DR_scan: 
                    expected_next_state = TMS ? Select_IR_scan : Capture_DR;
                Capture_DR: 
                    expected_next_state = TMS ? Exit1_DR : Shift_DR;
                Shift_DR: 
                    expected_next_state = TMS ? Exit1_DR : Shift_DR;
                Exit1_DR: 
                    expected_next_state = TMS ? Update_DR : Pause_DR;
                Pause_DR: 
                    expected_next_state = TMS ? Exit2_DR : Pause_DR;
                Exit2_DR: 
                    expected_next_state = TMS ? Update_DR : Shift_DR;
                Update_DR: 
                    expected_next_state = TMS ? Select_DR_scan : Run_test_idle;
                Select_IR_scan: 
                    expected_next_state = TMS ? Test_logic_reset : Capture_IR;
                Capture_IR: 
                    expected_next_state = TMS ? Exit1_IR : Shift_IR;
                Shift_IR: 
                    expected_next_state = TMS ? Exit1_IR : Shift_IR;
                Exit1_IR: 
                    expected_next_state = TMS ? Update_IR : Pause_IR;
                Pause_IR: 
                    expected_next_state = TMS ? Exit2_IR : Pause_IR;
                Exit2_IR: 
                    expected_next_state = TMS ? Update_IR : Shift_IR;
                Update_IR: 
                    expected_next_state = TMS ? Select_DR_scan : Run_test_idle;
                default: 
                    expected_next_state = Test_logic_reset; // Default state or error
            endcase
        end
        
    endfunction




    // Comparison function to validate state transitions
    function void compare(tap_sequence_item item);
        // Compute expected next state based on current state and TMS, should declare all variables before using uvm_info, or it will cause error: Illegal declaration after the statement near line '97'.  Declarations must precede statements.  Look for stray semicolons. "you are declaring the variable ‘subscriber’ after the procedural code uvm_report_info(). All variable declarations must be before procedural code."
        bit TMS = item.TMS;
        bit TRST = item.TRST;

        logic [3:0] expected_state = expected_next_state(item.previous_state, TMS, TRST);



        `uvm_info("SCOREBOARD", $sformatf("Checking state transition from %0d to %0d", item.previous_state, item.next_state), UVM_MEDIUM) // UVM_MEDIUM is the default verbosity
        // Compare observed next state with expected state
        if (item.next_state !== expected_state) begin
            `uvm_error("SCOREBOARD", $sformatf("State transition error: Expected %0d, got %0d with TMS=%0b", expected_state, item.next_state, TMS))
        end else begin
            `uvm_info("SCOREBOARD", $sformatf("Correct transition: %0d -> %0d", item.previous_state, item.next_state), UVM_LOW) // will be print out
        end
    endfunction
endclass

