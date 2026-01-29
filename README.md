<div align="center">

# FPGA Arbitrage Engine

**A low-latency hardware trade execution engine designed to exploit price discrepancies between simulated stock exchanges.**

![HDL](https://img.shields.io/badge/HDL-Verilog-b55afa?logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZlcnNpb249IjEiIHdpZHRoPSIzNCIgaGVpZ2h0PSIzNCI+PHBhdGggZD0iTTkgMXYzMk0xNyAxdjMyTTI1IDF2MzJNMSA5aDMyTTEgMTdoMzJNMSAyNWgzMiIgc3Ryb2tlPSIjZmZmIiBzdHJva2Utd2lkdGg9IjIiIHN0cm9rZS1saW5lY2FwPSJyb3VuZCIvPjxyZWN0IHg9IjUiIHk9IjUiIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgcng9IjQiIGZpbGw9IiNmZmYiLz48dGV4dCB4PSIxNyIgeT0iMTciIGZvbnQtc2l6ZT0iMTIiIHRleHQtYW5jaG9yPSJtaWRkbGUiIGRvbWluYW50LWJhc2VsaW5lPSJtaWRkbGUiIGZpbGw9IiM1QTVBNUEiIGZvbnQtZmFtaWx5PSJtb25vc3BhY2UiIGZvbnQtd2VpZ2h0PSJib2xkIj4mbHQ7LyZndDs8L3RleHQ+PC9zdmc+)
![Software](https://img.shields.io/badge/Python-Python?logo=python&logoColor=ffe600&label=Software&labelColor=4772A0&color=5A5A5A)
![Toolchain](https://img.shields.io/badge/Quartus%20Prime-Quartus%20Prime?label=Toolchain&color=2f91d6)
![FPGA](https://img.shields.io/badge/Cyclone%20IV-Cyclone%20IV?logo=intel&logoColor=blue&label=FPGA&labelColor=lightgrey&color=grey)

</div>

## Overview
This project implements a hardware-based execution engine that can detect and act on latency arbitrage opportunities in real-time. The system simulated two stock exchanges, Exchange A and Exchange B, which stream historical market data for Western Digital (WDC) on the tick level.

A Python-based [Exchange Simulator](https://github.com/leoo-c1/FPGA-Arbitrage-Engine/blob/main/software/exchange_simulator.py) creates simulated latency in Exchange B during periods of market volatility, creating price spreads between exchanges. The FPGA receives this market feed for both exchanges via UART, parses a custom 6-byte protocol and triggers Buy/Sell commands within microseconds of detecting discrepancy.



