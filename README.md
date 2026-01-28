<div align="center">

# FPGA Arbitrage Engine

**A low-latency hardware trade execution engine designed to exploit price discrepancies between simulated stock exchanges.**

![HDL](https://img.shields.io/badge/HDL-Verilog-b55afa)
![Software](https://img.shields.io/badge/Python-Python?logo=python&logoColor=ffe600&label=Software&labelColor=blue&color=5A5A5A)
![Toolchain](https://img.shields.io/badge/Quartus-Quartus?label=Toolchain&color=4eb4fc)
![FPGA](https://img.shields.io/badge/Cyclone%20IV-Cyclone%20IV?logo=intel&label=FPGA&color=f23b27)

</div>

## Overview
This project implements a hardware-based execution engine that can detect and act on latency arbitrage opportunities in real-time. The system simulated two stock exchanges, Exchange A and Exchange B, which stream historical market data for Western Digital (WDC) on the tick level.

A Python-based [Exchange Simulator](https://github.com/leoo-c1/FPGA-Arbitrage-Engine/blob/main/software/exchange_simulator.py) creates simulated latency in Exchange B during periods of market volatility, creating price spreads between exchanges. The FPGA receives this market feed for both exchanges via UART, parses a custom 6-byte protocol and triggers Buy/Sell commands within microseconds of detecting discrepancy.

