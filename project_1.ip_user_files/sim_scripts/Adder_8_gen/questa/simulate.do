onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib Adder_8_gen_opt

do {wave.do}

view wave
view structure
view signals

do {Adder_8_gen.udo}

run -all

quit -force
