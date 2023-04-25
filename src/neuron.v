
module neuron #(
    parameter INPUTS = 8,
    parameter BIAS_BITS = 3,
    parameter USE_CHEAP_BIAS = 0
) (
    input clk,
    input setup,
    input param_in,
    output param_out,

    input wire [INPUTS-1:0] inputs,
    output axon
);

    localparam ACCUMULATOR_BITS = $clog2(INPUTS); // + 1

    reg [INPUTS-1:0] weights;
    reg [BIAS_BITS-1:0] bias;

    reg [ACCUMULATOR_BITS-1:0] accumulator;
    integer i;

    assign param_out = bias[BIAS_BITS-1];

    always @(posedge clk) begin
        // load weights & bias in the setup phase
        if (setup) begin
            bias <= bias << 1;
            bias[0] <= weights[INPUTS-1];
            weights <= weights << 1;
            weights[0] <= param_in;
            // $display(">> ", param_in);
            // $display("w = ", weights);
            // $display("b = ", bias);
        end
    end

    wire [INPUTS-1:0] synapses;
    assign synapses = weights & inputs;
    popcount #(.INPUTS(INPUTS), .COUNTER_BITS(ACCUMULATOR_BITS)) spike_counter(.in(synapses), .count(accumulator));
    assign axon = accumulator > bias;

endmodule
