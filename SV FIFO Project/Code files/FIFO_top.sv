

module FIFO_top;
    bit clk;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    fifo_interface fifo_if(clk);
    FIFO d1(fifo_if);
    FIFO_TEST tb1(fifo_if);
    FIFO_monitor mon(fifo_if);
endmodule