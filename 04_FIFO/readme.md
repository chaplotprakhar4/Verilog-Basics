# 04_FIFO — 4-bit Synchronous FIFO

A **4-bit × 16-depth FIFO (First-In First-Out)** designed in Verilog and verified using a self-checking testbench.

This project demonstrates RTL design, memory usage, read/write pointers, FIFO status flags, counter-based occupancy tracking, reset behavior, and functional verification.

---

## 📌 Project Overview

A FIFO stores data in the order it is received.

The first data written into the FIFO is the first data read from it.

For this project:

* **Data width:** 4 bits
* **FIFO depth:** 16 entries
* **Total storage:** 16 × 4 bits
* **Write pointer:** 4 bits
* **Read pointer:** 4 bits
* **Counter:** 5 bits
* **Read/Write operations:** Controlled by enable signals
* **Reset:** Asynchronous active-high reset

### FIFO Concept

```text
             WRITE
               │
               ▼
        ┌───────────────┐
        │               │
        │     FIFO      │
din ───►│   16 × 4-bit  │───► dout
        │    Memory     │
        │               │
        └───────────────┘
               ▲
               │
              READ
```

---

## 📁 Project Structure

```text
04_FIFO/
│
├── design.sv
├── testbench.sv
└── waveform.png
```

### `design.sv`

Contains the FIFO RTL implementation.

### `testbench.sv`

Contains the self-checking verification environment.

### `waveform.png`

Waveform captured during FIFO simulation.

---

## 🔧 FIFO Interface

| Signal         | Direction | Width | Description                    |
| -------------- | --------- | ----: | ------------------------------ |
| `clk`          | Input     |     1 | Clock                          |
| `reset`        | Input     |     1 | Active-high asynchronous reset |
| `write_enable` | Input     |     1 | Enables FIFO write             |
| `read_enable`  | Input     |     1 | Enables FIFO read              |
| `write_data`   | Input     |     4 | Data written into FIFO         |
| `read_data`    | Output    |     4 | Data read from FIFO            |
| `full`         | Output    |     1 | Indicates FIFO is full         |
| `empty`        | Output    |     1 | Indicates FIFO is empty        |

---

## 🧠 Internal Architecture

The FIFO uses three main pieces of state:

### 1. Memory

```verilog
reg [3:0] memory [0:15];
```

This creates:

```text
16 locations × 4 bits
```

The valid memory addresses are:

```text
0 → 15
```

---

### 2. Write Pointer

```verilog
reg [3:0] write_ptr;
```

The write pointer selects where the next input data will be stored.

During a valid write:

```verilog
memory[write_ptr] <= write_data;
write_ptr <= write_ptr + 1'b1;
```

Therefore:

```text
write_ptr
    ↓
memory location
    ↓
write_data
```

Because `write_ptr` is 4 bits, it naturally wraps from:

```text
15 → 0
```

---

### 3. Read Pointer

```verilog
reg [3:0] read_ptr;
```

The read pointer selects where the next data will be read.

During a valid read:

```verilog
read_data <= memory[read_ptr];
read_ptr <= read_ptr + 1'b1;
```

The pointer also wraps:

```text
15 → 0
```

---

### 4. Count

```verilog
reg [4:0] count;
```

The 5-bit counter tracks the number of entries currently stored in the FIFO.

Possible values:

```text
0 → 16
```

For example:

```text
count = 0   → FIFO empty
count = 8   → 8 entries stored
count = 16  → FIFO full
```

The counter is updated according to the operation:

```text
Write only → count + 1
Read only  → count - 1
Both       → count unchanged
Neither    → count unchanged
```

---

# 🚦 FIFO Status Flags

The FIFO uses two status signals.

## Empty

After reset:

```text
count = 0
empty = 1
```

When the last stored item is read:

```text
count = 1
       ↓
read
       ↓
count = 0
empty = 1
```

A read is prevented when:

```verilog
read_enable && !empty
```

---

## Full

When the FIFO contains the maximum 16 entries:

```text
count = 16
full = 1
```

A write is prevented when:

```verilog
write_enable && !full
```

The RTL detects the transition to full using:

```verilog
if (count == 5'd15)
    full <= 1'b1;
```

Because the counter is incremented during the same clock cycle, the FIFO becomes full after the 16th valid write.

---

# 🔄 FIFO Operations

The RTL uses:

```verilog
case ({write_enable && !full,
       read_enable && !empty})
```

This creates four possible situations.

| Write | Read | Case    | Operation               |
| ----: | ---: | ------- | ----------------------- |
|     0 |    0 | `2'b00` | No operation            |
|     0 |    1 | `2'b01` | Read only               |
|     1 |    0 | `2'b10` | Write only              |
|     1 |    1 | `2'b11` | Simultaneous read/write |

---

## Write Only

```text
write = 1
read  = 0
```

The FIFO:

```text
memory[write_ptr] ← write_data
write_ptr         ← write_ptr + 1
count             ← count + 1
```

---

