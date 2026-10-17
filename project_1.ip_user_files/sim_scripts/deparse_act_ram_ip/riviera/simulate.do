onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+deparse_act_ram_ip -L xpm -L blk_mem_gen_v8_4_4 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.deparse_act_ram_ip xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {deparse_act_ram_ip.udo}

run -all

endsim

quit -force
