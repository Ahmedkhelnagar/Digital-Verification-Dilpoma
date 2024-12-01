vlib work
vlog ram.sv ram_tb.sv  +cover -covercells
vsim -voptargs=+acc work.ram_tb -cover
add wave *
coverage save ram_tb.ucdb -onexit 
run -all