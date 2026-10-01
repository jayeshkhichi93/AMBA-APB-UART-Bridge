
# AMBA APB to UART Bridge

RTL design and verification of a 32-bit AMBA APB to 8-bit UART bridge in Verilog.

## 🚀 Project Overview
This project upgrades a standard standalone UART core by architecting a 32-bit AMBA APB slave wrapper, enabling seamless integration with standard SoC buses. 

## 🛠️ Key Features
* **Custom UART Core:** Architected an 8-bit UART core from scratch featuring a 16x oversampling receiver for accurate mid-bit data extraction.
* **AMBA APB Protocol:** Studied and implemented AMBA APB protocol specifications to develop a 3-state wrapper FSM (Idle, Setup, Access), smoothly bridging control signals (`psel`, `penable`, `pwrite`, `pready`) between the SoC bus and the UART module.
* **Advanced Verification:** Built a self-checking loopback testbench (Tx to Rx) featuring smart hardware polling logic for the `rx_done` flag, replacing unreliable hardcoded delays.
* **Hardware Debugging:** Debugged and resolved complex simulation race conditions and delta-cycle sampling mismatches between testbench tasks and the RTL FSM using industry-standard delay techniques.

## 💻 Tools & Technologies
* **Hardware Description Language:** Verilog
* **Simulator:** Icarus Verilog
* **Waveform Analyzer:** GTKWave
* **Environment:** Linux (Windows Subsystem for Linux - WSL)

## ⚙️ How to Run the Simulation
To compile and run the verification testbench, execute the following commands in your terminal:

```bash
iverilog -o apb_uart.out apb_uart_tb.v apb_uart.v uart.v trx.v rx.v baud_generator.v
vvp apb_uart.out
gtkwave apb_uart.vcd

📊 Simulation Results
Successfully verified Tx-Rx loopback data transmission. The testbench correctly writes data via APB, waits for UART transmission, and reads the exact updated data from the APB read channel without hanging the bus.
```
<img width="1601" height="326" alt="image" src="https://github.com/user-attachments/assets/ad438f2f-5d75-4687-8644-35688148d61b" />

<img width="795" height="212" alt="image" src="https://github.com/user-attachments/assets/d08d40ec-89de-4a2c-a7c1-83ef1f121856" />

