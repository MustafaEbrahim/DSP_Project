vlib work
vlog Spartan6_DSP48A1_REF.v Spartan6_DSP48A1_DUT.v testbench.v
vsim -voptargs=+acc work.tb_Spartan6_DSP48A1
add wave *
run -all