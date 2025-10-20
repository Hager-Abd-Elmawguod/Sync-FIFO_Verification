import shared_pkg::*;
import fifo_transaction_pkg::*;
import fifo_coverage_pkg::*;
import fifo_scoreboard_pkg::*;
module fifo_monitor (FIFO_if.MONITOR fifo_vif);
    FIFO_transaction tr_mon = new(); 
    FIFO_coverage cov_mon = new(); 
    FIFO_scoreboard scb_mon = new(); 

    initial begin
        forever begin
            wait(trigger.triggered);
            @(negedge fifo_vif.clk);
            tr_mon.data_in = fifo_vif.data_in;
            tr_mon.rst_n = fifo_vif.rst_n;
            tr_mon.wr_en = fifo_vif.wr_en;
            tr_mon.rd_en = fifo_vif.rd_en; 
            tr_mon.data_out = fifo_vif.data_out;
            tr_mon.wr_ack = fifo_vif.wr_ack;
            tr_mon.overflow = fifo_vif.overflow;
            tr_mon.full = fifo_vif.full;
            tr_mon.empty = fifo_vif.empty;
            tr_mon.almostfull = fifo_vif.almostfull;
            tr_mon.almostempty = fifo_vif.almostempty;
            tr_mon.underflow = fifo_vif.underflow;

            fork 
                cov_mon.sample_data(tr_mon);
                scb_mon.check_data(tr_mon); 
            join

            if (test_finished) begin
                $display("error count = %0d, correct count = %0d", error_count, correct_count);
                $stop;
            end
        end
    end
endmodule