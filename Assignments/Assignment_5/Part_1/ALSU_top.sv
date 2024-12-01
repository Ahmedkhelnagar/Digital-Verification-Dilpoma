
import alsu_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module ALSU_top();
    bit clk;

    initial begin
        clk = 0;
        forever begin
            clk = 0;
            #1 clk = ~clk;
        end
    end

        ALSU_interface alsu_if(clk);
        ALSU DUT(clk,alsu_if.rst, alsu_if.cin, alsu_if.red_op_A, alsu_if.red_op_B, alsu_if.bypass_A, alsu_if.bypass_B, alsu_if.direction, alsu_if.serial_in);

        initial begin
            run_test("alsu_test");
        end

endmodule