
module neuron #(
    parameter INPUTS = 8,
    parameter BIAS_BITS = 3
) (
    input clk,
    input wire setup,
    input wire param_in,
    output wire param_out,

    input wire [INPUTS-1:0] inputs,
    output reg axon
);

    localparam ACCUMULATOR_BITS = $clog2(INPUTS);

    reg [INPUTS-1:0] weights;
    reg [BIAS_BITS-1:0] bias;

    reg [ACCUMULATOR_BITS:0] accumulator;
    integer i;

    // initial begin
    //     weights = 8'hFF;
    //     bias = 3;
    // end

    // initial begin
    //      weights = 0;
    //      bias = 0;
    // end

    // always @(posedge setup) begin
    //     param_out <= bias[2];
    //     bias <= {bias[1:0], weights[7]};
    //     weights <= {weights[6:0], param};
    // end

    assign param_out = bias[BIAS_BITS-1];

    always @(posedge clk) begin
        // if reset, set counter to 0
        if (setup) begin
            bias <= {bias[BIAS_BITS-2:0], weights[INPUTS-1]};
            weights <= {weights[INPUTS-2:0], param_in};
            // $display(">> ", param_in);
            // $display("w = ", weights);
            // $display("b = ", bias);
        end
    end

    always @(inputs) begin
        //temp <= weights & inputs;
        // $display("w = ", weights);
        // $display("b = ", bias);
        // $display("i = ", inputs);
        // $display("t = ", temp);
        accumulator = 0;
        for  (i = 0; i < INPUTS; i = i + 1)
            accumulator = accumulator + (weights[i] & inputs[i]);
        // $display("accumulator value = ", accumulator);
        axon <= (accumulator > bias);
    end

endmodule
