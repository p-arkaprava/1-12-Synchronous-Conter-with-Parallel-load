`timescale 1ns/1ps

module tb_top_module;

reg clk;
reg reset;
reg enable;

wire [3:0] Q;
wire c_enable;
wire c_load;
wire [3:0] c_d;

// Instantiate DUT
top_module uut (
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .Q(Q),
    .c_enable(c_enable),
    .c_load(c_load),
    .c_d(c_d)
);

// Clock generation (10ns period)
always #5 clk = ~clk;

initial begin
    clk = 0;
    reset = 1;
    enable = 0;

    // Apply reset
    #10 reset = 0;

    // Enable counting
    #10 enable = 1;

    // Let counter run
    #200;

    // Disable counter
    enable = 0;

    #50;

    // Enable again
    enable = 1;

    #100;

    $finish;
end

// Monitor signals
initial begin
    $monitor("time=%0t reset=%b enable=%b Q=%d c_enable=%b c_load=%b",
              $time, reset, enable, Q, c_enable, c_load);
end

// Waveform dump
initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_top_module);
end

endmodule