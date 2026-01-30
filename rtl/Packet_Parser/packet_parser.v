/*
This module receives UART packets from two simulated stock exchanges.
It organises these packets into two outputs:
1. The price on exchange A
2. The price on exchange B

These outputs are then sent to a different module that handles trade logic,
checking for arbitrage opportunities.
*/

module packet_parser (
    input clk,                          // 50MHz clock
    input rst,                          // Reset button

    input uart_rx;                      // Connected to uart receive pin

    output reg [15:0] price_A,          // The price on exchange A
    output reg [15:0] price_B,          // The price on exchange B

    output reg packet_valid             // Flag to indicate full transmission complete
    );

    // Finite state machine setup:
    reg FSM_STATE = 1'b0;           // State of the FSM, initially idle
    wire FSM_IDLE = 1'b0;           // If we have just received footer packet or no packets yet
    wire FSM_READING = 1'b1;        // We are reading price packets
    reg [2:0] byte_counter = 0;     // Counts number of received bytes, resets after 4

    wire [7:0] received_packet,     // The packet of data we receive from the host computer
    wire uart_rx_valid;             // Pulses when a byte arrives

    reg [7:0] top_price_A;          // The top 8 bits of exchange A's price
    reg [7:0] bottom_price_A;       // The bittom 8 bits of exchange A's price

    reg [7:0] top_price_B;          // The top 8 bits of exchange B's price
    reg [7:0] bottom_price_B;       // The bittom 8 bits of exchange B's price

    always @ (posedge clk) begin
        packet_valid <= 0;
        if (!rst) begin             // If we press the reset button
            FSM_STATE <= FSM_IDLE;  // Go back to idle state
            packet_valid <= 0;
            price_A <= 0;
            price_B <= 0;
        end else if (uart_rx_valid) begin
            // If we receive the header packet during an idle state
            if (received_packet == 8'hAA && FSM_STATE == FSM_IDLE) begin
                FSM_STATE <= FSM_READING;   // We are now reading prices
                byte_counter <= 0;        // Reset the packet counter
                packet_valid <= 0;
            end else if (FSM_STATE == FSM_READING && byte_counter < 4) begin
                case (byte_counter)
                    0: top_price_A <= received_packet;
                    1: bottom_price_A <= received_packet;
                    2: top_price_B <= received_packet;
                    3: bottom_price_B <= received_packet;
                    default: FSM_STATE <= FSM_READING; 
                endcase
                byte_counter <= byte_counter + 1;
                packet_valid <= 0;
            end else if (FSM_STATE == FSM_READING) begin
                FSM_STATE <= FSM_IDLE;

                if (received_packet == 8'h55) begin
                    price_A <= {top_price_A, bottom_price_A};
                    price_B <= {top_price_B, bottom_price_B};
                    packet_valid <= 1;
                end
            end
        end
    end

    uart_rx uart_receive (
        .clk(clk),
        .resetn(rst),
        .uart_rxd(uart_rx),
        .uart_rx_en(1'b1),
        .uart_rx_valid(uart_rx_valid),
        .uart_rx_data(received_packet)
    )

endmodule