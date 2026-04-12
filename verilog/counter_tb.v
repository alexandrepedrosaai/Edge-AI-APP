// Testbench for counter in Verilog
`timescale 1ns/1ps

module counter_tb;
    reg clk;
    reg reset;
    wire [3:0] count;

    counter uut (
        .clk(clk),
        .reset(reset),
        .count(count)
    );

    initial begin
        $monitor("Time=%0t | reset=%b | count=%d", $time, reset, count);
        clk = 0; reset = 1;
        #10 reset = 0;
        #100 $finish;
    end

    always #5 clk = ~clk; // Clock toggle every 5ns
endmodule
