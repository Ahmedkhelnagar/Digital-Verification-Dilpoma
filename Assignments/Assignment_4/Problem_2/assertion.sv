

property check_b_after_a;
    (@(posedge clk) a |->##2 b);
endproperty
assert property(check_b_after_a);

====================
property check_c_after_a_and_b
    (@(posedge clk) (a&&b) |=> [1:3] c);
endproperty
assert property(check_c_after_a_and_b);
====================

sequence s11b
    ##2 !b;
endsequence
====================
property check_one_hot_Y
    @(posedge clk) $onehot(Y);
endproperty

assert property(check_one_hot_Y);
====================
property check_low_valid
    (@(posedge clk) (D == 4'b0000) |-> ##1 !valid);
endproperty

assert property(check_low_valid);
