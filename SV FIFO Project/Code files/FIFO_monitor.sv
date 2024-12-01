
import transaction_pkg::*;
import FIFO_scoreboard::*;
import coverage_pkg::*;
import shared_pkg::*;

module FIFO_monitor(fifo_interface.MONITOR fifo_if);
    
FIFO_transaction txn;
FIFO_coverage cov;
fifo_scoreboard scr;

initial begin
    txn = new();
    cov = new();
    scr = new();

    forever begin
        @(negedge fifo_if.clk);
        /***sample here the data of the interface**/

        // txn.clk = fifo_if.clk;
        txn.data_in = fifo_if.data_in;
        txn.rst_n = fifo_if.rst_n;
        txn.wr_en = fifo_if.wr_en;
        txn.rd_en = fifo_if.rd_en;
        txn.data_out = fifo_if.data_out;
        txn.wr_ack = fifo_if.wr_ack;
        txn.overflow = fifo_if.overflow;
        txn.full = fifo_if.full;
        txn.empty = fifo_if.empty;
        txn.almostfull = fifo_if.almostfull;
        txn.almostempty = fifo_if.almostempty;
        txn.underflow = fifo_if.underflow;
        
        //delay
        // @(negedge txn.clk);
        // #0;
        fork begin
            // @(negedge fifo_if.clk);
            @(posedge fifo_if.clk);
            cov.sample_data(txn);
        end
        begin
            // @(negedge fifo_if.clk);
            @(posedge fifo_if.clk);
            scr.check_data(txn);
        end
        join
        if(shared_pkg_c::test_finished)begin
            $display("Test Finished,correct count = %0d,Error count = %0d",shared_pkg_c::correct_count,shared_pkg_c::error_count);
            $stop;
        end
    end
end

endmodule