

module monitor_counter(interface_counter.MONITOR co_if);
    initial begin
        $monitor("rst_n = %0b,load_n = %0b,up_down = %0b,ce = %0b,data_load = %0b,count_out = %0b,max_count = %0b,zero = %0b",
        co_if.rst_n,co_if.load_n,co_if.up_down,co_if.ce,co_if.data_load,co_if.count_out,co_if.max_count,co_if.zero);
    end
endmodule