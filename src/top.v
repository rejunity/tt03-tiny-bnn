`default_nettype none

module tiny_bnn (
  input [7:0] io_in,
  output [7:0] io_out
);
    
    wire clk = io_in[0];
    wire setup = io_in[1];
    wire param_in = io_in[2];
    wire [5:0] x = io_in[7:2];

    // wire led_out;
    // wire param_out;
    // assign io_out[0] = led_out;
    // assign io_out[1] = led_out;
    // assign io_out[2] = led_out;
    // assign io_out[3] = led_out;
    // assign io_out[4] = led_out;
    // assign io_out[5] = led_out;
    // assign io_out[6] = led_out;
    // assign io_out[7] = param_out;


    reg [7:0] global_input;
    wire [7:0] param_chain;
    wire [7:0] global_output;
    
    always @(posedge clk) begin
        // during setup, reset global inputs to 0
        if (setup) begin
            global_input <= 0;
        end else begin
            global_input[5:0] <= x;
        end
    end

    // instantiate segment display
    //seg7 seg7(.counter(digit), .segments(led_out));
    //neuron neuron(.inputs(global_input), .axon(led_out));
    //neuron neuron(
    //     .reset(reset), .setup_weights(8'hFF), .setup_bias(3),
    //     .inputs(global_input), .axon(led_out));

    // neuron neuron(
    //     //.clk(clk), .setup(setup), .param_in(param), .param_out(param_out),
    //     // .clk(clk), .setup(setup), .param_in(param), .param_out(param_chain[1]),
    //     // .clk(clk), .setup(setup), .param_in(param_chain[0]), .param_out(param_chain[1]),
    //     .clk(clk), .setup(setup), .param_in(param), .param_out(param_out),
    //     .inputs(global_input), .axon(led_out));

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            wire p = (i == 0) ? param_in : param_chain[i - 1];

            neuron input_layer (
                .clk(clk), .setup(setup), .param_in(p), .param_out(param_chain[i]),
                //.inputs(global_input), .axon(io_out[i]));
                .inputs(global_input), .axon(global_output[i]));

            assign io_out[i] = (setup) ? param_chain[7] : global_output[i];
        end
    endgenerate
endmodule
