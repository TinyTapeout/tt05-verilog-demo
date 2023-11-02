`default_nettype none

module lif_network (
    input  wire [7:0] current,    // Dedicated inputs - connected to the input switches
    output wire [7:0] spike_out,   // Dedicated outputs - connected to the 7 segment display
    output wire [7:0] state_out, //
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire [7:0] l1_out; // One output per lif neuron
    wire [63:0] l1_state;
    reg  [7:0] sum; // register to hold the summation

    //Instantiate 8 lif neurons
    lif lif1(.current(current[0]), .clk(clk), .rst_n(rst_n), .spike(l1_out[0]), .state(l1_state[7:0]));
    lif lif2(.current(current[1]), .clk(clk), .rst_n(rst_n), .spike(l1_out[1]), .state(l1_state[15:8]));
    lif lif3(.current(current[2]), .clk(clk), .rst_n(rst_n), .spike(l1_out[2]), .state(l1_state[23:16]));
    lif lif4(.current(current[3]), .clk(clk), .rst_n(rst_n), .spike(l1_out[3]), .state(l1_state[31:24]));
    lif lif5(.current(current[4]), .clk(clk), .rst_n(rst_n), .spike(l1_out[4]), .state(l1_state[39:32]));
    lif lif6(.current(current[5]), .clk(clk), .rst_n(rst_n), .spike(l1_out[5]), .state(l1_state[47:40]));
    lif lif7(.current(current[6]), .clk(clk), .rst_n(rst_n), .spike(l1_out[6]), .state(l1_state[55:48]));
    lif lif8(.current(current[7]), .clk(clk), .rst_n(rst_n), .spike(l1_out[7]), .state(l1_state[63:56]));

    // Summing logic 

    always @(posedge clk) begin
        if (!rst_n) begin
            sum <= 0;
        end else begin
            sum <= l1_out[7:0] + l1_out[15:8] + l1_out[23:16] + l1_out[31:24] + l1_out[39:32] +
            l1_out[47:40] + l1_out[55:48] + l1_out[63:56];
        end
    end

    // Output neuron
    lif output_neuron (.current(sum), .clk(clk), .rst_n(rst_n), .spike(spike_out), .state(state_out));

endmodule
