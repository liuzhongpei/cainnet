onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib fifo_generator_1024b_opt

do {wave.do}

view wave
view structure
view signals

do {fifo_generator_1024b.udo}

run -all

quit -force
