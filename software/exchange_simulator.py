import time
from collections import deque
import random
import serial

start_time = time.perf_counter()

filename = "data/WDC_sample.csv"    # Market data file
number_of_ticks = 50000             # Number of data points for price that we want to store
prices = deque(maxlen=2)            # Create empty deque to store market prices

volatility_threshold = 4            # Price change (cents) that is deemed volatile
volatile_event_counter = 0          # Number of instances where price change is volatile

lag_probability = 0.3               # Probability that exchange B lags during a volatile event
sleep_time = 0.01                   # Sleep time between ticks

ser = serial.Serial()               # Create serial object
ser.port = 'COM3'                   # Set the port to COM3
ser.baudrate = 9600                 # Set the baudrate to 9600 bits/sec
ser.open()                          # Open the serial port

header = 0xAA                       # Indicates the beginning of a price transmission
footer = 0x55                       # Indicates the end of a price transmission

try:
    with open(filename, 'r') as f:      # Open our market data
        # Append first price to deque
        prices.append(int(100*float(f.readline().strip().split(',',3)[2])))
        # Find price for rest of the lines and check volatility
        for i in range (1,number_of_ticks):
            prices.append(int(100*float(f.readline().strip().split(',',3)[2])))   # Append prices to deque
            current_price = prices[-1]
            previous_price = prices[-2]

            current_price_upper = (current_price >> 8) & 0xFF       # Upper bits of current price
            current_price_lower = current_price & 0xFF              # Lower bits of current price

            previous_price_upper = (previous_price >> 8) & 0xFF     # Upper bits of previous price
            previous_price_lower = (previous_price) & 0xFF          # Lower bits of previous price

            # During a lag event:
            if ((abs(current_price - previous_price) > volatility_threshold) and random.random() <= lag_probability):
                ser.write(bytearray([header,                                        # Beginning of transmission
                                     current_price_upper, current_price_lower,      # Exchange A's price
                                     previous_price_upper, previous_price_lower,    # Exchange B's delayed price
                                     footer]))                                      # End of transmission
            
            # No lag event:
            else:
                ser.write(bytearray([header,                                        # Beginning of transmission
                                     current_price_upper, current_price_lower,      # Exchange A's price
                                     current_price_upper, current_price_lower,      # Exchange B's matched price
                                     footer]))                                      # End of transmission
            
            time.sleep(sleep_time)

except FileNotFoundError:
    print("Error: File not found.")

ser.close()             # Close the serial port

end_time = time.perf_counter()

# Calculate the elapsed time
elapsed_time = end_time - start_time

print(f"Execution time: {elapsed_time} seconds")