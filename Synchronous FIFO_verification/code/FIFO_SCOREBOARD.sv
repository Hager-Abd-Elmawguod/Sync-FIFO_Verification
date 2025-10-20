package fifo_scoreboard_pkg;
    import shared_pkg::*;
    import fifo_transaction_pkg::*;
    localparam FIFO_WIDTH = 16;
    localparam FIFO_DEPTH = 8;
    int size;
    class FIFO_scoreboard;
        // Reference model variables
        bit almostfull_ref,full_ref;
        bit almostempty_ref,empty_ref;
        bit overflow_ref,underflow_ref;
        bit wr_ack_ref;
        bit [FIFO_WIDTH-1:0]data_out_ref;

        bit [FIFO_WIDTH-1:0] mem [$];
        int count = 0 ;
        
        int test_finished;

        
        task check_data(FIFO_transaction trans);
        reference_model(trans);
        if (  trans.data_out!==data_out_ref) begin
            error_count++;
            $display("[SCOREBOARD][ERROR] Mismatch at time %0t:", $time);
            $display("  Expected: data_out=%0h full=%0b empty=%0b almostfull=%0b almostempty=%0b wr_ack=%0b overflow=%0b underflow=%0b",
                    data_out_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, wr_ack_ref, overflow_ref, underflow_ref);
            $display("  Got:      data_out=%0h full=%0b empty=%0b almostfull=%0b almostempty=%0b wr_ack=%0b overflow=%0b underflow=%0b\n",
                    trans.data_out, trans.full, trans.empty, trans.almostfull, trans.almostempty, trans.wr_ack, trans.overflow, trans.underflow);
        end
        else begin
            correct_count++;
            $display("[SCOREBOARD][Correct] Match at time %0t:", $time);
            $display("  Expected: data_out=%0h full=%0b empty=%0b almostfull=%0b almostempty=%0b wr_ack=%0b overflow=%0b underflow=%0b",
                    data_out_ref, full_ref, empty_ref, almostfull_ref, almostempty_ref, wr_ack_ref, overflow_ref, underflow_ref);
            $display("  Got:      data_out=%0h full=%0b empty=%0b almostfull=%0b almostempty=%0b wr_ack=%0b overflow=%0b underflow=%0b\n",
                    trans.data_out, trans.full, trans.empty, trans.almostfull, trans.almostempty, trans.wr_ack, trans.overflow, trans.underflow);
        end
        endtask

        task reference_model(input FIFO_transaction tr_ref);
            if (tr_ref.rst_n) begin
                if (tr_ref.wr_en && !tr_ref.rd_en && count < FIFO_DEPTH) begin
                    mem.push_front(tr_ref.data_in);  // Write data into memory
                    count++;  // Increment count
                end
                else if (!tr_ref.wr_en && tr_ref.rd_en && count != 0) begin
                    data_out_ref = mem.pop_back;  // Read data from memory
                    count--;  // Decrement count
                end
                else if (tr_ref.wr_en && tr_ref.rd_en && count > 0 && count < FIFO_DEPTH) begin
                    mem.push_front(tr_ref.data_in);  // Write and Read simultaneously
                    data_out_ref = mem.pop_back;
                    count = count;  // Count remains unchanged
                end
                else if (tr_ref.wr_en && tr_ref.rd_en && count == FIFO_DEPTH) begin
                    data_out_ref = mem.pop_back;  // Read when FIFO is full
                    count--;  // Decrement count as a read is happening
                end
                else if (tr_ref.wr_en && tr_ref.rd_en && count == 0) begin
                    mem.push_front(tr_ref.data_in);  // Write when FIFO is empty
                    count++;  // Increment count as a write is happening
                end
            end
            else if (!tr_ref.rst_n) begin
                mem.delete;  // Reset memory
                count = 0;   // Reset count
                data_out_ref=0;
            end
        endtask
    endclass
endpackage


