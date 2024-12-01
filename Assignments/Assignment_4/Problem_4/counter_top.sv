

module counter_top;
    bit clk;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~clk;
        end
    end

    interface_counter co_if(clk);
    counter d1(co_if);
    counter_tb tb1(co_if);
    bind counter counter_sva counter_sva_instance(co_if); 

endmodule