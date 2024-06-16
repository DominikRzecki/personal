onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_ws2812/CLK
add wave -noupdate /tb_ws2812/DUT/N_LED
add wave -noupdate /tb_ws2812/n_led
add wave -noupdate /tb_ws2812/R
add wave -noupdate /tb_ws2812/G
add wave -noupdate /tb_ws2812/B
add wave -noupdate /tb_ws2812/sig_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {412027087 ps} 0} {{Cursor 2} {308370000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 354
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {236250 ns} {498750 ns}
