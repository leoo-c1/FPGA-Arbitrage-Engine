onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /arbitrage_engine_tb/clk
add wave -noupdate /arbitrage_engine_tb/rst
add wave -noupdate /arbitrage_engine_tb/uart_rx
add wave -noupdate /arbitrage_engine_tb/uart_tx
add wave -noupdate /arbitrage_engine_tb/packet_valid
add wave -noupdate /arbitrage_engine_tb/uart_tx_data
add wave -noupdate /arbitrage_engine_tb/uart_tx_busy
add wave -noupdate /arbitrage_engine_tb/uart_tx_en
add wave -noupdate /arbitrage_engine_tb/profit
add wave -noupdate -radix binary /arbitrage_engine_tb/trade_action
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {10365957754 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {16355834859 ps}
