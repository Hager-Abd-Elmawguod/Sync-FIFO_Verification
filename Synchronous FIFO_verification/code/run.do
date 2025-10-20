  vlib work  
  vlog shared_pkg.sv FIFO_if.sv FIFO_TRANSACTION.sv FIFO_SCOREBOARD.sv FIFO.sv FIFO_COVERAGE.sv FIFO_TEST.sv FIFO_MONITOR.sv FIFO_TOP.sv  +define+SIM +cover
  vsim -voptargs=+acc work.FIFO_top -classdebug -uvmcontrol=a11 -cover 
  run 0	 
  add wave /FIFO_top/fifo_vif/*  
  coverage save FIFO.ucdb -onexit  
  run -all  
  coverage report -details -cvg -directive -codeAll -output coverage_rpt.txt


