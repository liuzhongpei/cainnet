onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+Mul_8_gen -L xpm -L xbip_utils_v3_0_10 -L xbip_pipe_v3_0_6 -L xbip_bram18k_v3_0_6 -L mult_gen_v12_0_16 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.Mul_8_gen xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {Mul_8_gen.udo}

run -all

endsim

quit -force
