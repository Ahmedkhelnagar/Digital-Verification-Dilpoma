vlib work
vlog ALU_4_bit.v ALU_4_bit_tb.sv  +cover -covercells
vsim -voptargs=+acc work.ALU_4_bit_tb -cover
add wave *
coverage save ALU_4_bit_tb.ucdb -onexit -du work.ALU_4_bit
run -all