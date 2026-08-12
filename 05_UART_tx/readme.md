UART Transmitter — Verilog
Overview

This project implements a UART (Universal Asynchronous Receiver/Transmitter) transmitter using Verilog/SystemVerilog.

The transmitter takes an 8-bit parallel data input and converts it into a serial data stream on a single TX line.

UART communication is asynchronous, so no clock signal is transmitted along with the data. The receiver determines the timing of the incoming bits based on the agreed baud rate.

UART Frame

For every 8-bit data byte, the transmitter sends:

Idle   Start    Data Bits             Stop
 1       0      D0 D1 D2 D3 D4 D5 D6 D7   1

The data is transmitted LSB first.

For example, if:

tx_data = 8'h41

then:

8'h41 = 0100_0001

The serial transmission is:

Start  D0 D1 D2 D3 D4 D5 D6 D7  Stop
  0     1  0  0  0  0  0  1  0    1

The TX line remains HIGH when the transmitter is idle.

Design

The UART transmitter uses four states:

State	TX	Description
IDLE	1	Waiting for tx_start
START	0	Sends start bit
DATA	D0-D7	Sends 8 data bits
STOP	1	Sends stop bit

The design uses:

data_reg — stores the 8-bit data
baud_counter — controls how long each bit remains on TX
bit_counter — selects which data bit is being transmitted
state — controls the UART transmission sequence
tx_busy — indicates that transmission is in progress
Inputs and Outputs
Signal	Direction	Description
clk	Input	System clock
reset	Input	Resets the transmitter
tx_start	Input	Starts a transmission
tx_data[7:0]	Input	8-bit data to transmit
tx	Output	Serial UART output
tx_busy	Output	HIGH while transmitting
Bit Timing

The current design uses:

CLKS_PER_BIT = 10

Therefore, one UART bit lasts for 10 clock cycles.

The baud counter counts the clock cycles for each bit and changes the TX output only after the required number of cycles.

This is important because simply sending one bit on every positive clock edge would make the UART bit rate equal to the system clock frequency. The baud counter allows the system clock to run faster than the actual UART data rate.

Transmission Sequence

When tx_start becomes HIGH:

IDLE
  ↓
START
  ↓
DATA
  ↓
STOP
  ↓
IDLE

During transmission:

tx_busy = 1

After the stop bit:

tx_busy = 0
tx = 1

The transmitter is then ready for another byte.

Testbench

The testbench verifies:

Reset behavior
TX idle state
tx_busy behavior
Start bit
All 8 data bits
LSB-first transmission
Stop bit
Return to idle
Multiple data patterns

The following values are tested:

8'h41
8'h00
8'hFF
8'hA5
8'h5A
8'hAA
8'h55
8'h3C

These patterns include all zeros, all ones, alternating bits, and mixed data patterns.

Simulation

The project can be simulated using Icarus Verilog.

Compile:

iverilog -g2012 -Wall -o uart_sim design.sv testbench.sv

Run:

vvp uart_sim

The testbench also generates:

uart.vcd

which can be used to inspect the UART signals in a waveform viewer.

Expected Result

A successful simulation should end with:

TOTAL TESTS = ...
TOTAL ERRORS = 0
ALL TESTS PASSED
Project Structure
05_UART_tx/
│
├── design.sv
├── testbench.sv
└── waveform.png
What I Learned

Through this project, I practiced:

UART communication
Serial vs parallel data
Start and stop bits
LSB-first transmission
Baud-rate timing
Clock-cycle counting
FSM-based RTL design
Counters in RTL
tx_busy handshaking
Verilog/SystemVerilog testbench development
Functional verification
Reading RTL simulation waveforms
Future Improvements

Possible extensions to this project include:

Parameterized baud-rate generation
UART receiver
Full UART TX/RX communication
Configurable data width
Configurable stop bits
Parity-bit support
Loopback testing
Self-checking TX/RX verification
Technologies
Verilog/SystemVerilog
Icarus Verilog
EDA Playground
Git/GitHub

Project: UART Transmitter
Folder: 05_UART_tx
