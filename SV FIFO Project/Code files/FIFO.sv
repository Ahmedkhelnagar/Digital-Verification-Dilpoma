////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(fifo_interface.DUT fifo_if);

parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;

localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		wr_ptr <= 0;
		fifo_if.wr_ack <= 0;	//added
		fifo_if.overflow <= 0;	//added
		fifo_if.underflow <= 0;	//added
	end
	else if (fifo_if.wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= fifo_if.data_in;
		fifo_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else if((fifo_if.wr_en && fifo_if.rd_en && fifo_if.empty))begin	//added
		mem[wr_ptr] <= fifo_if.data_in;
		fifo_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin
		fifo_if.wr_ack <= 0; 
		if (fifo_if.full && fifo_if.wr_en)
			fifo_if.overflow <= 1;
		else if(fifo_if.empty && fifo_if.rd_en)	//added
			fifo_if.underflow <= 1;
		else begin
			fifo_if.overflow <= 0;
			fifo_if.underflow <= 0;		//added
		end
	end
end

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		rd_ptr <= 0;
		// fifo_if.data_out <= 0; 
	end
	else if (fifo_if.rd_en && count != 0) begin
		fifo_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else if(fifo_if.wr_en && fifo_if.rd_en && fifo_if.full)begin		//added
		fifo_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
end

always @(posedge fifo_if.clk or negedge fifo_if.rst_n) begin
	if (!fifo_if.rst_n) begin
		count <= 0;
	end
	else begin
		if(({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && fifo_if.empty)begin	//write
			count <= count + 1;
		end
		else if(({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && fifo_if.full)begin	//read
			count <= count - 1;
		end
		else if	( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b10) && !fifo_if.full)begin //write
			count <= count + 1;
		end
		else if ( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b01) && !fifo_if.empty)begin	//read
			count <= count - 1;
		end
		
		
		// else if( ({fifo_if.wr_en, fifo_if.rd_en} == 2'b10) && fifo_if.full)begin	//no change(couunt = max)
		// 	count <= count;
		// end
		// else if(({fifo_if.wr_en, fifo_if.rd_en} == 2'b01) && fifo_if.empty)begin	//no change(count = 0)
		// 	count <= 0;
		// end
		// else if(({fifo_if.wr_en, fifo_if.rd_en} == 2'b11) && !fifo_if.full && !fifo_if.empty)begin
		// 	count <= count - 1;
		// 	count <= count + 1;		//the count will be the same value eventually
		// end
	end
end

assign fifo_if.full = (count == FIFO_DEPTH)? 1 : 0;
assign fifo_if.empty = (count == 0)? 1 : 0;
assign fifo_if.almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 
assign fifo_if.almostempty = (count == 1)? 1 : 0;


/****Assertions*****/
//assert on all the output signals except the fifo_if.data_out signal + the internal signals
/**fifo_if.full**/
property full_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.wr_en && count >= FIFO_DEPTH) |=> fifo_if.full; 
endproperty
assert property(full_p);
cover property(full_p);

/**almostfifo_design.full**/
property almostfull_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (count == (FIFO_DEPTH-1)) |=> fifo_if.almostfull;
endproperty
assert property(almostfull_p);
cover property(almostfull_p);

/**fifo_if.empty**/
property empty_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.rd_en && (count == 0)) |=> fifo_if.empty;
endproperty
assert property (empty_p);
cover property (empty_p);

/**almostempty**/
property almostempty_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (count == 1) |=> fifo_if.almostempty;
endproperty
assert property (almostempty_p);
cover property (almostempty_p);

/**fifo_if.overflow**/
property overflow_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.full && fifo_if.wr_en) |=> fifo_if.overflow;
endproperty
assert property (overflow_p);
cover property (overflow_p);

/**fifo_if.underflow**/
property underflow_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.empty && fifo_if.rd_en) |=> fifo_if.underflow;
endproperty
assert property (underflow_p);
cover property (underflow_p);

/**fifo_if.wr_ack**/
property wr_ack_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.wr_en && (!fifo_if.full)) |=> fifo_if.wr_ack;
endproperty
assert property (wr_ack_p);
cover property (wr_ack_p);

/**count**/
property inc_count_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.wr_en && (!fifo_if.full)) |=> (count == $past(count) + 1);
endproperty
assert property(inc_count_p);
cover property(inc_count_p);

property dec_count_p;
	@(posedge fifo_if.clk) disable iff(!fifo_if.rst_n) (fifo_if.rd_en && (!fifo_if.empty)) |=> (count == $past(count) - 1);
endproperty
assert property(dec_count_p);
cover property(dec_count_p);


always_comb begin
	if(!fifo_if.rst_n)begin
		co_assert:assert final (count == 0);
			// else $fatal("count is not equal zero when asserted the reset");
		wr_assert:assert final (wr_ptr == 0);
			// else $fatal("wr pointer is not equal zero when asserted the reset");
		rd_assert:assert final (rd_ptr == 0);
			// else $fatal("rd pointer is not equal zero when asserted the reset");
	end
end

// `ifdef SIM
//         assert_property (@(posedge fifo_if.clk) !(fifo_if.wr_en && fifo_if.full) || !fifo_if.overflow) else $fatal("fifo_if.overflow error");
//         assert_property (@(posedge fifo_if.clk) !(fifo_if.rd_en && fifo_if.empty) || !fifo_if.underflow) else $fatal("fifo_if.underflow error");
//         assert_property (@(posedge fifo_if.clk) !(count == FIFO_DEPTH && !fifo_if.full)) else $fatal("fifo_if.full flag error");
//         assert_property (@(posedge fifo_if.clk) !(count == 0 && !fifo_if.empty)) else $fatal("fifo_if.empty flag error");
//     `endif

endmodule