// Top-level entity for Edge-AI-APP FPGA design (Verilog)
// Supports Intel Cyclone V and Xilinx Artix-7
`timescale 1ns/1ps

module top_entity (
    input  wire        clk,
    input  wire        reset_n,
    input  wire [1:0]  button,
    output reg  [1:0]  led
);
    reg [23:0] counter;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 24'd0;
            led     <= 2'b00;
        end else begin
            counter <= counter + 1;
            case (button)
                2'b01:   led <= 2'b01;
                2'b10:   led <= 2'b10;
                2'b11:   led <= 2'b11;
                default: led <= counter[23:22];
            endcase
        end
    end
endmodule
