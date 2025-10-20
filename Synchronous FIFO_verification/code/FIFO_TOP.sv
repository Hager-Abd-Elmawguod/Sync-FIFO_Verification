import shared_pkg::*;
module FIFO_top();
    bit clk;
    initial begin
        clk = 0; forever #10 clk = ~clk;
    end
    FIFO_if fifo_vif (clk);
    FIFO dut (fifo_vif);
    fifo_tb tb (fifo_vif);
    fifo_monitor MONITOR (fifo_vif);

    always_comb  begin 
        if (!dut.fifo_vif.rst_n)
        a_reset :  assert final( !dut.fifo_vif.wr_ack && !dut.fifo_vif.overflow && !dut.fifo_vif.underflow  );
    end
endmodule