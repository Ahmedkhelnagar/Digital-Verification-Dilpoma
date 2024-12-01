

import alsu_pkg::*;

module ALSU_tb;

    //parameters
    parameter INPUT_PRIORITY = "A";
    parameter FULL_ADDER = "ON";

    //Signals declairation
    //input ports
    bit clk, rst, cin, red_op_A, red_op_B, bypass_A, bypass_B, direction, serial_in;
    opcode_e opcode;
    bit signed[2:0]A,B;
    //output ports
    logic [15:0]leds;
    logic signed[5:0]out;

    //internal signals to register the stimulus for golden model
    bit signed [1:0]cin_reg;
    bit [15:0]exp_leds;
    bit signed[5:0]exp_out;

    //variables
    integer error_count = 0;
    integer correct_count = 0;

    //create object
    alsu_class obj_alsu = new();

    //module instantiations
    ALSU DUT(.*);

    //clock generation
    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    //test stimulus generation
    initial begin
        exp_leds = 16'hffff; // Initialize expected LEDs
        assert_reset;

        //disable constraint no.8 and enable the others
        obj_alsu.unique_valid_opcodes.constraint_mode(0);
        repeat(10000)begin
            assert(obj_alsu.randomize());
            cin = obj_alsu.cin;
            red_op_A = obj_alsu.red_op_A;
            red_op_B = obj_alsu.red_op_B;
            bypass_A = obj_alsu.bypass_A;
            bypass_B = obj_alsu.bypass_B;
            direction = obj_alsu.direction;
            serial_in = obj_alsu.serial_in;
            opcode = obj_alsu.opcode;
            A = obj_alsu.A;
            B = obj_alsu.B;
            rst = obj_alsu.rst;

            if(obj_alsu.rst)begin
                check_out_equal_0();
            end
            else begin
                @(negedge clk)golden_model;
                @(negedge clk)check_result;
                if(!obj_alsu.bypass_A || !obj_alsu.bypass_B)begin
                    obj_alsu.cvr_gp.sample();
                end 
            end

            // my_sample();
        end

        obj_alsu.constraint_mode(0);   //disable all constraints
        obj_alsu.unique_valid_opcodes.constraint_mode(1);   //just enable the unique valid opcode 

        //directed tests(forced To 0)
        //here as specs, we close some inputs
        rst = 0;
        bypass_A = 0;
        bypass_B = 0;
        red_op_A = 0;
        red_op_B = 0;

        repeat(10000)begin
            assert(obj_alsu.randomize());
            //and here randomize some inputs
            cin = obj_alsu.cin;
            direction = obj_alsu.direction;
            serial_in = obj_alsu.serial_in;
            A = obj_alsu.A;
            B = obj_alsu.B;
            //regard the opcode it's a special case must be unique values of the valid opcodes(not rand like normal case)
            for(int i = 0;i < 6;i = i + 1)begin
                opcode = obj_alsu.array_opcode[i];
                obj_alsu.opcode = obj_alsu.array_opcode[i];
                @(negedge clk)golden_model;
                @(negedge clk)check_result;
                obj_alsu.cvr_gp.sample();
                // my_sample();
            end
        end

        $display("correct_count = %0d,error_count = %0d", correct_count, error_count);
        $stop;
    end
    
    /*********************************************
    *
    *           Tasks Implementation           
    *
    **********************************************/
    task assert_reset;
        rst = 1;  //active reset
        //here rst = 1, so when enter the golden model the condition of rst will be activated,so exp_out and exp_leds = 0
        golden_model; 
        check_out_equal_0;
        rst = 0;      //here the rst is toggled from 1 to 0
    endtask

    task check_out_equal_0;
        @(negedge clk);
        if(out !== 0 && leds!== 0) begin
            $display("Error !!");
            error_count = error_count + 1;
        end
        else begin
            correct_count = correct_count + 1;
        end
    endtask

    task check_result;
        if((out !== exp_out) || (leds !== exp_leds))begin
            $display("Error in the output!!,out = %0d,expected_out = %0d,leds = %0d,exp_leds = %0d",
                    out,exp_out,leds,exp_leds);
            error_count = error_count + 1;
            $stop;
        end
        else begin
            correct_count = correct_count + 1;
        end
        if (opcode == SHIFT || opcode ==ROTATE )begin
                golden_model;
            end
        else if (exp_leds == 16'hFFFF)begin
            exp_leds = ~ exp_leds ;
        end
    endtask

     /*****************task to calculate the expected outputs**********/
    task golden_model;
        if(rst)begin
            exp_out = 0;
            exp_leds = 0;
        end
        else begin
            //check invalid cases
            if ((red_op_A || red_op_B) && (opcode != 3'b000) && (opcode != 3'b001)) begin
                exp_leds = ~exp_leds;
                exp_out = 6'b0;
            end
            else if(opcode == INVALID_6 || opcode == INVALID_7)begin
                exp_leds = ~exp_leds;
                exp_out = 6'b0;
            end
            else if (bypass_A && bypass_B) 
                exp_out = (INPUT_PRIORITY == "A") ? A : B;
            else if (bypass_A) 
                exp_out = A;
            else if (bypass_B) 
                exp_out = B;
            else begin
                case (opcode)
                    OR: begin 
                        if (red_op_A && red_op_B) begin
                            exp_out = (INPUT_PRIORITY == "A") ? |A : |B;
                        end else if (red_op_A) begin
                            exp_out = |A;
                        end else if (red_op_B) begin
                            exp_out = |B;
                        end else begin
                            exp_out = A | B;
                        end
                    end
                    XOR: begin 
                        if (red_op_A && red_op_B) begin
                            exp_out = (INPUT_PRIORITY == "A") ? ^A : ^B;
                        end else if (red_op_A) begin
                            exp_out = ^A;
                        end else if (red_op_B) begin
                            exp_out = ^B;
                        end else begin
                            exp_out = A ^ B;
                        end
                    end
                    ADD: begin
                        if (FULL_ADDER == "ON") begin
                            exp_out = A + B + cin;
                        end else begin
                            exp_out = A + B;
                        end
                    end
                    MULTI: begin 
                        exp_out = A * B;
                    end
                    SHIFT: begin
                        exp_out = direction ? {exp_out[4:0], serial_in} : {serial_in, exp_out[5:1]};
                    end
                    ROTATE: begin
                        exp_out = direction ? {exp_out[4:0], exp_out[5]} : {exp_out[0], exp_out[5:1]};
                    end
                endcase
            end
        end 
    endtask //golden model

    /********Task to sample the values***********/
    // task my_sample();
    //     if(obj_alsu.rst || obj_alsu.bypass_A || obj_alsu.bypass_B)begin
    //         obj_alsu.cvr_gp.stop();
    //     end
    //     else begin
    //         obj_alsu.cvr_gp.start();
    //         obj_alsu.cvr_gp.sample();
    //     end
    // endtask
endmodule