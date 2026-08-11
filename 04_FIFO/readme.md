

# 04_FIFO — Synchronous FIFO

A **First-In First-Out (FIFO)** buffer implemented in SystemVerilog and verified using a dedicated testbench.

FIFO is commonly used for temporary data storage and buffering between different parts of a digital system.

### FIFO Concept

```text
                 WRITE
                   │
                   ▼
              ┌─────────┐
              │         │
din ─────────►│  FIFO   │─────────► dout
              │         │
              └─────────┘
                   ▲
                   │
                  READ
```

The first data written into the FIFO is the first data read out.

```text
Write:  10 → 20 → 30

Read:   10 → 20 → 30
```

---

## 🔧 FIFO Features

The implementation includes:

* Parameterized data width
* Parameterized FIFO depth
* Write enable (`wr_en`)
* Read enable (`rd_en`)
* Input data (`din`)
* Output data (`dout`)
* Write pointer (`wr_ptr`)
* Read pointer (`rd_ptr`)
* Data counter (`count`)
* Full flag (`full`)
* Empty flag (`empty`)
* Synchronous read/write operation
* Asynchronous reset
* SystemVerilog RTL implementation
* Dedicated verification testbench
* Waveform generated from simulation

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

The FIFO uses:

* Memory array for data storage
* Write pointer to select the write location
* Read pointer to select the read location
* Counter to track the number of stored elements
* `full` flag to prevent writing when the FIFO is full
* `empty` flag to prevent reading when the FIFO is empty

### `testbench.sv`

The testbench:

* Generates the clock
* Applies reset
* Performs write operations
* Performs read operations
* Checks FIFO status
* Verifies FIFO behavior
* Generates simulation waveforms
* Reports test results

### `waveform.png`

Simulation waveform showing the behavior of the FIFO signals during verification.

---

## 🧠 FIFO Operation

### Write Operation

When:

```text
wr_en = 1
empty/full conditions allow writing
```

data is stored in FIFO memory:

```text
din → memory[wr_ptr]
```

Then:

```text
wr_ptr  → increments
count   → increments
```

If the FIFO becomes full:

```text
full = 1
```

---

### Read Operation

When:

```text
rd_en = 1
empty condition allows reading
```

data is read from:

```text
memory[rd_ptr] → dout
```

Then:

```text
rd_ptr  → increments
count   → decrements
```

If the FIFO becomes empty:

```text
empty = 1
```

---

## 🚦 FIFO Status

The important status signals are:

| Signal      | Meaning                             |
| ----------- | ----------------------------------- |
| `full = 1`  | FIFO cannot accept another write    |
| `empty = 1` | FIFO has no data available to read  |
| `count`     | Number of elements currently stored |
| `wr_ptr`    | Current write location              |
| `rd_ptr`    | Current read location               |

For an empty FIFO:

```text
count = 0
empty = 1
```

For a full FIFO:

```text
count = DEPTH
full = 1
```

---

## 🧪 Verification

The FIFO was compiled and simulated using **Icarus Verilog**.

### Compile

```bash
iverilog -g2012 -Wall -o fifo_sim design.sv testbench.sv
```

### Run simulation

```bash
vvp fifo_sim
```

The testbench verifies FIFO operations and reports:

```text
ALL TESTS PASSED
```

The simulation waveform was also captured and included in this project as:

```text
waveform.png
```

---

## 🛠️ Tools Used

* Verilog/SystemVerilog
* Icarus Verilog
* EDA Playground
* Git
* GitHub

---

## 📈 Learning Progression

The projects in this repository are being developed progressively:

```text
Basic Logic Gates
       ↓
Combinational Logic
       ↓
Sequential Logic
       ↓
FSM Design
       ↓
FIFO
       ↓
More RTL Design
       ↓
Verification
       ↓
VLSI / DFT-Oriented Projects
```

Each project includes RTL implementation and simulation/verification wherever applicable.

---

## 🎯 Objective

This repository is part of my hands-on learning journey toward **RTL Design, Verification, VLSI, and DFT**.

The focus is on building practical understanding through:

* RTL coding
* Testbench development
* Simulation
* Debugging
* Waveform analysis
* Git/GitHub project management

More digital-design and VLSI projects will be added progressively.
