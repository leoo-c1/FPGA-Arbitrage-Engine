filename = "data/WDC_tickbidask.csv"

print("\nString manipulation begin:")
print(f"Opening {filename}...")
try:
    with open(filename, 'r') as f:
        # Find price for first 20 lines
        for i in range (21):
            print(f"Price {i}: ${f.readline().strip().split(",",3)[2]}")
except FileNotFoundError:
    print("Error: File not found.")