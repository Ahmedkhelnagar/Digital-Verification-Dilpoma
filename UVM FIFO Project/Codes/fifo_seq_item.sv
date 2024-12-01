

package fifo_seq_item_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class fifo_seq_item extends uvm_sequence_item;
        `uvm_object_utils(fifo_seq_item);
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic rst_n, wr_en, rd_en;
        logic [FIFO_WIDTH-1:0]data_out;
        logic wr_ack, overflow,full, empty, almostfull, almostempty, underflow;

        integer RD_EN_ON_DIST = 30;
        integer WR_EN_ON_DIST = 70;

        
        //Constraints
        constraint rst_n_cons
        {
            rst_n dist{0:=2,1:=98}; //active low
        }
        constraint write_en_cons
        {
            wr_en dist{1:=WR_EN_ON_DIST,0:=(100-WR_EN_ON_DIST)};
        }
        constraint read_en_cons
        {
            rd_en dist{1:=RD_EN_ON_DIST,0:=(100-RD_EN_ON_DIST)};
        }    

        function new(string name = "fifo_seq_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("%s reset = %0d,datain = %0d,wr_en = %0d,rd_en = %0d,data_out = %0d,wr_ack = %0d,overflow = %0d,full = %0d,empty = %0d,almostfull = %0d,almostempty = %0d,underflow = %0d",super.convert2string(),
            rst_n,data_in,wr_en,rd_en,data_out,wr_ack,overflow,full,empty,almostfull,almostempty,underflow);
        endfunction

        function string convert2string_stimulus();
            return $sformatf("reset = %0d,datain = %0d,wr_en = %0d,rd_en = %0d",rst_n,data_in,wr_en,rd_en);
        endfunction
    endclass


endpackage 