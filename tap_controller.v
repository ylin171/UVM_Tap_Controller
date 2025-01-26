// tap_controller, this is the DUT, it is used for DFT JTAG
module tap_controller ( 
    input TCLK, TRST, TMS, 
    output [3:0] STATE
    );

    parameter [3:0] Test_logic_reset = 4'd0;
    parameter [3:0] Run_test_idle = 4'd1;
    parameter [3:0] Select_DR_scan = 4'd2;
    parameter [3:0] Capture_DR = 4'd3;
    parameter [3:0] Shift_DR = 4'd4;
    parameter [3:0] Exit1_DR = 4'd5;
    parameter [3:0] Pause_DR = 4'd6;
    parameter [3:0] Exit2_DR = 4'd7;
    parameter [3:0] Update_DR = 4'd8;
    parameter [3:0] Select_IR_scan = 4'd9;
    parameter [3:0] Capture_IR = 4'd10;
    parameter [3:0] Shift_IR = 4'd11;
    parameter [3:0] Exit1_IR = 4'd12;
    parameter [3:0] Pause_IR = 4'd13;
    parameter [3:0] Exit2_IR = 4'd14;
    parameter [3:0] Update_IR = 4'd15;
    

    reg [3:0] currentState, nextState;
    assign STATE = currentState;

    //================================================================================
    // State Memory: 
    //================================================================================
    always@(posedge TCLK) begin // state memory
        if(TRST)
            currentState <= Test_logic_reset;
        else 
            currentState <= nextState;
    end

    //================================================================================
    // Next State Logic: 
    //================================================================================
    always @(currentState, TMS) begin 
        case(currentState)
            Test_logic_reset: begin
                if(TMS == 1)
                    nextState = Test_logic_reset;
                else 
                    nextState = Run_test_idle;
            end
            Run_test_idle: begin
                if(TMS == 1)
                    nextState = Select_DR_scan;
                else 
                    nextState = Run_test_idle;
            end
            Select_DR_scan: begin
                if(TMS == 1)
                    nextState = Select_IR_scan;
                else 
                    nextState = Capture_DR;
            end
            Capture_DR: begin
                if(TMS == 1)
                    nextState = Exit1_DR;
                else 
                    nextState = Shift_DR;
            end
            Shift_DR: begin
                if(TMS == 1)
                    nextState = Exit1_DR;
                else 
                    nextState = Shift_DR;
            end
            Exit1_DR: begin
                if(TMS == 1)
                    nextState = Update_DR;
                else 
                    nextState = Pause_DR;
            end
            Pause_DR: begin
                if(TMS == 1)
                    nextState = Exit2_DR;
                else 
                    nextState = Pause_DR;
            end
            Exit2_DR: begin
                if(TMS == 1)
                    nextState = Update_DR;
                else 
                    nextState = Shift_DR;
            end
            Update_DR: begin
                if(TMS == 1)
                    nextState = Select_DR_scan;
                else 
                    nextState = Run_test_idle;
            end
            Select_IR_scan: begin
                if(TMS == 1)
                    nextState = Test_logic_reset;
                else 
                    nextState = Capture_IR;
            end
            Capture_IR: begin
                if(TMS == 1)
                    nextState = Exit1_IR;
                else 
                    nextState = Shift_IR;
            end
            Shift_IR: begin
                if(TMS == 1)
                    nextState = Exit1_IR;
                else 
                    nextState = Shift_IR;
            end
            Exit1_IR: begin
                if(TMS == 1)
                    nextState = Update_IR;
                else 
                    nextState = Pause_IR;
            end
            Pause_IR: begin
                if(TMS == 1)
                    nextState = Exit2_IR;
                else 
                    nextState = Pause_IR;
            end
            Exit2_IR: begin
                if(TMS == 1)
                    nextState = Update_IR;
                else 
                    nextState = Shift_IR;
            end
            Update_IR: begin
                if(TMS == 1)
                    nextState = Select_DR_scan;
                else 
                    nextState = Run_test_idle;
            end
        endcase


        //================================================================================
        // Output Function Logic: 
        // we don't need one here, since the only output is the current state that's 
        // already assigned by: assign STATE = currentState;
        //================================================================================
        
    end

endmodule