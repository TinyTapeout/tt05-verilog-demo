`default_nettype none

module lif_network (
    input  wire [7:0] current,    // Dedicated inputs - connected to the input switches
    output wire [7:0] spike_out,   // Dedicated outputs - connected to the 7 segment display
    output wire [7:0] state_out //
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire [7:0] l1_out; // One output per lif neuron
    reg [7:0] sum; // register to hold the summation

    //Instantiate 8 lif neurons
    lif lif1(.current(ui_in[0]), .clk(clk), .rst_n(rst_n), .spike(l1_out[0]), .state(l1_state[0]));
    lif lif2(.current(ui_in[1]), .clk(clk), .rst_n(rst_n), .spike(l1_out[1]), .state(l1_state[1]));
    lif lif3(.current(ui_in[2]), .clk(clk), .rst_n(rst_n), .spike(l1_out[2]), .state(l1_state[2]));
    lif lif4(.current(ui_in[3]), .clk(clk), .rst_n(rst_n), .spike(l1_out[3]), .state(l1_state[3]));
    lif lif5(.current(ui_in[4]), .clk(clk), .rst_n(rst_n), .spike(l1_out[4]), .state(l1_state[4]));
    lif lif6(.current(ui_in[5]), .clk(clk), .rst_n(rst_n), .spike(l1_out[5]), .state(l1_state[5]));
    lif lif7(.current(ui_in[6]), .clk(clk), .rst_n(rst_n), .spike(l1_out[6]), .state(l1_state[6]));
    lif lif8(.current(ui_in[7]), .clk(clk), .rst_n(rst_n), .spike(l1_out[7]), .state(l1_state[7]));

    // Summing logic 

    always @(posedge clk) begin
        if (!rst_n) begin
            sum <= 0;
        end else begin
            sum <= l1_out[0] + l1_out[1] + l1_out[3] + l1_out[4] + l1_out[5] +
            l1_out[6] + l1_out[7];
        end
    end

    // Output neuron
    lif output_neuron (.current(sum), .clk(clk), .rst_n(rst_n), .spike(spike_out), .state(state_out));

endmodule