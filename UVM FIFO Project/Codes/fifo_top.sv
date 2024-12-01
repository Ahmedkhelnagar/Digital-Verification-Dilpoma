

import uvm_pkg::*;
`include"uvm_macros.svh"

import fifo_test_pkg::*;

module fifo_top();
    bit clk;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    fifo_interface fifo_if(clk);
    FIFO DUT(fifo_if);

    //Bind Assertion(correlate the assertion with the design)
    bind FIFO fifo_sva sva_inst(fifo_if);

    initial begin
        uvm_config_db #(virtual fifo_interface)::set(null,"uvm_test_top","FIFO_IF",fifo_if);
        run_test("fifo_test");
    end
endmodule

