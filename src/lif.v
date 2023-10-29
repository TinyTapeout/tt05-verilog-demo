`default_nettype none

module lif (
    input wire [7:0] current,
    input wire       clk,
    input wire       rst_n,
    output wire      spike,
    output reg [7:0] state
);
    reg [7:0] next_state, threshold;

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 127;
        end else begin
            state <= next_state;
        end

    // next_state logic
    assign next_state = current + (state >> 1);

    // spiking logic
    assign spike = (state >= threshold);

    end

endmodule

