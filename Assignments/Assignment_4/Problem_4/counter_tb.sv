

import pkg_constraint::*;

module counter_tb(interface_counter.TEST co_if);
    //Create object from the class
    constraints obj = new();

    //Test stimulus generation
    initial begin
        co_if.load_n = 1;
        co_if.up_down = 0;
        co_if.ce = 0;
        
        assert_reset;
        repeat(10000)begin
            assert(obj.randomize());
            co_if.rst_n = obj.rst_n;
            co_if.load_n = obj.load_n;
            co_if.up_down = obj.up_down;
            co_if.ce = obj.ce;
            co_if.data_load = obj.data_load;
            @(negedge co_if.clk);
        end
        $stop;
    end
    /*********************************************
    *
    *           Tasks Implementation           
    *
    **********************************************/
    task assert_reset;
        co_if.rst_n = 1;
        @(negedge co_if.clk); //here the rst is toggled from 0 to 1 
        co_if.rst_n = 0;  //active reset
        @(negedge co_if.clk); //here the rst is toggled from 0 to 1 
        co_if.rst_n = 1;        //here the rst is toggled from 1 to 0
    endtask
endmodule