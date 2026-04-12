`timescale 1ns/1ps

module tb_top;
    reg        clk     = 0;
    reg        reset_n = 0;
    reg  [1:0] button  = 2'b00;
    wire [1:0] led;

    top_entity uut (
        .clk     (clk),
        .reset_n (reset_n),
        .button  (button),
        .led     (led)
    );

    // Clock generation: 100 MHz (10 ns period)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("fpga_build/tb_top.vcd");
        $dumpvars(0, tb_top);

        // Reset
        reset_n = 0; #20;
        reset_n = 1; #20;

        // Stimulus
        button = 2'b01; #40;
        button = 2'b10; #40;
        button = 2'b11; #40;
        button = 2'b00; #40;

        $display("Simulation complete. LED final value: %b", led);
        $finish;
    end
endmodule
