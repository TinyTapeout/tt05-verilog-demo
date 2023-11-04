`default_nettype none

module hh_state  (
    input wire [13:0] voltage, 
    output wire [13:0] alpha_n,
    output wire [13:0] alpha_m,
    output wire [13:0] alpha_h,
    output wire [13:0] beta_n,
    output wire [13:0] beta_m,
    output wire [13:0] beta_h,
    input wire clk,
    input wire rst_n 
     );

    reg [13:0] b, c, d;
    wire [13:0] e, f, g, h, k, l , m, n, o, r, s, t, u, v, w, x, y, z;

    always @(posedge clk) begin
        if (!rst_n) begin
            b <= 14'b00000000000000;
            c <= 14'b00000000000000;
            d <= 14'b00000000000000;
        end else begin 
            /// alpha_n
            b <= 14'b000110111_00000; // 55
            c <= 14'b000001010_00000; // 10
            d <= 14'b000000001_00000; // 1
        end
    end

    // alpha_n: 0.01 * (V + 55) / (1 - np.exp(-(V + 55) / 10))
    assign e = voltage + b; // (-V+55)
    assign f = (~e + (d>>5))/c; // -(V+55)/10
    assign g = (d + f + f*f); /// 1 + x + (x**2) / math.factorial(2)
    assign h = d - (g >> 1); /// 1 + x + (x**2) / math.factorial(2)
    assign alpha_n = (d>>5) * e / (d - h);

    // alpha_m: 0.1 * (V + 40) / (1 - np.exp(-(V + 40) / 10))
    assign k = voltage + (d<<5 + d<<3); // V+40
    assign l = (~k + (d>>5) + (c<<2))/c; // 
    assign m = (d + l + l*l); /// 1 + x + (x**2) / math.factorial(2)
    assign n = d - (m >> 1); // right shift is the div by 2 (math.factorial(2))
    assign alpha_m = ((d>>4)+(d>>5)) * k / n;

    // alpha_h: 0.07 * np.exp(-(V + 65) / 20)
    assign o = voltage + (b+c); // V + 65
    assign r = (~o + (d>>5))/(c<<1); // -(V+65)/20
    assign s = (d + r + r*r);  // taylor polynomial
    assign t = d - (s>>1); //1 - np.exp...
    assign alpha_h = (d>>4) * t;

    // beta_n: 0.125 * np.exp(-(V+65)/80)
    assign u = (~o + (d>>5))/(c<<3); // -(V+65/80)
    assign v = (~u + (d>>5)) / (c<<3);
    assign beta_n = (d>>3) * v;

    // beta_m: 4.0 * np.exp(-(V + 65) / 18)
    assign w = (~o + (d>>5))/(c<<1 - d<<1);
    assign x = (d + w + w*w); // 1 + x + x**2
    assign beta_m = (d<<2) * x;

    // beta_h: 1 / (np.exp(-(V + 35) / 10) + 1)
    assign y = (~(voltage + (d<<5 + d<<1 + d) / c) + d + (d>>5)); // -(V+35)/10 + 1
    assign z = (d + y + y*y) >> 1;
    assign beta_h = d / z;


endmodule
