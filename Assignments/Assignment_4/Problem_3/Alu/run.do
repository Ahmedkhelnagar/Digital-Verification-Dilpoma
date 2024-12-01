vlib work
vlog ALU_4_bit.v ALU_4_bit_tb.sv  +cover -covercells
vsim -voptargs=+acc work.ALU_4_bit_tb -cover -sv_seed random -l sim.log
add wave * /ALU_4_bit_tb/assert__p_rst /ALU_4_bit_tb/assert__p_ADD /ALU_4_bit_tb/assert__p_SUB /ALU_4_bit_tb/assert__p_NOT_A /ALU_4_bit_tb/assert__p_RED_B
coverage save ALU_4_bit_tb.ucdb -onexit -du work.ALU_4_bit
run -all