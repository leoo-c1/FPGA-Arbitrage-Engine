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
        trade_action <= 2'b00;

        if (!rst) begin
            trade_action <= 2'b00;
            profit <= 0;
        end else if (packet_valid) begin
            if (price_A > price_B) begin
                trade_action <= 2'b10;
                profit <= price_A - price_B;
            end else if (price_B > price_A) begin
                trade_action <= 2'b01;
                profit <= price_B - price_A;
            end else begin
                trade_action <= 2'b00;
                profit <= 0;
            end
        end
    end

endmodule