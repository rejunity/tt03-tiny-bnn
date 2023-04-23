
module neuron (
    input clk,
    input wire setup,
    input wire param_in,
    output wire param_out,

    input wire [7:0] inputs,
    output reg axon
);

    reg [7:0] weights;
    reg [2:0] bias;

    //reg [7:0] temp;
    reg [2:0] accumulator;
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

    assign param_out = bias[2];

    always @(posedge clk) begin
        // if reset, set counter to 0
        if (setup) begin
            bias <= {bias[1:0], weights[7]};
            weights <= {weights[6:0], param_in};
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
        for  (i = 0; i < 8; i = i + 1)
            accumulator = accumulator + (weights[i] & inputs[i]);
        // $display("accumulator value = ", accumulator);
        axon <= (accumulator > bias);
    end

endmodule