## Read Only

```text
write = 0
read  = 1
```

The FIFO:

```text
read_data ← memory[read_ptr]
read_ptr  ← read_ptr + 1
count     ← count - 1
```

---

## Simultaneous Read and Write

```text
write = 1
read  = 1
```

Both operations can happen during the same clock cycle.

The counter remains unchanged:

```text
count = count
```

because one item enters while one item leaves.

---

## No Operation

```text
write = 0
read  = 0
```

The FIFO maintains its current state.

---

# 🔄 Reset Behavior

The FIFO uses an asynchronous active-high reset:

```verilog
always @(posedge clk or posedge reset)
```

When:

```text
reset = 1
```

the FIFO is initialized:

```text
write_ptr = 0
read_ptr  = 0
count     = 0
read_data = 0
full      = 0
empty     = 1
```

Therefore, immediately after reset:

```text
FIFO = EMPTY
```

---

# 🧪 Verification Strategy

The testbench is **self-checking**.

Instead of only observing the waveform manually, the testbench compares the actual FIFO output against expected data.

For example:

```verilog
if (read_data !== expected_data)
```

If the expected and actual values differ:

```text
ERROR
```

is displayed and the error counter is incremented.

---

# ✅ Test Cases

The testbench verifies several important scenarios.

### Test 1 — Reset

After reset:

```text
empty = 1
full  = 0
```

---

### Test 2 — Basic Write and Read

The following values are written:

```text
1 → 2 → 3 → 4
```

Then they are read back:

```text
1 → 2 → 3 → 4
```

This verifies the fundamental FIFO property:

> **First In → First Out**

---

### Test 3 — Fill the FIFO

The testbench writes 16 values:

```text
0 → 1 → 2 → ... → 15
```

After all 16 entries are stored:

```text
full = 1
```

---

### Test 4 — Write While Full

The testbench attempts:

```text
write = F
```

while the FIFO is full.

Because the design uses:

```verilog
write_enable && !full
```

the write is blocked.

---

### Test 5 — FIFO Ordering

The testbench reads:

```text
0
1
2
3
```

Then writes:

```text
A
B
C
D
```

Then reads:

```text
4
5
6
7
```

This verifies that the FIFO maintains ordering even when reads and writes occur after the FIFO has wrapped around.

---

### Test 6 — Second Reset

The FIFO is reset again and checked:

```text
empty = 1
```

This verifies that reset correctly clears the FIFO state.

---

# 📊 Verification Result

The testbench uses an error counter:

```verilog
integer errors;
```

If no errors occur:

```text
=================================
ALL TESTS PASSED
=================================
```

If errors occur:

```text
=================================
TEST FAILED
ERRORS = <number>
=================================
```

The simulation used for this project produced:

```text
ALL TESTS PASSED
```

---

# 📈 Waveform

The testbench generates a VCD waveform using:

```verilog
$dumpfile("fifo.vcd");
$dumpvars(0, fifo_tb);
```

The waveform screenshot is included in the repository as:

```text
waveform.png
```

Important signals to observe in the waveform include:

```text
clk
reset
write_enable
read_enable
write_data
read_data
full
empty
count
write_ptr
read_ptr
```

These signals allow the FIFO's internal state and external behavior to be verified visually.

---

# 🛠️ Tools Used

* **Verilog**
* **Icarus Verilog**
* **EDA Playground**
* **Git**
* **GitHub**

---

# ▶️ Run the Simulation Locally

From the `04_FIFO` directory:

### Compile

```bash
iverilog -g2012 -Wall -o fifo_sim design.sv testbench.sv
```

### Run

```bash
vvp fifo_sim
```

Expected result:

```text
=================================
ALL TESTS PASSED
=================================
```

The simulation also generates:

```text
fifo.vcd
```

which can be used for waveform analysis.

---

# 📚 Concepts Learned

Through this project, the following RTL concepts were practiced:

* FIFO architecture
* Memory arrays
* Read/write pointers
* Circular pointer behavior
* Counters
* Full and empty flags
* Asynchronous reset
* Sequential RTL
* Non-blocking assignments
* `case` statements
* Simultaneous read/write operation
* Testbench tasks
* Self-checking testbenches
* `$monitor`
* `$display`
* `$dumpfile`
* `$dumpvars`
* Simulation debugging
* Waveform analysis

---

# 🎯 Learning Objective

This project is part of my **Verilog/SystemVerilog and RTL Design learning journey**.

The objective is to develop practical skills in:

```text
Digital Design
      ↓
Verilog/SystemVerilog
      ↓
RTL Design
      ↓
Testbench Development
      ↓
Simulation
      ↓
Waveform Analysis
      ↓
Verification
      ↓
VLSI / DFT
```

More RTL and VLSI-oriented projects will be added as I progress.

---

## 👨‍💻 Author

**Prakhar Chaplot**

B.Tech — Electronics & Communication Engineering

Interested in **RTL Design, VLSI, DFT, and Semiconductor Design**.

