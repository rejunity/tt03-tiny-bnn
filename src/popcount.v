
module popcount #(
    parameter INPUTS = 8,
    parameter COUNTER_BITS = 4
) (
    input [INPUTS-1:0] in,
    output reg [COUNTER_BITS-1:0] count
);

    integer i;
    always @(*) begin
        if (INPUTS == 4) begin
            count =                                 in[3] + in[2] + in[1] + in[0];
        end else if (INPUTS == 8) begin
            count = in[7] + in[6] + in[5] + in[4] + in[3] + in[2] + in[1] + in[0];
        end else if (INPUTS == 10) begin
            count =                                        in[10] + in[9] + in[8] +
                    in[7] + in[6] + in[5] + in[4] + in[3] + in[2] + in[1] + in[0];
        end else if (INPUTS == 16) begin
            count = in[15]+in[14] +in[13] +in[12] +in[11] +in[10] + in[9] + in[8] +
                    in[7] + in[6] + in[5] + in[4] + in[3] + in[2] + in[1] + in[0];
        end else begin
            count = 0;
            for  (i = 0; i < INPUTS; i = i + 1) begin
                count = count + in[i];
            end
        end
    end


endmodule
