

import pkg_constraint::*;

module counter_tb;
    //Create object from the class
    constraints obj = new();

    //Signals declairation
    //Input Ports
    bit clk,rst_n,load_n,up_down,ce;
    bit [WIDTH-1 : 0]data_load;
    //Output Ports
    logic [WIDTH-1 : 0]count_out;
    logic max_count;
    logic zero;

    //Internal signals
    logic [WIDTH-1 : 0]expected_count_out;
    logic [WIDTH -1 : 0]tmp;
    logic expected_zero,expected_max_count;
    //Variables
    integer error_count = 0;
    integer correct_count = 0;
    
    //Instantiation module
    counter DUT(.*);

    //Clock generation
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    //Test stimulus generation
    initial begin
        load_n = 1;
        up_down = 0;
        ce = 0;
        
        assert_reset;
        repeat(10000)begin
            assert(obj.randomize());
            rst_n = obj.rst_n;
            load_n = obj.load_n;
            up_down = obj.up_down;
            ce = obj.ce;
            data_load = obj.data_load;
            check_result;
        end
        $display("correct_count = %0d,error_count = %0d", correct_count, error_count);
        $stop;
    end
    
    /**Expected count out**/
    /**Assign not work correctly***/
    // assign tmp = (!load_n) ? data_load : 
    // (ce ? (up_down ? (count_out + 1) : (count_out - 1)) : count_out);

    // assign expected_count_out = tmp;
    // assign expected_max_count = (expected_count_out == {WIDTH{1'b1}} ? 1 : 0);
    // assign expected_zero = (expected_count_out == 0 ? 1 : 0);

    //Golden Model
    task golden_model;
        if(!rst_n)begin
            expected_count_out = 0;
        end
        else if(!load_n)begin
            expected_count_out = data_load;
        end
        else if(ce)begin
            if(up_down)begin
                expected_count_out = expected_count_out + 1;
            end
            else begin
                expected_count_out = expected_count_out - 1;
            end
        end
        assign expected_max_count = (expected_count_out == {WIDTH{1'b1}} ? 1 : 0);
        assign expected_zero = (expected_count_out == 0 ? 1 : 0);
    endtask

    /*********************************************
    *
    *           Tasks Implementation           
    *
    **********************************************/
    task check_result;
        golden_model;
        @(negedge clk);
        if((count_out !== expected_count_out) || (max_count !== expected_max_count) || (zero !== expected_zero))begin
            $display("Error in the output!!,counter_out = %0d,expected_count_out = %0d",
                    count_out,expected_count_out);
            error_count = error_count + 1;
            $stop;
        end
        else begin
            correct_count = correct_count + 1;
        end
    endtask

    task assert_reset;
        rst_n = 1;
        @(negedge clk); //here the rst is toggled from 0 to 1 
        rst_n = 0;  //active reset
        check_out_equal_0;
        rst_n = 1;        //here the rst is toggled from 1 to 0
    endtask

    task check_out_equal_0;
        @(negedge clk);
        if(count_out !== 0 && max_count !==0 && zero !==0)begin
            $display("Error !!");
            error_count = error_count + 1;
        end
        else begin
            correct_count = correct_count + 1;
        end
    endtask
endmodule