# SystemVerilog + C DPI FIFO Communication

## Project Overview

This project implements a communication system where a **C program** sends the string **"Hello, World!"** as individual character packets to a **SystemVerilog DUT (Device Under Test)** using **DPI (Direct Programming Interface)**. The DUT includes an **asynchronous FIFO** that buffers the incoming packets and manages backpressure based on its status (full or empty). A SystemVerilog **testbench** controls the process.

---

## Components

### 1. **C Source Code (********`hello.c`********)**

- Sends "Hello, World!" one character per packet.
- Uses DPI functions to communicate with SystemVerilog.
- Implements backpressure control (stops sending if FIFO is full, requests packets if FIFO is empty).

### 2. **SystemVerilog FIFO (********`fifo.sv`********)**

- Asynchronous FIFO with:
  - **Write clock frequency:** 50 MHz (20 ns cycle)
  - **Read clock frequency:** 25 MHz (40 ns cycle)
  - **FIFO Depth:** 50 packets
  - **FIFO Width:** 8 bits (1 character per packet)
- Implements flow control using `full` and `empty` signals.

### 3. **Testbench (********`testbench.sv`********)**

- Generates clock signals for producer (write) and consumer (read).
- Interfaces with the C DPI functions.
- Controls packet transmission and monitors FIFO status.
- Reads and prints received packets.

---

## How It Works

1. The testbench initializes the FIFO and clocks.
2. The C program starts sending characters of "Hello, World!" as packets.
3. If the FIFO is **not full**, packets are written.
4. If the FIFO is **full**, packet transmission halts until space is available.
5. If the FIFO is **not empty**, packets are read.
6. If the FIFO is **empty**, the testbench signals the C program to send more packets.
7. The received characters are printed in order.

---

## Handling Backpressure and Flow Control

- The **FIFO full** signal prevents further packet transmission from the C program until space becomes available.
- The **FIFO empty** signal triggers the C program to send more packets when data is needed.
- This ensures that the FIFO does not overflow or underflow, maintaining a smooth and controlled data flow between producer and consumer.

---

## Compilation & Simulation

### **1. Compile the C Code:**

```sh
gcc -shared -fPIC -o hello.so hello.c
```

### **2. Compile and Simulate in QuestaSim:**

```sh
vlog fifo.sv testbench.sv
vsim -c -sv_lib ./hello -do "run -all" testbench
```

---

## Notes

- The FIFO implements **asynchronous communication** between different clock domains.
- **Backpressure control** ensures proper data flow without loss or overflow.
- FIFO depth of **50** is chosen to handle data bursts while maintaining efficiency.

---

## Future Improvements

- Add error handling for packet loss.
- Implement a variable-length packet system.
- Improve testbench for automated verification.

---

## Author

**Manvendra **

---

Happy coding! ??


