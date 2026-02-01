`timescale 1ns/100ps

module arbitrage_engine_tb;
    reg clk;            // 50 MHz clock
    reg rst;            // Reset button

    reg uart_rx;        // Receives exchange prices

    wire uart_tx;       // Transmits profit and trade actions

    localparam real BIT_PERIOD = 104167;

    arbitrage_engine arbitrage_engine_test (
        .clk(clk),
        .rst(rst),
        .uart_rx(uart_rx),
        .uart_tx(uart_tx),
    );

    initial begin
        clk = 0;            // Initially, clock is low
        rst = 0;            // Reset is high
        uart_rx = 1;        // We are in the UART idle state

        #200 rst = 1;       // After 200ns, turn off the reset signal
        #200;               // Wait another 200ns doing nothing

        // Send the start bit to indicate the beginning of the transmission
        uart_rx = 0; #(BIT_PERIOD);

        // Send the header byte, one bit at a time
        // Header = 0xAA = 10101010
        uart_rx = 0; #(BIT_PERIOD);     // Bit 0
        uart_rx = 1; #(BIT_PERIOD);     // Bit 1
        uart_rx = 0; #(BIT_PERIOD);     // Bit 2
        uart_rx = 1; #(BIT_PERIOD);     // Bit 3
        uart_rx = 0; #(BIT_PERIOD);     // Bit 4
        uart_rx = 1; #(BIT_PERIOD);     // Bit 5
        uart_rx = 0; #(BIT_PERIOD);     // Bit 6
        uart_rx = 1; #(BIT_PERIOD);     // Bit 7

        // Send the end bit to indicate the end of the transmission
        uart_rx = 1; #(BIT_PERIOD);

        // Send the start bit to indicate the beginning of the transmission
        uart_rx = 0; #(BIT_PERIOD);

        // Send the top byte of price A ($42.70 = 0001000010101110), one bit at a time 
        // Top of $42.70 -> 4270 = 00010000
        uart_rx = 0; #(BIT_PERIOD);     // Bit 0
        uart_rx = 0; #(BIT_PERIOD);     // Bit 1
        uart_rx = 0; #(BIT_PERIOD);     // Bit 2
        uart_rx = 0; #(BIT_PERIOD);     // Bit 3
        uart_rx = 1; #(BIT_PERIOD);     // Bit 4
        uart_rx = 0; #(BIT_PERIOD);     // Bit 5
        uart_rx = 0; #(BIT_PERIOD);     // Bit 6
        uart_rx = 0; #(BIT_PERIOD);     // Bit 7

        // Send the end bit to indicate the end of the transmission
        uart_rx = 1; #(BIT_PERIOD);

        // Send the start bit to indicate the beginning of the transmission
        uart_rx = 0; #(BIT_PERIOD);

        // Send the bottom byte of price A ($42.70 = 0001000010101110), one bit at a time 
        // Bottom of $42.70 -> 4270 = 10101110
        uart_rx = 0; #(BIT_PERIOD);     // Bit 0
        uart_rx = 1; #(BIT_PERIOD);     // Bit 1
        uart_rx = 1; #(BIT_PERIOD);     // Bit 2
        uart_rx = 1; #(BIT_PERIOD);     // Bit 3
        uart_rx = 0; #(BIT_PERIOD);     // Bit 4
        uart_rx = 1; #(BIT_PERIOD);     // Bit 5
        uart_rx = 0; #(BIT_PERIOD);     // Bit 6
        uart_rx = 1; #(BIT_PERIOD);     // Bit 7

        // Send the end bit to indicate the end of the transmission
        uart_rx = 1; #(BIT_PERIOD);

        // Send the start bit to indicate the beginning of the transmission
        uart_rx = 0; #(BIT_PERIOD);

        // Send the top byte of price B ($42.35 = 0001000010001011), one bit at a time 
        // Top of $42.35 -> 4235 = 00010000
        uart_rx = 0; #(BIT_PERIOD);     // Bit 0
        uart_rx = 0; #(BIT_PERIOD);     // Bit 1
        uart_rx = 0; #(BIT_PERIOD);     // Bit 2
        uart_rx = 0; #(BIT_PERIOD);     // Bit 3
        uart_rx = 1; #(BIT_PERIOD);     // Bit 4
        uart_rx = 0; #(BIT_PERIOD);     // Bit 5
        uart_rx = 0; #(BIT_PERIOD);     // Bit 6
        uart_rx = 0; #(BIT_PERIOD);     // Bit 7

        // Send the end bit to indicate the end of the transmission
        uart_rx = 1; #(BIT_PERIOD);

        // Send the start bit to indicate the beginning of the transmission
        uart_rx = 0; #(BIT_PERIOD);

        // Send the bottom byte of price B ($42.35 = 0001000010001011), one bit at a time 
        // Bottom of $42.35 -> 4235 = 10001011
        uart_rx = 1; #(BIT_PERIOD);     // Bit 0
        uart_rx = 1; #(BIT_PERIOD);     // Bit 1
        uart_rx = 0; #(BIT_PERIOD);     // Bit 2
        uart_rx = 1; #(BIT_PERIOD);     // Bit 3
        uart_rx = 0; #(BIT_PERIOD);     // Bit 4
        uart_rx = 0; #(BIT_PERIOD);     // Bit 5
        uart_rx = 0; #(BIT_PERIOD);     // Bit 6
        uart_rx = 1; #(BIT_PERIOD);     // Bit 7

        // Send the end bit to indicate the end of the transmission
        uart_rx = 1; #(BIT_PERIOD);

        // Send the start bit to indicate the beginning of the transmission
        uart_rx = 0; #(BIT_PERIOD);

        // Send the footer byte, one bit at a time
        // Footer = 0x55 = 01010101
        uart_rx = 1; #(BIT_PERIOD);     // Bit 0
        uart_rx = 0; #(BIT_PERIOD);     // Bit 1
        uart_rx = 1; #(BIT_PERIOD);     // Bit 2
        uart_rx = 0; #(BIT_PERIOD);     // Bit 3
        uart_rx = 1; #(BIT_PERIOD);     // Bit 4
        uart_rx = 0; #(BIT_PERIOD);     // Bit 5
        uart_rx = 1; #(BIT_PERIOD);     // Bit 6
        uart_rx = 0; #(BIT_PERIOD);     // Bit 7

        // Send the end bit to indicate the end of the transmission
        uart_rx = 1; #(BIT_PERIOD);

        // Wait 10ms
        #(10_000_000);

        $stop(2);
    end

    always begin
        #10 clk = !clk;
    end


endmodule