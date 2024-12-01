vlib work
vlog pkg_constraint.sv monitor_counter.sv interface_counter.sv counter.sv counter_top.sv counter_tb.sv counter_sva.sv +cover -covercells
vsim -voptargs=+acc work.counter_top -cover -sv_seed random -l sim.log
add wave * -position insertpoint sim:/counter_top/d1/co_if/* /counter_top/d1/counter_sva_instance/cover_load_active /counter_top/d1/counter_sva_instance/cover_load_not_active /counter_top/d1/counter_sva_instance/cover_increment_count /counter_top/d1/counter_sva_instance/cover_decrement_count
coverage save counter_top.ucdb -onexit -du work.counter
run -all