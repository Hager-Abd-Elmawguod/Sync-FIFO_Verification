module FIFO(FIFO_if.DUT fifo_vif);
	localparam max_fifo_addr = $clog2(fifo_vif.FIFO_DEPTH);
	logic  [fifo_vif.FIFO_WIDTH-1:0] mem [fifo_vif.FIFO_DEPTH-1:0];
	logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
	logic [max_fifo_addr:0] count;
`ifdef SIM
	always_comb begin
		if(!fifo_vif.rst_n) begin
			full_aa: assert final(fifo_vif.full == 0);
			underflow_aa: assert final(fifo_vif.underflow == 0);
			almostfull_aa: assert final(fifo_vif.almostfull == 0);
			almostempty_aa: assert final(fifo_vif.almostempty == 0);
			wr_ack_aa: assert final(fifo_vif.wr_ack == 0);
			overflow_aa: assert final(fifo_vif.overflow == 0);
		end
		if((count == fifo_vif.FIFO_DEPTH))
			full_a: assert final(fifo_vif.full == 1);
		if((count == 0))
			empty_a: assert final(fifo_vif.empty == 1);
		if((count == fifo_vif.FIFO_DEPTH - 1))
			almostfull_a: assert final(fifo_vif.almostfull == 1);
		if((count == 1))
			almostempty_a: assert final(fifo_vif.almostempty == 1);	
	end
	property after_reset_p;
		@(posedge fifo_vif.clk) (!fifo_vif.rst_n)  |=>  ((!wr_ptr) && (!rd_ptr) && (!count));
	endproperty
	// output flags
	property ack_p;
		@(posedge fifo_vif.clk) disable iff (fifo_vif.rst_n == 0) fifo_vif.wr_en && (count < fifo_vif.FIFO_DEPTH) |=> fifo_vif.wr_ack ;
	endproperty

	property overflow_p;
		@(posedge fifo_vif.clk) disable iff (fifo_vif.rst_n == 0) ((count == fifo_vif.FIFO_DEPTH) && fifo_vif.wr_en) |=> (fifo_vif.overflow == 1);
	endproperty

	property underflow_p;
		@(posedge fifo_vif.clk) disable iff (fifo_vif.rst_n == 0) (fifo_vif.empty) && (fifo_vif.rd_en) |=> fifo_vif.underflow;
	endproperty 

	// internal signals
	property wr_ptr_p;
		@(posedge fifo_vif.clk) disable iff (fifo_vif.rst_n == 0) (fifo_vif.wr_en) && (count < fifo_vif.FIFO_DEPTH) |=> (wr_ptr == $past(wr_ptr) + 1'b1);
	endproperty

	property rd_ptr_p;
		@(posedge fifo_vif.clk) disable iff (fifo_vif.rst_n == 0) (fifo_vif.rd_en) && (count != 0) |=> (rd_ptr == $past(rd_ptr) + 1'b1);
	endproperty

	property count_write_priority_p;
		@(posedge fifo_vif.clk) disable iff (fifo_vif.rst_n == 0) (fifo_vif.wr_en) && (fifo_vif.rd_en) && (fifo_vif.empty) |=> (count == $past(count) + 1);
	endproperty

	property count_read_priority_p;
		@(posedge fifo_vif.clk) disable iff (fifo_vif.rst_n == 0) (fifo_vif.wr_en) && (fifo_vif.rd_en) && (fifo_vif.full) |=> (count == $past(count) - 1);
	endproperty

	property count_w_p;
		@(posedge fifo_vif.clk) disable iff (fifo_vif.rst_n == 0) (fifo_vif.wr_en) && (!fifo_vif.rd_en) && (!fifo_vif.full) |=> (count == $past(count) + 1);
	endproperty

	property count_r_p;
		@(posedge fifo_vif.clk) disable iff (fifo_vif.rst_n == 0) (!fifo_vif.wr_en) && (fifo_vif.rd_en) && (!fifo_vif.empty) |=> (count == $past(count) - 1);	
	endproperty

	//  Assertions
	after_reset_a: assert property (after_reset_p);
	ack_a: assert property (ack_p);
	overflow_a: assert property (overflow_p);
	underflow_a: assert property (underflow_p);
	wr_ptr_a: assert property (wr_ptr_p);
	rd_ptr_a: assert property (rd_ptr_p);
	count_write_priority_a: assert property (count_write_priority_p);
	count_read_priority_a: assert property (count_read_priority_p);
	count_w_a: assert property (count_w_p);
	count_r_a: assert property (count_r_p);
	
	// cover
	ack_c: cover property (ack_p);
	overflow_c: cover property (overflow_p);
	underflow_c: cover property (underflow_p);
	wr_ptr_c: cover property (wr_ptr_p);
	rd_ptr_c: cover property (rd_ptr_p);
	count_write_priority_c: cover property (count_write_priority_p);
	count_read_priority_c: cover property (count_read_priority_p);
	count_w_c: cover property (count_w_p);
	count_r_c: cover property (count_r_p);

`endif
	always @(posedge fifo_vif.clk or negedge fifo_vif.rst_n) begin
		if (!fifo_vif.rst_n) begin
			wr_ptr <= 0;
			fifo_vif.wr_ack <= 0; //need to add
			fifo_vif.overflow <= 0; //need to add 
		end
		else if (fifo_vif.wr_en && count < fifo_vif.FIFO_DEPTH) begin
			mem[wr_ptr] <= fifo_vif.data_in;
			fifo_vif.wr_ack <= 1;
			wr_ptr <= wr_ptr + 1;
			fifo_vif.overflow <= 0;
		end
		else begin 
			fifo_vif.wr_ack <= 0; 
			if (fifo_vif.full & fifo_vif.wr_en)
				fifo_vif.overflow <= 1;
			else
				fifo_vif.overflow <= 0;
		end
	end

	always @(posedge fifo_vif.clk or negedge fifo_vif.rst_n) begin
		if (!fifo_vif.rst_n) begin
			rd_ptr <= 0;
			fifo_vif.underflow<=0;//need to add
			fifo_vif.data_out<=0;//need to add
			
		end
		else if (fifo_vif.rd_en && count != 0) begin
			fifo_vif.data_out <= mem[rd_ptr];
			rd_ptr <= rd_ptr + 1;
			fifo_vif.underflow<=0;
		end
		else begin
			if(fifo_vif.empty && fifo_vif.rd_en) // this is sequential output not combinational
				fifo_vif.underflow = 1;
			else 
				fifo_vif.underflow = 0;
		end
	end

	always @(posedge fifo_vif.clk or negedge fifo_vif.rst_n) begin
		if (!fifo_vif.rst_n) begin
			count <= 0;
		end else begin
			if (({fifo_vif.wr_en, fifo_vif.rd_en} == 2'b11) && fifo_vif.full) begin // Only read from full state
				count <= count - 1;
			end else if (({fifo_vif.wr_en, fifo_vif.rd_en} == 2'b11) && fifo_vif.empty) begin// Only write from empty state
				count <= count + 1; 
			end else if	( ({fifo_vif.wr_en, fifo_vif.rd_en} == 2'b10) && !fifo_vif.full) begin
				count <= count + 1;
			end else if ( ({fifo_vif.wr_en, fifo_vif.rd_en} == 2'b01) && !fifo_vif.empty)begin
				count <= count - 1;
			end 
		end
	end

	assign fifo_vif.full = (count == fifo_vif.FIFO_DEPTH)? 1 : 0;
	assign fifo_vif.empty = (count == 0)? 1 : 0;
	//assign underflow = (empty && rd_en)? 1 : 0; 
	//assign almostfull = (count == FIFO_DEPTH-2)? 1 : 0; 
	assign fifo_vif.almostfull = (count == fifo_vif.FIFO_DEPTH-1)? 1 : 0; 
	assign fifo_vif.almostempty = (count == 1)? 1 : 0;



endmodule