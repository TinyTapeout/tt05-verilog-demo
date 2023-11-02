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
    lif lif1(.current(current[0]), .clk(clk), .rst_n(rst_n), .spike(l1_out[0]), .state(l1_state[0:7]));
    lif lif2(.current(current[1]), .clk(clk), .rst_n(rst_n), .spike(l1_out[1]), .state(l1_state[8:15]));
    lif lif3(.current(current[2]), .clk(clk), .rst_n(rst_n), .spike(l1_out[2]), .state(l1_state[16:23]));
    lif lif4(.current(current[3]), .clk(clk), .rst_n(rst_n), .spike(l1_out[3]), .state(l1_state[24:31]));
    lif lif5(.current(current[4]), .clk(clk), .rst_n(rst_n), .spike(l1_out[4]), .state(l1_state[32:39]));
    lif lif6(.current(current[5]), .clk(clk), .rst_n(rst_n), .spike(l1_out[5]), .state(l1_state[40:47]));
    lif lif7(.current(current[6]), .clk(clk), .rst_n(rst_n), .spike(l1_out[6]), .state(l1_state[48:55]));
    lif lif8(.current(current[7]), .clk(clk), .rst_n(rst_n), .spike(l1_out[7]), .state(l1_state[56:63]));

    // Summing logic 

    always @(posedge clk) begin
        if (!rst_n) begin
            sum <= 0;
        end else begin
            sum <= l1_out[0:7] + l1_out[8:15] + l1_out[16:23] + l1_out[24:31] + l1_out[32:39] +
            l1_out[40:47] + l1_out[48:55] + l1_out[56:63];
        end
    end

    // Output neuron
    lif output_neuron (.current(sum), .clk(clk), .rst_n(rst_n), .spike(spike_out), .state(state_out));

endmodule
