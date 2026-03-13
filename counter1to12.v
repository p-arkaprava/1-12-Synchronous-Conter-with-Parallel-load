

module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q,
    output c_enable,
    output c_load,
    output [3:0] c_d
);

assign c_d = 4'd1;

// load when reset OR when count reaches 12
assign c_load = reset | (enable & (Q == 4'd12));

// enable only when counting normally
assign c_enable = enable & (Q != 4'd12);

count4 counter_inst (
    .clk(clk),
    .enable(c_enable),
    .load(c_load),
    .d(c_d),
    .Q(Q)
);

endmodule

module count4(
    input clk,
    input enable,
    input load,
    input [3:0] d,
    output reg [3:0] Q
);

always @(posedge clk) begin
    if (load)           // load has higher priority
        Q <= d;
    else if (enable)    // count when enabled
        Q <= Q + 1'b1;
end

endmodule