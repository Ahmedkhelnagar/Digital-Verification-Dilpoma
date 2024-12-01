vlib work
vlog -f src_files.txt 
vsim -voptargs=+acc work.FIFO_top -classdebug 
add wave /FIFO_top/fifo_if/*  
coverage save FIFO_top.ucdb -onexit 
run -all
