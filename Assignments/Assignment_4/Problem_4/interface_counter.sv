

interface interface_counter(clk);
    parameter WIDTH = 4;
    input clk;
    logic rst_n;
    logic load_n;
    logic up_down;
    logic ce;
    logic [WIDTH-1:0] data_load;
    logic [WIDTH-1:0] count_out;
    logic max_count;
    logic zero;

    modport DUT(input clk,rst_n,load_n,up_down,ce,data_load,output count_out,max_count,zero);
    modport TEST(output rst_n,load_n,up_down,ce,data_load,input clk,count_out,max_count,zero);
    modport MONITOR(input clk,rst_n,load_n,up_down,ce,data_load,count_out,max_count,zero);
endinterface