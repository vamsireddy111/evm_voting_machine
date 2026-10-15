
`timescale 1ns/1ps

module tb_voting_machine;

    reg clk, reset, start, result, vote_enable;
    reg [1:0] candidate;

    wire [7:0] count1, count2, count3, count4;
    wire [1:0] winner;

    voting_machine dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .result(result),
        .vote_enable(vote_enable),
        .candidate(candidate),
        .count1(count1),
        .count2(count2),
        .count3(count3),
        .count4(count4),
        .winner(winner)
    );

    always #5 clk = ~clk;

    task cast_vote;
        input [1:0] candidate_id;
        begin
            @(negedge clk);
            candidate = candidate_id;
            vote_enable = 1;

            @(negedge clk);
            vote_enable = 0;
        end
    endtask

    initial begin
        $dumpfile("evm.vcd");
        $dumpvars(0, tb_voting_machine);

        clk = 0;
        reset = 1;
        start = 0;
        result = 0;
        vote_enable = 0;
        candidate = 0;

        // TEST 1: Reset
        repeat (2) @(negedge clk);
        #1;

        if (count1 == 0 && count2 == 0 &&
            count3 == 0 && count4 == 0)
            $display("TEST 1 PASSED: Reset clears counters");
        else
            $fatal(1, "TEST 1 FAILED: Reset");

        reset = 0;

        // Start voting
        @(negedge clk);
        start = 1;
        @(negedge clk);
        start = 0;

        // TEST 2: Voting disabled
        candidate = 2'b00;
        vote_enable = 0;
        repeat (2) @(negedge clk);
        #1;

        if (count1 == 0)
            $display("TEST 2 PASSED: Disabled vote ignored");
        else
            $fatal(1, "TEST 2 FAILED: Disabled vote counted");

        // TEST 3: Count votes for all candidates
        cast_vote(2'b00);
        cast_vote(2'b00);

        cast_vote(2'b01);
        cast_vote(2'b01);
        cast_vote(2'b01);

        cast_vote(2'b10);

        @(negedge clk);
        #1;

        if (count1 == 2 && count2 == 3 &&
            count3 == 1 && count4 == 0)
            $display("TEST 3 PASSED: Vote counters");
        else
            $fatal(1, "TEST 3 FAILED: Incorrect counts");

        // TEST 4: Winner selection
        @(negedge clk);
        result = 1;
        @(negedge clk);
        result = 0;

        // Allow RESULT state to update winner
        @(negedge clk);
        #1;

        if (winner == 2'b01)
            $display("TEST 4 PASSED: Candidate 1 wins");
        else
            $fatal(1, "TEST 4 FAILED: Incorrect winner");

        // TEST 5: Reset after voting
        reset = 1;
        @(negedge clk);
        #1;

        if (count1 == 0 && count2 == 0 &&
            count3 == 0 && count4 == 0 &&
            winner == 0)
            $display("TEST 5 PASSED: Reset clears previous results");
        else
            $fatal(1, "TEST 5 FAILED: Reset after voting");

        $display("ALL TESTS PASSED");
        $finish;
    end

endmodule
