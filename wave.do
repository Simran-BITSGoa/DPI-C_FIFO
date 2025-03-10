onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/write_clk
add wave -noupdate /testbench/read_clk
add wave -noupdate /testbench/rst
add wave -noupdate /testbench/write_en
add wave -noupdate /testbench/read_en
add wave -noupdate /testbench/data_in
add wave -noupdate /testbench/data_out
add wave -noupdate /testbench/full
add wave -noupdate /testbench/empty
add wave -noupdate /testbench/read_str
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {5418 ns}
