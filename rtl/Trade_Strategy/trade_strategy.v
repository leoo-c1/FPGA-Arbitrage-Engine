module trade_strategy (
    input clk,                  // 50MHz clock
    input rst,                  // Reset button

    input wire [15:0] price_A,   // Price on exchange A
    input wire [15:0] price_B,   // Price on exchange B

    input packet_valid,          // If we have received a full 6-byte price transmission

    output reg [15:0] profit,       // Profit from the trade action
    output reg [1:0] trade_action   // Either no trade, buy on A + sell on B or buy on B + sell on A
                                    // Buy A, sell B = 01 | buy B, sell A = 10 | no trade = 00
    );

    always @ (posedge clk) begin
        trade_action <= 2'b00;      // Default assignment of no trade

        if (!rst) begin             // If the reset button is pressed
            trade_action <= 2'b00;  // No trade action
            profit <= 0;            // No profit
        end else if (packet_valid) begin            // If we receive a valid uart packet
            if (price_A > price_B) begin            // Check for arbitrage
                trade_action <= 2'b10;              // Buy on B, sell on A
                profit <= price_A - price_B;
            end else if (price_B > price_A) begin   // Check for arbitrage
                trade_action <= 2'b01;              // Buy on A, sell on B
                profit <= price_B - price_A;
            end else begin                          // No arbitrage opportunity
                trade_action <= 2'b00;              // No trade action
                profit <= 0;                        // No profit
            end
        end
    end

endmodule