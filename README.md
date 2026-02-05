<div align="center">

# FPGA Arbitrage Engine

![HDL](https://img.shields.io/badge/HDL-Verilog-7177bd?logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZlcnNpb249IjEiIHdpZHRoPSIyMCIgaGVpZ2h0PSIxNiI+PHRleHQgeD0iMTAiIHk9IjgiIGZvbnQtc2l6ZT0iMTIiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGZpbGw9IiNmZmYiIGZvbnQtZmFtaWx5PSJtb25vc3BhY2UiIGRvbWluYW50LWJhc2VsaW5lPSJtaWRkbGUiIGZvbnQtd2VpZ2h0PSJib2xkIj4mbHQ7LyZndDs8L3RleHQ+PC9zdmc+)
![Software](https://img.shields.io/badge/Python-Python?logo=python&logoColor=white&label=Software&labelColor=grey&color=4772A0)
![Toolchain](https://img.shields.io/badge/Quartus-Quartus?logo=intel&logoColor=white&label=Toolchain&labelColor=grey&color=%233995e6)
![FPGA](https://img.shields.io/badge/Cyclone%20IV-Cyclone%20IV?logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZlcnNpb249IjEiIHdpZHRoPSIzNCIgaGVpZ2h0PSIzNCI+PHJlY3QgeD0iNSIgeT0iNSIgd2lkdGg9IjI0IiBoZWlnaHQ9IjI0IiByeD0iMSIgc3Ryb2tlPSIjZmZmIiBmaWxsPSIjNWE1YTVhIiBzdHJva2Utd2lkdGg9IjEuNSIvPjxwYXRoIGQ9Ik05LjUgMXYzMm01LTMydjMybTUtMzJ2MzJtNS0zMnYzMk0xIDkuNWgzMm0tMzIgNWgzMm0tMzIgNWgzMm0tMzIgNWgzMiIgc3Ryb2tlPSIjZmZmIiBzdHJva2Utd2lkdGg9IjEuNSIvPjxwYXRoIHN0cm9rZT0iIzVhNWE1YSIgZmlsbD0iIzVhNWE1YSIgZD0iTTggOGgxOHYxOEg4eiIvPjxwYXRoIHN0cm9rZT0iI2ZmZiIgZmlsbD0iIzVhNWE1YSIgc3Ryb2tlLXdpZHRoPSIxLjUiIGQ9Ik0xMiAxMmgxMHYxMEgxMnoiLz48L3N2Zz4=&label=FPGA&labelColor=grey&color=%231e2033)

**A low-latency hardware arbitrage engine designed to exploit price discrepancies between simulated exchanges.**

![Snapshot of simulation results](https://github.com/leoo-c1/FPGA-Arbitrage-Engine/blob/main/data/Figure_1.png?raw=true)

</div>

## Overview
This project implements a hardware-based execution engine that can detect and act on latency arbitrage opportunities in real-time. The system simulates two stock exchanges, Exchange A and Exchange B, which stream historical [market data](/data) for Western Digital (WDC) on the tick level.

A Python-based [Exchange Simulator](software/exchange_simulator.py) creates simulated latency in Exchange B during periods of market volatility, creating price spreads between exchanges. Using [RTL modules](/rtl), the FPGA receives this market feed for both exchanges via UART, parses a custom 6-byte protocol and triggers Buy/Sell commands within microseconds of detecting discrepancy, which are returned to the Exchange Simulator.

## System Architecture

The project functions as a hardware-in-the-loop simulation connecting a Python script to the FPGA.

1. The Python script (`exchange_simulator.py`) reads historical pricing data from a CSV file. It simulates two exchanges, Exchange A and Exchange B, occasionally delaying the price updates on "Exchange B" during volatility on Exchange A to create a temporary price difference.
2. The simulator packages the prices for both exchanges into a custom byte sequence and sends it to the FPGA over UART.
3. The FPGA reads the incoming bytes. It buffers the data and only updates the internal price registers once a full, valid packet is received to ensure data integrity (`packet_parser.v`).
4. The system compares the two exchange prices in real-time. If there is a difference in share price on the exchanges, an arbitrage opportunity is detected, which triggers a trade signal (`trade_strategy.v`).
5. Upon triggering a trade, the system captures the current profit and trade action, then transmits a report back to the Python script (`arbitrage_engine.v`).

## Communication Protocol

The system uses a fixed-length byte protocol over UART (115200 baud).

### Inbound Packet (Host to FPGA)
Prices are scaled by 100 and sent as integers.

| Byte | Value | Description |
| :---: | :---: | :--- |
| **0** | `0xAA` | Header |
| **1** | `0xXX` | Exchange A Price (High Byte) |
| **2** | `0xXX` | Exchange A Price (Low Byte) |
| **3** | `0xXX` | Exchange B Price (High Byte) |
| **4** | `0xXX` | Exchange B Price (Low Byte) |
| **5** | `0x55` | Footer |

### Outbound Packet (FPGA to Host)
The FPGA only sends data when a trade occurs.

| Byte | Value | Description |
| :---: | :---: | :--- |
| **0** | `0xAA` | Header |
| **1** | `0x01` / `0x02` | Action: `0x01` (Buy A / Sell B) or `0x02` (Buy B / Sell A) |
| **2** | `0xXX` | Profit (High Byte) |
| **3** | `0xXX` | Profit (Low Byte) |
| **4** | `0x55` | Footer |

## Hardware Implementation Details

The project is configured for the Intel Cyclone IV EP4CE6E22C8N FPGA on the [RZ-EasyFPGA A2.2 / RZ-EP4CE6-WX board](https://web.archive.org/web/20210128152708/http://rzrd.net/product/?79_502.html) by Ruizhi Technology Co, but can be reused for a variety of boards.

### Pinout Configuration

| Signal Group | Signal Name | FPGA Pin | Description |
| :--- | :--- | :--- | :--- |
| **System** | `sys_clk` | **PIN_23** | 50MHz On-board Clock |
| | `rst` | **PIN_25** | Active Low Reset Button |
| **UART** | `uart_rx` | **PIN_114** | Serial Receive |
| | `uart_tx` | **PIN_115** | Serial Transmit |

### UART Communication Interface
To communicate with the board via UART, an external USB-to-Serial converter is used. The FPGA logic voltage is 3.3V, so the adapter must be configured correctly to avoid damaging the pins (on the XC4464, the onboard switch can be set to 3.3V to achieve this).

**Hardware Adapter:**\
[Duinotech Arduino Compatible USB to Serial Adaptor (XC4464)](https://www.jaycar.com.au/duinotech-arduino-compatible-usb-to-serial-adaptor/p/XC4464) | [XC4464 Manual](https://media.jaycar.com.au/product/resources/XC4464_manualMain_74523.pdf)
> **Important:** Ensure the voltage selection switch on the adapter is set to 3.3V. Do not connect the 5V pin.

| Adapter Pin | FPGA Pin | Description |
| :--- | :--- | :--- |
| **GND** | **GND** | Common Ground |
| **CTS** | **N/C** | **Do Not Connect** |
| **5V** | **N/C** | **Do Not Connect** |
| **TXD** | **PIN_114** | Serial Transmit (Connects to FPGA `uart_rx`) |
| **RXD** | **PIN_115** | Serial Receive (Connects to FPGA `uart_tx`) |
| **DTR** | **N/C** | **Do Not Connect** |

## Project Structure

```text
├── data/
│   └── WDC_sample.csv          # Historical market data (CSV)
├── quartus/                    # Quartus Prime project files
│   ├── Arbitrage_Engine.qpf
│   └── Arbitrage_Engine.qsf
├── rtl/                        # Verilog source code
│   ├── Arbitrage_Engine/
│   │   └── arbitrage_engine.v  # Top-level module and TX control
│   ├── Packet_Parser/
│   │   └── packet_parser.v     # UART packet deserialization
│   ├── Trade_Strategy/
│   │   └── trade_strategy.v    # Trading logic and comparison
│   └── UART_Communication/     # UART Interface modules
│       ├── uart_communication.v
│       ├── uart_rx.v
│       └── uart_tx.v
├── software/                   # Python simulation scripts
│   └── exchange_simulator.py
└── tb/                         # Testbenches
    ├── arbitrage_engine_tb.v
    ├── packet_parser_tb.v
    ├── trade_strategy_tb.v
    └── arb_wave.wlf            # Waveform log file for Questa
```















