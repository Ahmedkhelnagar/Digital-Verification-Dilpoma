vlib work
vlog package.sv ALSU.v ALSU_tb.sv  +cover -covercells
vsim -voptargs=+acc work.ALSU_tb -cover -sv_seed random -l sim.log
add wave *
coverage save ALSU_tb.ucdb -onexit 
run -all