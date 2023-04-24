
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

    localparam ACCUMULATOR_BITS = $clog2(INPUTS) + 1;

    reg [INPUTS-1:0] weights;
    reg [BIAS_BITS-1:0] bias;

    reg [ACCUMULATOR_BITS-1:0] accumulator;
    integer i;

    // initial begin
    //     weights = {INPUTS{1'bx}};
    //     bias = {BIAS_BITS{1'bx}};
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
        // load weights & bias in the setup phase
        if (setup) begin
            //bias <= {bias[BIAS_BITS-2:0], weights[INPUTS-1]};
            //weights <= {weights[INPUTS-2:0], param_in};
            bias <= bias << 1;
            bias[0] <= weights[INPUTS-1];
            weights <= weights << 1;
            weights[0] <= param_in;
            // $display(">> ", param_in);
            // $display("w = ", weights);
            // $display("b = ", bias);
        // end else begin
            // accumulator = 0;
            // for  (i = 0; i < INPUTS; i = i + 1)
            //     accumulator = accumulator + (weights[i] & inputs[i]);
            // // $display("accumulator value = ", accumulator);
            // if (USE_CHEAP_BIAS == 1)
            //     axon = |(accumulator & bias);
            // else
            //     axon = (accumulator > bias);

            // $display("w = ", weights);
            // $display("i = ", inputs);
            // $display("s = ", synapses);
            // $display("b = ", bias);
            // $display("a = ", accumulator);
        end
    end

    wire [INPUTS-1:0] synapses;
    assign synapses = weights & inputs;
    popcount #(.INPUTS(INPUTS), .COUNTER_BITS(ACCUMULATOR_BITS)) spike_counter(.in(synapses), .count(accumulator));
    assign axon = accumulator > bias;

    // always @(*) begin
    //     //axon <= (accumulator > bias);
    //     axon <= |(accumulator & bias);
    //     // $display("w = ", weights);
    //     // $display("i = ", inputs);
    //     // $display("s = ", synapses);
    //     // $display("b = ", bias);
    //     // $display("a = ", accumulator);
    // end

    // always @(inputs) begin
    //     // synapses <= weights & inputs;
    //     // $display("w = ", weights);
    //     // $display("b = ", bias);
    //     // $display("i = ", inputs);
    //     // $display("t = ", synapses);
    //     accumulator = 0;
    //     for  (i = 0; i < INPUTS; i = i + 1)
    //         accumulator = accumulator + (weights[i] & inputs[i]);
    //     // $display("accumulator value = ", accumulator);
    //     if (USE_CHEAP_BIAS == 1)
    //         axon = |(accumulator & bias);
    //     else
    //         axon = (accumulator > bias);
    // end


    // wire [INPUTS-1:0] synapses;
    // assign synapses = weights & inputs;
    // assign axon = (synapses[7]+synapses[6]+synapses[5]+synapses[4]+synapses[3]+synapses[2]+synapses[1]+synapses[0]) > bias;
    // assign axon = ((synapses[7]+synapses[6])+(synapses[5]+synapses[4]))+((synapses[3]+synapses[2])+(synapses[1]+synapses[0])) > bias;

    // wire [1:0] count0;
    // wire [1:0] count1;
    // wire [1:0] count2;
    // wire [1:0] count3;
    // wire [2:0] count4;
    // wire [2:0] count5;
    // wire [3:0] count;
    // assign count0 = enc2(synapses[1:0]);
    // assign count1 = enc2(synapses[3:2]);
    // assign count2 = enc2(synapses[5:4]);
    // assign count3 = enc2(synapses[7:6]);
    // assign count0 = synapses[0] + synapses[1];
    // assign count1 = synapses[2] + synapses[3];
    // assign count2 = synapses[4] + synapses[5];
    // assign count3 = synapses[6] + synapses[7];
    // assign count4 = count0 + count1;
    // assign count5 = count2 + count3;
    // assign count = count4 + count5;
    // assign axon = count > bias;

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
