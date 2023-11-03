`default_nettype none

module hh  ( //#(parameter EXP = 8'b0010_1011)
    input wire [7:0] stim_current,
    input wire clk,
    input wire rst_n,
    output reg [7:0] state,
    output wire [7:0] spike );

    //reg [7:0] next_state, threshold, current, INa, IK, IKleak, m_alph, m_beta, m_act, h_alph, h_beta, h_act, n_alph, n_beta, n_act;
    reg [7:0] threshold, n, m, h;//VK, VNa, Vl
    wire [7:0] next_state, current, next_n, next_m, next_h;
    // V = I/c
    // Check if activation changes per time step
    // Make constants parameters in model declaration

/*     assign m_alph = ((25 - state) / (EXP**((25 - state) >> 3) - 1)) >> 3;
    assign m_beta = 4 * EXP**(-state >> 4);
    assign m_act = m_alph / (m_alph + m_beta);

    assign h_alph = EXP**(-state >> 4) >> 3;
    assign h_beta = 1 / (EXP**((30 - state) >> 3) + 1);
    assign h_act = h_alph / (h_alph + h_beta);

    assign n_alph = ((10 - state) / (EXP**((10 - state) >> 3) - 1)) >> 7;
    assign n_beta = EXP*(-state >> 6) >> 3;
    assign n_act = n_alph / (n_alph + n_beta);

    assign INa = ((state - -50next_state)) >> 3;
    assign IK = ((state - 77)) >> 4;
    assign IKleak = (state - 54) >> 2; */

    //assign current = stim_current - INa - IK - IKleak;
    //                              m^3 h (Vm - VNa) g_Na               n^4 (Vm - Vk) g_k               (Vm - Vl) g_l
    assign current = stim_current - (((m**3)*h*(state - -50)) >> 3) - (((n**4)*(state - 77)) >> 4) - ((state - 54) >> 2);
    // state(t+1) = state(t) + current*dt
    assign next_state = (spike[0] ? 0 : (state)) + (current >> 2);
    assign spike = {7'b0, state>= threshold};

    // assign spike[0] = (state >= threshold);
    // assign spike[7:1] = 0;

    // (Vm*(1-n)*(a_n) - (V_m)*n*beta_n)*dt
    assign next_n = n + (((state*(1-n)) >> 2 - (state*n) >> 2) >> 2); // replace states w/ alpha(state)
    assign next_m = m + (((state*(1-m)) >> 2 - (state*m) >> 2) >> 2);
    assign next_h = h + (((state*(1-h)) >> 2 - (state*h) >> 2) >> 2);
    

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 50;
            n <= 8'b0000_1000;
            m <= 8'b0000_0010;
            h <= 8'b0000_0100;
        end
        else begin
            state <= next_state;
            n <= next_n;
            m <= next_m;
            h <= next_h;
        end
    end

endmodule