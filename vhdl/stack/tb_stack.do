onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_stack/CLK
add wave -noupdate /tb_stack/DUT/ptr
add wave -noupdate /tb_stack/DUT/RESET_n
add wave -noupdate /tb_stack/data_in
add wave -noupdate /tb_stack/data_out
add wave -noupdate /tb_stack/ENA
add wave -noupdate /tb_stack/DUT/operation
add wave -noupdate /tb_stack/DUT/peek
add wave -noupdate -expand /tb_stack/DUT/stack_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {526061 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {2100 ns}
