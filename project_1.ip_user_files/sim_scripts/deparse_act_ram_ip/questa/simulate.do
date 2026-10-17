onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib deparse_act_ram_ip_opt

do {wave.do}

view wave
view structure
view signals

do {deparse_act_ram_ip.udo}

run -all

quit -force
