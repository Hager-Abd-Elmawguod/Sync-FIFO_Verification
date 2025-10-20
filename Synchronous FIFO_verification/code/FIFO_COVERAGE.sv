package fifo_coverage_pkg;
    import fifo_transaction_pkg::*;
    class FIFO_coverage;
        FIFO_transaction F_cvg_txn = new;
        covergroup FIFO_Cross_cg;
            // Coverpoints for write enable, read enable, and output control signals
            cp_wr_en     : coverpoint F_cvg_txn.wr_en;
            cp_rd_en     : coverpoint F_cvg_txn.rd_en;
            cp_full         : coverpoint F_cvg_txn.full;
            cp_empty        : coverpoint F_cvg_txn.empty;
            cp_almostfull   : coverpoint F_cvg_txn.almostfull;
            cp_almostempty  : coverpoint F_cvg_txn.almostempty;
            cp_wr_ack       : coverpoint F_cvg_txn.wr_ack;
            cp_overflow     : coverpoint F_cvg_txn.overflow;
            cp_underflow    : coverpoint F_cvg_txn.underflow;
            //Create cross coverage between write/read enable and each control signal 
            cross_wr_rd_full        : cross cp_wr_en, cp_rd_en, cp_full { illegal_bins one_r_one = binsof(cp_rd_en) intersect {1} && binsof(cp_full) intersect {1}; }
            cross_wr_rd_empty       : cross cp_wr_en, cp_rd_en, cp_empty;
            cross_wr_rd_almostfull  : cross cp_wr_en, cp_rd_en, cp_almostfull;
            cross_wr_rd_almostempty : cross cp_wr_en, cp_rd_en, cp_almostempty;
            cross_wr_rd_wr_ack      : cross cp_wr_en, cp_rd_en, cp_wr_ack {illegal_bins zero_zero_one = binsof(cp_wr_en) intersect {0} && binsof(cp_wr_ack) intersect {1}; }
            cross_wr_rd_overflow    : cross cp_wr_en, cp_rd_en, cp_overflow {illegal_bins zero_w_one = binsof(cp_wr_en) intersect {0}  &&binsof(cp_overflow) intersect {1}; }
            cross_wr_rd_underflow   : cross cp_wr_en, cp_rd_en, cp_underflow {illegal_bins zero_r_one = binsof(cp_rd_en) intersect {0} && binsof(cp_underflow) intersect {1};}
        endgroup
        function new();
            FIFO_Cross_cg = new();
        endfunction
        function void sample_data(FIFO_transaction F_txn);
            F_cvg_txn = F_txn;
            FIFO_Cross_cg.sample();
        endfunction
    endclass
endpackage

