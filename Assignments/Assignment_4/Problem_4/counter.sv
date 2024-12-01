////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: Counter Design 
// 
////////////////////////////////////////////////////////////////////////////////
module counter (interface_counter.DUT co_if);

always @(posedge co_if.clk or negedge co_if.rst_n) begin
    if(!co_if.rst_n)
        co_if.count_out <= 0;
    else if (!co_if.load_n)
        co_if.count_out <= co_if.data_load;
    else if (co_if.ce)
        if (co_if.up_down)
            co_if.count_out <= co_if.count_out + 1;
        else 
            co_if.count_out <= co_if.count_out - 1;
end

assign co_if.max_count = (co_if.count_out == {co_if.WIDTH{1'b1}})? 1:0;
assign co_if.zero = (co_if.count_out == 0)? 1:0;

endmodule