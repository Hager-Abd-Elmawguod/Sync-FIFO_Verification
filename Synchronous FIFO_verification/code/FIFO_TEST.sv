import shared_pkg::*;
import fifo_transaction_pkg::*;

module fifo_tb (FIFO_if.TEST fifo_vif);
    FIFO_transaction tr_tb = new();

    initial begin
        // reset label 
        test_finished = 0;
        fifo_vif.rst_n = 0;
        @(negedge fifo_vif.clk);
        ->trigger; 
        fifo_vif.rst_n = 1;
        @(negedge fifo_vif.clk);
        ->trigger; 
        repeat(10000) begin
            
            assert(tr_tb.randomize());
            //getting randomized variables
            fifo_vif.data_in = tr_tb.data_in;
            fifo_vif.wr_en = tr_tb.wr_en;
            fifo_vif.rd_en = tr_tb.rd_en;
            fifo_vif.rst_n = tr_tb.rst_n; 
            @(negedge fifo_vif.clk);
            ->trigger; 
        end
        test_finished = 1;
    end
endmodule