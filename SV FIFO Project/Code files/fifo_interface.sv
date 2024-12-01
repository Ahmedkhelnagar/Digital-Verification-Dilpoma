

    interface fifo_interface(clk);
        /*******Parameters******/
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
        /*****Signals ports*****/
        input bit clk;
        logic [FIFO_WIDTH-1:0] data_in;
        logic rst_n, wr_en, rd_en;
        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow,full, empty, almostfull, almostempty, underflow;

        modport DUT(input clk,data_in,rst_n, wr_en, rd_en,output data_out,wr_ack, overflow,full, empty, almostfull, almostempty, underflow);
        modport TEST(input clk,data_out,wr_ack, overflow,full, empty, almostfull, almostempty, underflow,output data_in,rst_n, wr_en, rd_en);
        modport MONITOR(input clk,data_in,rst_n, wr_en, rd_en,data_out,wr_ack, overflow,full, empty, almostfull, almostempty, underflow);

    endinterface