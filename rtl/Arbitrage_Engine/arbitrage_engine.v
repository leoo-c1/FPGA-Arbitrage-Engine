module arbitrage_engine (
    input clk,                      // 50 MHz clock
    input rst,                      // Reset button

    input uart_rx,                  // Receives exchange prices

    output wire uart_tx,            // Transmits profit and trade actions

    // DEBUG OUTPUTS:
    output wire packet_valid,
    output reg [7:0] uart_tx_data,
    output wire uart_tx_busy,
    output reg uart_tx_en,
    output wire [15:0] profit,
    output wire [1:0] trade_action
    );

    //wire packet_valid;              // Flag to indicate full transmission complete

    wire [15:0] price_A;            // Price on exchange A
    wire [15:0] price_B;            // Price on exchange B

    //reg [7:0] uart_tx_data;         // Data to transmit
    //wire uart_tx_busy;              // Flag to indicate if tx is busy sending
    //reg uart_tx_en = 1'b0;          // Tells uart_tx module to send the data
    reg [15:0] profit_storage;      // Safely stores profit
    reg [1:0] trade_storage;        // Safely stores trade action

    wire [7:0] header = 8'hAA;  // Header byte of 0xAA
    //wire [15:0] profit;         // Profit from the trade action
    //wire [7:0] trade_action;    // Buy A, sell B = 01 | buy B, sell A = 10 | no trade = 00
    wire [7:0] footer = 8'h55;  // Footer byte of 0x55

    // Finite state machine setup
    reg [2:0] FSM_STATE = 0;            // State of the FSM, initially idle
    localparam IDLE = 0;                // Not sending any bytes
    localparam SENT_HEADER = 1;         // Sent the header 0xAA
    localparam SENT_TRADE = 2;          // Sent the trade action
    localparam SENT_TOP_PROFIT = 3;     // Sent top bits of profit
    localparam SENT_BOTTOM_PROFIT = 4;  // Sent bottom bits of profit

    always @ (posedge clk) begin
        uart_tx_en <= 1'b0;                         // By default, tx is not sending
        uart_tx_data <= 0;                          // By default, nothing is being sent

        if (!rst) begin                             // If we press the reset button
            FSM_STATE <= IDLE;                      // Set state to idle
            profit_storage <= 0;                    // Clear profit
            trade_storage <= 0;                     // Clear trade action
        end else if (!uart_tx_busy && !uart_tx_en) begin    // If we aren't in the middle of a transmission
            if (FSM_STATE == IDLE) begin            // If we are in the idle state,
                if (trade_action > 0) begin         // and receive a trade,
                    profit_storage <= profit;       // Safely store the profit
                    trade_storage <= trade_action;  // And the trade action
                    uart_tx_data <= header;         // Send the header to indicate start of packet
                    uart_tx_en <= 1'b1;             // Send the byte
                    FSM_STATE <= SENT_HEADER;       // Tell FSM we have sent the header
                end
            end else if (FSM_STATE == SENT_HEADER) begin    // If we have sent the header
                uart_tx_data <= {6'b0, trade_storage};              // Send the stored trade
                uart_tx_en <= 1'b1;                         // Send the byte
                FSM_STATE <= SENT_TRADE;                    // Tell FSM we sent the trade

            end else if (FSM_STATE == SENT_TRADE) begin     // If we have sent the trade
                uart_tx_data <= profit_storage[15:8];       // Send the top 8 bits of profit
                uart_tx_en <= 1'b1;                         // Send the byte
                FSM_STATE <= SENT_TOP_PROFIT;               // Tell FSM we sent the top of profit

            end else if (FSM_STATE == SENT_TOP_PROFIT) begin    // If we sent the top of profit
                uart_tx_data <= profit_storage[7:0];            // Send the bottom 8 bits of profit
                uart_tx_en <= 1'b1;                             // Send the byte
                FSM_STATE <= SENT_BOTTOM_PROFIT;                // Tell FSM we sent the bottom of profit

            end else if (FSM_STATE == SENT_BOTTOM_PROFIT) begin // If we sent the bottom of profit
                uart_tx_data <= footer;                         // Send the footer to end packet
                uart_tx_en <= 1'b1;                             // Send the byte
                FSM_STATE <= IDLE;                              // Move FSM back to the idle state
            end
        end
    end

    packet_parser price_packets (
        .clk(clk),
        .rst(rst),
        .uart_rx(uart_rx),
        .price_A(price_A),
        .price_B(price_B),
        .packet_valid(packet_valid)
    );

    trade_strategy trade_strategy (
        .clk(clk),
        .rst(rst),
        .price_A(price_A),
        .price_B(price_B),
        .packet_valid(packet_valid),
        .profit(profit),
        .trade_action(trade_action)
    );

    uart_tx uart_transmit (
        .clk(clk),
        .resetn(rst),
        .uart_txd(uart_tx),
        .uart_tx_busy(uart_tx_busy),
        .uart_tx_en(uart_tx_en),
        .uart_tx_data(uart_tx_data)
    );

endmodule