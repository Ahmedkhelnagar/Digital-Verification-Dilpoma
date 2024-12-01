

module counter_sva(interface_counter.DUT co_if);
   always_comb begin
        if(!co_if.rst_n)
            a_reset:assert final(co_if.count_out == 0); //at the same instant
        if(co_if.count_out == 0)
            a_zero:assert (co_if.zero == 1);
        if(co_if.count_out == {co_if.WIDTH{1'b1}})
            a_maxCount:assert (co_if.max_count == 1);
    end

    property p_load_active;
        @(posedge co_if.clk) disable iff(!co_if.rst_n) (!co_if.load_n) |=> (co_if.count_out == $past(co_if.data_load));
    endproperty

    property p_load_not_active;
        @(posedge co_if.clk) disable iff(!co_if.rst_n) (co_if.load_n && !co_if.ce) |=> (co_if.count_out == $past(co_if.count_out)); 
    endproperty

    property increment_count;
        @(posedge co_if.clk) disable iff(!co_if.rst_n) (co_if.load_n && co_if.ce && co_if.up_down) |=> (co_if.count_out == ($past(co_if.count_out) + 1'b1));  
    endproperty

    property decrement_count;
        @(posedge co_if.clk) disable iff(!co_if.rst_n) (co_if.load_n && co_if.ce && !co_if.up_down) |=> (co_if.count_out == ($past(co_if.count_out) - 1'b1));  
    endproperty

    assert_load_active:assert property(p_load_active);
    assert_load_not_active:assert property(p_load_not_active);
    assert_increment_count:assert property(increment_count);
    assert_decrement_count:assert property(decrement_count);

    cover_load_active:cover property(p_load_active);
    cover_load_not_active:cover property(p_load_not_active);
    cover_increment_count:cover property(increment_count);
    cover_decrement_count:cover property(decrement_count);
endmodule