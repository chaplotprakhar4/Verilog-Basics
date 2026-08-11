# Verilog-Basics

A hands-on **Verilog/SystemVerilog RTL design and verification repository** documenting my journey from digital logic fundamentals to more advanced RTL and VLSI-oriented projects.

The focus of this repository is **learning by implementation** — writing RTL, creating testbenches, simulating designs, analyzing waveforms, debugging errors, and maintaining projects using Git/GitHub.

---

## 📚 Projects

| #  | Project                                                                         | Concepts Covered                                                     | Status      |
| -- | ------------------------------------------------------------------------------- | -------------------------------------------------------------------- | ----------- |
| 01 | [AND Gate](./01_AND_Gate)                                                       | Basic combinational logic, RTL, testbench                            | ✅ Completed |
| 02 | [OR Gate](./02_OR_Gate)                                                         | Combinational logic, RTL, simulation                                 | ✅ Completed |
| 03 | [Traffic Light Pedestrian Controller](./03_Traffic_Light_Pedestrian_Controller) | FSM, sequential logic, counters, pedestrian request handling         | ✅ Completed |
| 04 | [FIFO](./04_FIFO)                                                               | Memory, read/write pointers, counter, full/empty flags, verification | ✅ Completed |

More projects will be added as I progress.

---

## 🛠️ Tools & Technologies

* Verilog
* SystemVerilog
* Icarus Verilog
* EDA Playground
* Git
* GitHub
* Linux / Unix command line

---

## 🧠 Concepts Covered

### Digital Logic

* AND, OR, NOT
* NAND, NOR
* XOR, XNOR
* Combinational logic
* Sequential logic

### RTL Design

* Modules and ports
* Parameters
* Registers and memories
* Blocking and non-blocking assignments
* `always` / `always_ff`
* Counters
* Multiplexers
* Finite State Machines
* FIFO architecture

### Verification

* Testbench development
* Clock and reset generation
* Stimulus generation
* Self-checking testbenches
* Simulation
* Waveform analysis
* Debugging

---

## 🔬 Project Workflow

Each project follows a practical RTL development flow:

```text
Problem Definition
       ↓
RTL Design
       ↓
Testbench Development
       ↓
Compilation
       ↓
Simulation
       ↓
Waveform Analysis
       ↓
Debugging
       ↓
Git Commit
       ↓
GitHub
```

---

## ▶️ Simulation

For projects using Icarus Verilog:

### Compile

```bash
iverilog -g2012 -Wall -o simulation design.sv testbench.sv
```

### Run

```bash
vvp simulation
```

### Waveform

Projects may include a waveform generated during simulation or through EDA Playground.

---

## 📁 Repository Structure

```text
Verilog-Basics/
│
├── 01_AND_Gate/
│   ├── design.sv
│   └── testbench.sv
│
├── 02_OR_Gate/
│   ├── design.sv
│   └── testbench.sv
│
├── 03_Traffic_Light_Pedestrian_Controller/
│   ├── design.sv
│   ├── testbench.sv
│   └── waveform.jpeg
│
├── 04_FIFO/
│   ├── design.sv
│   ├── testbench.sv
│   └── waveform.png
│
└── README.md
```

---

## 📈 Learning Roadmap

```text
Digital Logic
      ↓
Verilog Fundamentals
      ↓
Combinational RTL
      ↓
Sequential RTL
      ↓
FSM Design
      ↓
Counters & Memories
      ↓
FIFO
      ↓
Advanced RTL
      ↓
Verification
      ↓
STA
      ↓
DFT / VLSI
```

---

## 🎯 Goal

The goal of this repository is to build strong practical skills in:

* RTL Design
* Verilog/SystemVerilog
* Digital Design
* Functional Verification
* Timing Concepts
* VLSI Design
* DFT Fundamentals

I am continuously adding projects and improving the existing implementations as I learn new concepts.

---

## 👨‍💻 Author

**Prakhar Chaplot**

B.Tech — Electronics & Communication Engineering

Interested in **RTL Design, VLSI, DFT, and Semiconductor Design**.

---

⭐ This repository is a record of my continuous learning and hands-on practice in digital design and VLSI.
