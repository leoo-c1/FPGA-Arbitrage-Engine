'''
This is the python code for parsing our market data.

It first reads from the .csv containing market data, and extracts prices from each line.
We multiply by 100 to turn our dollars and cents combo into a single integer.
Prices may include more than 2 digits after the decimal point, so we force the result of 100*price to be an integer.

'''
import numpy as np
import time

start_time = time.perf_counter()

filename = "data/WDC_sample.csv"        # Market data file
number_of_ticks = 49999                    # Number of data points for price that we want to store
prices = np.zeros(number_of_ticks)      # Create empty np array with enough size for our price data

try:
    with open(filename, 'r') as f:              # Open our market data
        # Find price for first 20 lines
        for i in range (number_of_ticks):
            prices[i] = f.readline().strip().split(',',3)[2]              # Add each line's price to our prices array
            # print(f"Price {i}: ${f.readline().strip().split(',',3)[2]}")    # On each line, extract the price
except FileNotFoundError:
    print("Error: File not found.")

end_time = time.perf_counter()

# Calculate the elapsed time
elapsed_time = end_time - start_time

print(elapsed_time)