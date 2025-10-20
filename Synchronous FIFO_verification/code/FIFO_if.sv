import shared_pkg::*;
interface FIFO_if (clk);    
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    input bit clk;
    bit wr_en, rd_en, rst_n, full, empty, almostfull,almostempty, wr_ack, overflow, underflow;
    bit [FIFO_WIDTH-1:0] data_in , data_out ;
 
    modport DUT (input clk, data_in, rst_n, wr_en, rd_en,output data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
    modport TEST (output data_in, rst_n, wr_en, rd_en,input clk, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
    modport MONITOR (input clk, data_in, rst_n, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
    
endinterface

