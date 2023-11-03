`default_nettype none

module hh  ( //#(parameter EXP = 8'b0010_1011)
    input wire [7:0] stim_current,
    input wire clk,
    input wire rst_n,
    output reg [7:0] state,
    output wire [7:0] spike );

    //reg [7:0] next_state, threshold, current, INa, IK, IKleak, m_alph, m_beta, m_act, h_alph, h_beta, h_act, n_alph, n_beta, n_act;
    reg [7:0] threshold, n_var, m_var, h_var;//VK, VNa, Vl
    wire [7:0] next_state, current, next_n, next_m, next_h;
    
    assign current = stim_current - (((m_var**3)*h_var*(state - -50)) >> 3) - (((n_var**4)*(state - 77)) >> 4) - ((state - 54) >> 2);
    assign next_state = (spike[0] ? 0 : (state)) + (current >> 2);
    assign spike = {7'b0, state>= threshold};
    assign next_n = n_var + (((state*(1-n_var)) >> 2 - (state*n_var) >> 2) >> 2); // replace states w/ alpha(state)
    assign next_m = m_var + (((state*(1-m_var)) >> 2 - (state*m_var) >> 2) >> 2);
    assign next_h = h_var + (((state*(1-h_var)) >> 2 - (state*h_var) >> 2) >> 2);
    

    always @(posedge clk) begin
        if (!rst_n) begin
            state <= 0;
            threshold <= 50;
            n_var <= 8'b0000_1000;
            m_var <= 8'b0000_0010;
            h_var <= 8'b0000_0100;
        end
        else begin
            state <= next_state;
            n_var <= next_n;
            m_var <= next_m;
            h_var <= next_h;
        end
    end

endmodule