`timescale 1ns/100ps

module trade_strategy_tb;
    reg clk;                    // 50MHz clock
    reg rst;                    // Reset button

    reg [15:0] price_A;         // Price on exchange A
    reg [15:0] price_B;         // Price on exchange B

    reg packet_valid;           // If we have received a full 6-byte price transmission

    wire [15:0] profit;         // Profit from the trade action
    wire [1:0] trade_action;    // Either no trade, buy on A + sell on B or buy on B + sell on A
                                // Buy A, sell B = 01 | buy B, sell A = 10 | no trade = 00

    trade_strategy trade_strategy_test (
        .clk(clk),
        .rst(rst),
        .price_A(price_A),
        .price_B(price_B),
        .packet_valid(packet_valid),
        .profit(profit),
        .trade_action(trade_action)
    );

    initial begin
        clk = 0;                // Initially, clock is low
        rst = 0;                // Reset is high
        price_A = 0;            // No price data received from Exchange A
        price_B = 0;            // No price data received from Exchange B
        packet_valid = 0;       // No valid packet received

        #200 rst = 1;           // After 200ns, turn off the reset signal
        #200;                   // Wait another 200ns doing nothing

        price_A = 16'd4270;     // Set price A to $42.70
        price_B = 16'd4235;     // Set price B to $42.35

        #10 packet_valid = 1;   // After 10ns, pulse the packet_valid signal
        #10 packet_valid = 0;   // Pulse it off again after 10ns

        #5000;                  // Wait a bit
        $stop(2);
    end

    always begin
        #10 clk = !clk;
    end


endmodule