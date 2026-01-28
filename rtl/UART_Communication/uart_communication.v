/*
Original author: Ben Marshall
Source repository: https://github.com/ben-marshall/uart
License: MIT

Note: I have used Ben Marshall's project to provide UART functionality for my other FPGA projects.
No significant changes have been made to the original author's implementation.
*/

module uart_communication #(
    parameter CLK_HZ = 50000000,
    parameter BIT_RATE = 9600,
    parameter PAYLOAD_BITS = 8
) (
    // Physical Pins
    input        clk,           // 50MHz clock signal
    input        rst,          // Reset key
    input  wire  uart_rxd,      // Received data
    output wire  uart_txd,      // Transmitted data

    // 1. Data coming OUT of the module
    output wire [PAYLOAD_BITS-1:0] uart_rx_data,    // Also received data
    output wire       uart_rx_valid,                // Flag to indicate data has been received
    output wire  uart_rx_break,                     // Detects if we send a null byte (00000000)
    
    // 2. Data going INTO the module
    input  wire [PAYLOAD_BITS-1:0] uart_tx_data,    // Data to transmit
    input  wire       uart_tx_en,               // Flag to indicate data is ready to transmit
    output wire       uart_tx_busy              // Flag to indicate data is currently being sent
);

    // ------------------------------------------------------------------------- 

    // UART RX Instantiation
    uart_rx #(
        .BIT_RATE(BIT_RATE),
        .PAYLOAD_BITS(PAYLOAD_BITS),
        .CLK_HZ  (CLK_HZ  )
    ) i_uart_rx(
        .clk          (clk          ), 
        .resetn       (rst          ), // Connected to KEY1
        .uart_rxd     (uart_rxd     ), 
        .uart_rx_en   (1'b1         ), 
        .uart_rx_break(uart_rx_break), 
        .uart_rx_valid(uart_rx_valid), 
        .uart_rx_data (uart_rx_data )  
    );

    // UART TX Instantiation
    uart_tx #(
        .BIT_RATE(BIT_RATE),
        .PAYLOAD_BITS(PAYLOAD_BITS),
        .CLK_HZ  (CLK_HZ  )
    ) i_uart_tx(
        .clk          (clk          ),
        .resetn       (rst          ), // Connected to KEY1
        .uart_txd     (uart_txd     ),
        .uart_tx_en   (uart_tx_en   ),
        .uart_tx_busy (uart_tx_busy ),
        .uart_tx_data (uart_tx_data ) 
    );

endmodule
