

module FIFO_TEST(fifo_interface.TEST fifo_if);
import shared_pkg::*;
import transaction_pkg::*;

    FIFO_transaction obj= new();

    //Test Stimulus generation
    initial begin
        fifo_if.rst_n = 0;
        // fifo_if.data_in = 0;
        // fifo_if.wr_en = 0;
        // fifo_if.rd_en = 0;  
        @(negedge fifo_if.clk);
        fifo_if.rst_n = 1;

        repeat(1000)begin
          assert(obj.randomize());
          fifo_if.data_in = obj.data_in; 
          fifo_if.rst_n = obj.rst_n; 
          fifo_if.wr_en = obj.wr_en; 
          fifo_if.rd_en = obj.rd_en; 
          @(negedge fifo_if.clk); 
        end
        shared_pkg_c::test_finished = 1;
    end
endmodule