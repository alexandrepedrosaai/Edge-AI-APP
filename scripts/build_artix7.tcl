# Build script for Xilinx Artix-7 using Vivado
# Usage: vivado -mode batch -source scripts/build_artix7.tcl

set project_name "EdgeAIApp_Artix7"
set output_dir   "fpga_build"
set part         "xc7a35tcpg236-1"

puts "=== Edge-AI-APP: Vivado Artix-7 Build ==="

# Create project
create_project -force $project_name $output_dir -part $part

# Add HDL sources
add_files -norecurse [glob src/verilog/*.v]
add_files -fileset constrs_1 -norecurse constraints/artix7.xdc

# Set top module
set_property top top_entity [current_fileset]

# Synthesize
synth_design -top top_entity -part $part
opt_design
place_design
route_design

# Write bitstream
write_bitstream -force "${output_dir}/${project_name}.bit"

puts "=== Build complete: ${output_dir}/${project_name}.bit ==="
