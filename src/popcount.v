
module popcount #(
    parameter INPUTS = 8,
    parameter COUNTER_BITS = 4
) (
    input [INPUTS-1:0] in,
    output reg [COUNTER_BITS-1:0] count
);

    integer i;
    always_comb begin
        count = 0;
        for  (i = 0; i < INPUTS; i = i + 1) begin
            count = count + in[i];
        end
    end


endmodule
