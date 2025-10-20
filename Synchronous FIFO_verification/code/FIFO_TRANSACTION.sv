package fifo_transaction_pkg;
    import shared_pkg::*;
    localparam FIFO_WIDTH = 16;
    localparam FIFO_DEPTH = 8;
    int test_finished;
    class FIFO_transaction;
        bit clk;
        rand bit [FIFO_WIDTH-1:0] data_in;
        rand bit rst_n, wr_en, rd_en;
        bit [FIFO_WIDTH-1:0] data_out;
        bit wr_ack, overflow;
        bit full, empty, almostfull, almostempty, underflow;
        int RD_EN_ON_DIST;
        int WR_EN_ON_DIST;

        function new(int REOD = 30, int WEOR = 70);
            RD_EN_ON_DIST = REOD;
            WR_EN_ON_DIST = WEOR;
        endfunction

        constraint reset_con {rst_n dist {0:/2, 1:/98};}
        constraint wr_en_con {wr_en dist {1:=WR_EN_ON_DIST, 0:=(100 - WR_EN_ON_DIST)}; }
        constraint rd_en_con {rd_en dist {1:=RD_EN_ON_DIST, 0:=(100 - RD_EN_ON_DIST)}; }
    endclass
endpackage
