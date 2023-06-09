`default_nettype none

module tiny_bnn (
    input [7:0] io_in,
    output [7:0] io_out
);
    localparam GLOBAL_INPUTS = 8;
    localparam GLOBAL_OUTPUTS = 8;
    localparam HIDDEN_UNITS = 8;
    localparam HIDDEN_UNITS2 = 0;
    
    wire clk = io_in[0];
    wire setup = io_in[1];
    wire param_in = io_in[2];
    wire x_bank_hi = io_in[3];
    wire [3:0] x = io_in[7:4];


    reg [GLOBAL_INPUTS-1:0] global_input;
    wire [HIDDEN_UNITS-1:0] hidden;
    wire [HIDDEN_UNITS2-1:0] hidden2;
    wire [GLOBAL_OUTPUTS-1:0] global_output;
    wire [HIDDEN_UNITS+HIDDEN_UNITS2+GLOBAL_OUTPUTS-1:0] param_chain;
    
    always @(posedge clk) begin
        // during setup phase, reset global inputs to 0
        if (setup) begin
            global_input <= 0;
        end else begin
            if (x_bank_hi)
                global_input[7:4] <= x;
            else
                global_input[3:0] <= x;
        end
    end

    genvar i;
    generate
        // input layer
        if (HIDDEN_UNITS == 0) begin
            // just a single layer
            for (i = 0; i < GLOBAL_OUTPUTS; i = i + 1) begin
                wire p = (i == 0) ? param_in : param_chain[i - 1];
                neuron #(.INPUTS(GLOBAL_INPUTS)) output_layer(
                    .clk(clk), .setup(setup), .param_in(p), .param_out(param_chain[i]),
                    .inputs(global_input), .axon(global_output[i]));
            end
        end else if (HIDDEN_UNITS2 == 0) begin
            for (i = 0; i < HIDDEN_UNITS; i = i + 1) begin
                wire p = (i == 0) ? param_in : param_chain[i - 1];

                neuron #(.INPUTS(GLOBAL_INPUTS)) input_layer(
                    .clk(clk), .setup(setup), .param_in(p), .param_out(param_chain[i]),
                    .inputs(global_input), .axon(hidden[i]));
            end

            // output layer
            for (i = 0; i < GLOBAL_OUTPUTS; i = i + 1) begin
                neuron #(.INPUTS(HIDDEN_UNITS)) output_layer(
                    .clk(clk), .setup(setup), .param_in(param_chain[HIDDEN_UNITS + i - 1]), .param_out(param_chain[HIDDEN_UNITS + i]),
                    .inputs(hidden), .axon(global_output[i]));
            end
        end else begin
            // 1st layer
            for (i = 0; i < HIDDEN_UNITS; i = i + 1) begin
                wire p = (i == 0) ? param_in : param_chain[i - 1];

                neuron #(.INPUTS(GLOBAL_INPUTS)) input_layer(
                    .clk(clk), .setup(setup), .param_in(p), .param_out(param_chain[i]),
                    .inputs(global_input), .axon(hidden[i]));
            end

            // 2nd layer
            for (i = 0; i < HIDDEN_UNITS2; i = i + 1) begin
                neuron #(.INPUTS(HIDDEN_UNITS)) input_layer(
                    .clk(clk), .setup(setup), .param_in(param_chain[HIDDEN_UNITS + i - 1]), .param_out(param_chain[HIDDEN_UNITS + i]),
                    .inputs(hidden), .axon(hidden2[i]));
            end

            // output layer
            for (i = 0; i < GLOBAL_OUTPUTS; i = i + 1) begin
                neuron #(.INPUTS(HIDDEN_UNITS)) output_layer(
                    .clk(clk), .setup(setup), .param_in(param_chain[HIDDEN_UNITS + HIDDEN_UNITS2 + i - 1]), .param_out(param_chain[HIDDEN_UNITS + HIDDEN_UNITS2 + i]),
                    .inputs(hidden2), .axon(global_output[i]));
            end
        end

        // for (i = 0; i < GLOBAL_OUTPUTS; i = i + 1) begin
        //     assign io_out[i] = (setup && i == GLOBAL_OUTPUTS - 1) ? param_chain[HIDDEN_UNITS+HIDDEN_UNITS2+GLOBAL_OUTPUTS-1] : global_output[i];
        // end

        for (i = 0; i < GLOBAL_OUTPUTS; i = i + 1) begin
            assign io_out[i] = global_output[i];
        end
    endgenerate

endmodule
