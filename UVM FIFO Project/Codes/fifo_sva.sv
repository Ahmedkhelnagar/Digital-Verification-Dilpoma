
module fifo_sva(fifo_interface.DUT fifo_if);
   parameter FIFO_WIDTH = 16;
   parameter FIFO_DEPTH = 8;

property overflow_1_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) ((DUT.count == FIFO_DEPTH) && fifo_if.wr_en) |=> fifo_if.overflow;
endproperty
property overflow_0_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) ((DUT.count != FIFO_DEPTH) && fifo_if.wr_en) |=> (fifo_if.overflow == 0);
endproperty
assert property (overflow_1_p);
assert property (overflow_0_p);
cover property (overflow_1_p);
cover property (overflow_0_p);

/**fifo_if.underflow**/
property underflow_1_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) ((DUT.count == 0) && fifo_if.rd_en) |=> fifo_if.underflow;
endproperty
property underflow_0_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) ((DUT.count != 0) && fifo_if.rd_en) |=> (fifo_if.underflow == 0);
endproperty
assert property (underflow_1_p);
assert property (underflow_0_p);
cover property (underflow_1_p);
cover property (underflow_0_p);

/**fifo_if.wr_ack**/
property wr_ack_1_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.wr_en && (DUT.count != FIFO_DEPTH)) |=> fifo_if.wr_ack;
endproperty
property wr_ack_0_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.wr_en && (DUT.count == FIFO_DEPTH)) |=> (fifo_if.wr_ack == 0);
endproperty
assert property (wr_ack_1_p);
assert property (wr_ack_0_p);
cover property (wr_ack_1_p);
cover property (wr_ack_0_p);


/**********************Assertion on Combinational signals*******************/

/**fifo_if.full**/
property full_1_p;
	@(posedge fifo_if.clk) (fifo_if.wr_en && DUT.count == FIFO_DEPTH) |-> fifo_if.full; 
endproperty
property full_0_p;
	@(posedge fifo_if.clk) (fifo_if.wr_en && DUT.count != FIFO_DEPTH) |-> (fifo_if.full == 0); 
endproperty
assert property(full_1_p);
assert property(full_0_p);
cover property(full_1_p);
cover property(full_0_p);

/**almostfifo_design.full**/
property almostfull_1_p;
	@(posedge fifo_if.clk) (DUT.count == (FIFO_DEPTH-1)) |-> fifo_if.almostfull;
endproperty
property almostfull_0_p;
	@(posedge fifo_if.clk) (DUT.count != (FIFO_DEPTH-1)) |-> (fifo_if.almostfull == 0);
endproperty
assert property(almostfull_1_p);
assert property(almostfull_0_p);
cover property(almostfull_1_p);
cover property(almostfull_0_p);

/**fifo_if.empty**/
property empty_1_p;
	@(posedge fifo_if.clk) (DUT.count == 0) |-> fifo_if.empty;
endproperty
property empty_0_p;
	@(posedge fifo_if.clk) (DUT.count != 0) |-> (fifo_if.empty == 0);
endproperty
assert property (empty_1_p);
assert property (empty_0_p);
cover property (empty_1_p);
cover property (empty_0_p);

/**almostempty**/
property almostempty_1_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (DUT.count == 1) |-> fifo_if.almostempty;
endproperty
property almostempty_0_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (DUT.count != 1) |-> (fifo_if.almostempty == 0);
endproperty
assert property (almostempty_1_p);
assert property (almostempty_0_p);
cover property (almostempty_1_p);
cover property (almostempty_0_p);

/********************Assertion on counters**********************/
property inc_count_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.wr_en && !fifo_if.rd_en && (DUT.count != FIFO_DEPTH)) |=> (DUT.count == $past(DUT.count) + 1'b1);
endproperty
property dec_count_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (!fifo_if.wr_en && fifo_if.rd_en && (DUT.count != 0)) |=> (DUT.count == $past(DUT.count) - 1'b1);
endproperty
property same_count_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.wr_en && fifo_if.rd_en && (DUT.count != 0) && (DUT.count != FIFO_DEPTH)) |=> (DUT.count == $past(DUT.count));
endproperty
assert property(inc_count_p);
assert property(dec_count_p);
assert property(same_count_p);
cover property(inc_count_p);
cover property(dec_count_p);
cover property(same_count_p);


/*******************Assertion on pointers**************************/
property wr_ptr_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.wr_en && (DUT.count != FIFO_DEPTH)) |=> DUT.wr_ptr == $past(DUT.wr_ptr) + 1'b1;
endproperty
property rd_ptr_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.rd_en && (DUT.count != 0)) |=> DUT.rd_ptr == $past(DUT.rd_ptr) + 1'b1;
endproperty

assert property(wr_ptr_p);
assert property(rd_ptr_p);
cover property(wr_ptr_p);
cover property(rd_ptr_p);

always_comb begin
	if(!fifo_if.rst_n)begin
		rst_co_assert:assert final (DUT.count == 0);
		rst_wr_assert:assert final (DUT.wr_ptr == 0);
		rst_rd_assert:assert final (DUT.rd_ptr == 0);
		// rst_full_assert        :assert final (fifo_if.full        == 0);
		// rst_empty_assert       :assert final (fifo_if.empty       == 1);
		// rst_almostfull_assert  :assert final (fifo_if.almostfull  == 0);
		// rst_almostempty_assert :assert final (fifo_if.almostempty == 0);
		// rst_overflow_assert    :assert final (fifo_if.overflow    == 0);
		// rst_underflow_assert   :assert final (fifo_if.underflow   == 0);
		// rst_wr_ack_assert      :assert final (fifo_if.wr_ack      == 0);
	end
end


endmodule