## Xilinx Artix-7 Pin Constraints — Edge-AI-APP
## Device: XC7A35T-1CPG236C (Basys3 board)

# Clock — 100 MHz on-board oscillator (W5)
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

# Reset — BTNC (T17, active high — inverted in constraints)
set_property PACKAGE_PIN T17 [get_ports reset_n]
set_property IOSTANDARD LVCMOS33 [get_ports reset_n]

# Buttons — BTNL (R17), BTNR (V1)
set_property PACKAGE_PIN R17 [get_ports {button[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {button[0]}]
set_property PACKAGE_PIN V1  [get_ports {button[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {button[1]}]

# LEDs — LD0 (U16), LD1 (E19)
set_property PACKAGE_PIN U16 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
