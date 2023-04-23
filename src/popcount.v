
module popcount #(
    parameter INPUTS = 8,
    parameter COUNTER_BITS = 4
) (
    input [INPUTS-1:0] in,
    output reg [COUNTER_BITS-1:0] count
);

    integer i;
    // always @(in) begin
    //     count = 0;
    //     for  (i = 0; i < INPUTS; i = i + 1) begin
    //         count = count + in[i];
    //     end
    // end

    always @(in) begin
        reg [1:0] count0;
        reg [1:0] count1;
        reg [1:0] count2;
        reg [1:0] count3;
        reg [2:0] count4;
        reg [2:0] count5;
        case (in[1:0])
            2'b00: count0 = 2'd0;
            2'b01: count0 = 2'd1;
            2'b10: count0 = 2'd1;
            2'b11: count0 = 2'd2;
        endcase
        case (in[3:2])
            2'b00: count1 = 2'd0;
            2'b01: count1 = 2'd1;
            2'b10: count1 = 2'd1;
            2'b11: count1 = 2'd2;
        endcase
        case (in[5:4])
            2'b00: count2 = 2'd0;
            2'b01: count2 = 2'd1;
            2'b10: count2 = 2'd1;
            2'b11: count2 = 2'd2;
        endcase
        case (in[7:6])
            2'b00: count3 = 2'd0;
            2'b01: count3 = 2'd1;
            2'b10: count3 = 2'd1;
            2'b11: count3 = 2'd2;
        endcase

        count4 = count0 + count1;
        count5 = count2 + count3;
        count = count4 + count5;
    end

endmodule
