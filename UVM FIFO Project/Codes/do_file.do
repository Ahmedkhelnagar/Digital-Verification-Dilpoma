vlib work
vlog -f src.txt
vsim -voptargs=+acc work.fifo_top -classdebug -uvmcontrol=all
add wave /fifo_top/fifo_if/*
coverage save fifo_top.ucdb -onexit 
run -all