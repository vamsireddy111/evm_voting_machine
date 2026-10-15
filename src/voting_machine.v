`timescale 1ns/1ps

module voting_machine (
    input clk,
    input reset,
    input start,
    input result,
    input vote_enable,
    input [1:0] candidate,

    output reg [7:0] count1,
    output reg [7:0] count2,
    output reg [7:0] count3,
    output reg [7:0] count4,
    output reg [1:0] winner
);

parameter IDLE   = 2'b00;
parameter VOTING = 2'b01;
parameter RESULT = 2'b10;

reg [1:0] state;

always @(posedge clk or posedge reset) begin

    if (reset) begin
        state  <= IDLE;
        count1 <= 8'd0;
        count2 <= 8'd0;
        count3 <= 8'd0;
        count4 <= 8'd0;
        winner <= 2'b00;
    end

    else begin

        case (state)

            IDLE: begin
                if (start)
                    state <= VOTING;
            end

            VOTING: begin

                if (vote_enable) begin

                    case (candidate)

                        2'b00:
                            count1 <= count1 + 8'd1;

                        2'b01:
                            count2 <= count2 + 8'd1;

                        2'b10:
                            count3 <= count3 + 8'd1;

                        2'b11:
                            count4 <= count4 + 8'd1;

                    endcase

                end

                if (result)
                    state <= RESULT;

            end

            RESULT: begin

                if ((count1 >= count2) &&
                    (count1 >= count3) &&
                    (count1 >= count4))

                    winner <= 2'b00;

                else if ((count2 >= count1) &&
                         (count2 >= count3) &&
                         (count2 >= count4))

                    winner <= 2'b01;

                else if ((count3 >= count1) &&
                         (count3 >= count2) &&
                         (count3 >= count4))

                    winner <= 2'b10;

                else

                    winner <= 2'b11;

            end

            default: begin
                state <= IDLE;
            end

        endcase

    end

end

endmodule
