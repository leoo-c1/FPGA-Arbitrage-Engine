exchange_simulator.py is the python code for parsing our market data and simulating arbitrage opportunities by creating lag between two Exchanges (A and B) during volatile price changes in Exchange A.

It first reads from the .csv containing market data, and extracts prices from each line.
We multiply by 100 to turn our dollars and cents combo into a single integer.
Prices may include more than 2 digits after the decimal point, so we force the result of 100*price to be an integer. These prices get sent to an FPGA via UART.

UART transmitter structure:
Byte 0: Header, indicates beginning of price transmission (0xAA)
Byte 1: Upper 8 bits of Exchange A's price
Byte 2: Lower 8 bits of Exchange A's price
Byte 3: Upper 8 bits of Exchange B's price
Byte 4: Lower 8 bits of Exchange B's price
Byte 5: Footer, indicates end of price transmission (0x55)

The FPGA also returns trade actions and calculated profit, which this program receives.

UART receiver structure:
Byte 0: Header, indicates beginning of transmission (0xAA)
Byte 1: Trade action (Buy A, sell B = 01 | Buy B, sell A = 10 | No trade = 00)
Byte 2: Upper 8 bits of profit from trade
Byte 3: Lower 8 bits of profit from trade
Byte 4: Footer, indicates end of transmission (0x55)