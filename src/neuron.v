
module neuron #(
    parameter INPUTS = 8,
    parameter BIAS_BITS = 3,
    parameter USE_CHEAP_BIAS = 1
) (
    input clk,
    input wire setup,
    input wire param_in,
    output wire param_out,

    input wire [INPUTS-1:0] inputs,
    output reg axon
);

    localparam ACCUMULATOR_BITS = $clog2(INPUTS) + 1;

    reg [INPUTS-1:0] weights;
    reg [BIAS_BITS-1:0] bias;

    reg [ACCUMULATOR_BITS-1:0] accumulator;
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
            bias = {bias[BIAS_BITS-2:0], weights[INPUTS-1]};
            weights = {weights[INPUTS-2:0], param_in};
            // $display(">> ", param_in);
            // $display("w = ", weights);
            // $display("b = ", bias);
        end
    end

    // wire [INPUTS-1:0] synapses;
    // assign synapses = weights & inputs;
    // popcount #(.INPUTS(8), .COUNTER_BITS(ACCUMULATOR_BITS)) spike_counter(.in(synapses), .count(accumulator));

    // always @(*) begin
    //     //axon <= (accumulator > bias);
    //     axon <= |(accumulator & bias);
    //     // $display("w = ", weights);
    //     // $display("i = ", inputs);
    //     // $display("s = ", synapses);
    //     // $display("b = ", bias);
    //     // $display("a = ", accumulator);
    // end

    always @(inputs) begin
        // synapses <= weights & inputs;
        // $display("w = ", weights);
        // $display("b = ", bias);
        // $display("i = ", inputs);
        // $display("t = ", synapses);
        accumulator = 0;
        for  (i = 0; i < INPUTS; i = i + 1)
            accumulator = accumulator + (weights[i] & inputs[i]);
        // $display("accumulator value = ", accumulator);
        if (USE_CHEAP_BIAS == 1)
            axon <= |(accumulator & bias);
        else
            axon <= (accumulator > bias);
    end

    // function [1:0] enc2;
    //     input [1:0] in;
    //     begin
    //         case (in)
    //             2'b00: enc2 = 2'd0;
    //             2'b01: enc2 = 2'd1;
    //             2'b10: enc2 = 2'd1;
    //             2'b11: enc2 = 2'd2;
    //         endcase
    //     end
    // endfunction

    // wire [7:0] synapses;
    // wire [1:0] count0;
    // wire [1:0] count1;
    // wire [1:0] count2;
    // wire [1:0] count3;
    // wire [2:0] count4;
    // wire [2:0] count5;
    // wire [3:0] count;
    // assign synapses = weights & inputs;
    // assign count0 = synapses[0] + synapses[1];
    // assign count1 = synapses[2] + synapses[3];
    // assign count2 = synapses[4] + synapses[5];
    // assign count3 = synapses[6] + synapses[7];
    // // assign count0 = enc2(synapses[1:0]);
    // // assign count1 = enc2(synapses[3:2]);
    // // assign count2 = enc2(synapses[5:4]);
    // // assign count3 = enc2(synapses[7:6]);
    // assign count4 = count0 + count1;
    // assign count5 = count2 + count3;
    // // assign count = enc2(synapses[1:0]) + enc2(synapses[3:2]) + enc2(synapses[5:4]) + enc2(synapses[7:6]);
    // assign count = count4 + count5;

    // reg [7:0] synapses;
    // reg [1:0] count0;
    // reg [1:0] count1;
    // reg [1:0] count2;
    // reg [1:0] count3;
    // reg [2:0] count4;
    // reg [2:0] count5;
    // reg [3:0] count;

    // always @(inputs) begin

    //     synapses = weights & inputs;
    //     count0 = synapses[0] + synapses[1];
    //     count1 = synapses[2] + synapses[3];
    //     count2 = synapses[4] + synapses[5];
    //     count3 = synapses[6] + synapses[7];
    //     count4 = count0 + count1;
    //     count5 = count2 + count3;
    //     count = count4 + count5;

    //     if (USE_CHEAP_BIAS == 1)
    //         axon <= |(count & bias);
    //     else
    //         axon <= (count > bias);
    // end

endmodule
