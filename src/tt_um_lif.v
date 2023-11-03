`default_nettype none

module tt_um_lif  (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // use bidirectionals as outputs
    assign uio_oe = 8'b11111111;
    // assign ena = 1'b1;
    // assign uio_out = 8'b00000000;



    // instantiate hh neuron
    hh hh1(.stim_current(ui_in), .clk(clk), .rst_n(rst_n), .state(uo_out), .spike(uio_out));

endmodule
