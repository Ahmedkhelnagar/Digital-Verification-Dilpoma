
package transaction_pkg;
    
    class FIFO_transaction;
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
        //Class variables
        logic clk;
        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic rst_n, wr_en, rd_en;
        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow,full, empty, almostfull, almostempty, underflow;

        //Internal Signals
        integer count = 0;
        bit [2:0]wr_ptr_tr,rd_ptr_tr;
        
        //variables
        integer RD_EN_ON_DIST;
        integer WR_EN_ON_DIST;

        //Constructor
        function new(integer RD_EN_ON_DIST = 30, integer WR_EN_ON_DIST = 70);
            this.RD_EN_ON_DIST = RD_EN_ON_DIST;
            this.WR_EN_ON_DIST = WR_EN_ON_DIST;
        endfunction

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
    endclass

endpackage