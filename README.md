# 1–12 Counter (Verilog)

## Overview

This project implements a **1–12 synchronous counter** in Verilog.
The counter increments from **1 to 12** and then wraps back to **1**.

Instead of designing the counter directly, the design **instantiates a provided 4-bit binary counter (`count4`)** and controls it using **enable and load signals**.

This project is useful for learning:

* RTL design in Verilog
* Counter design using reusable modules
* Control signal generation (`enable`, `load`)
* Simulation using **Icarus Verilog** and **GTKWave**

---

## Counter Behavior

Sequence of the counter:

```
1 → 2 → 3 → 4 → 5 → 6 → 7 → 8 → 9 → 10 → 11 → 12 → 1 → ...
```

### Rules

* **Reset (synchronous, active high)** → counter loads **1**
* **Enable = 1** → counter runs
* **Enable = 0** → counter holds its value
* When **count = 12**, the next clock cycle **loads 1**

---

## Module Interface

### Top Module

| Signal     | Direction | Width | Description                       |
| ---------- | --------- | ----- | --------------------------------- |
| `clk`      | Input     | 1     | Clock input                       |
| `reset`    | Input     | 1     | Synchronous reset (loads 1)       |
| `enable`   | Input     | 1     | Enables counting                  |
| `Q`        | Output    | 4     | Current counter value             |
| `c_enable` | Output    | 1     | Enable signal to internal counter |
| `c_load`   | Output    | 1     | Load signal to internal counter   |
| `c_d`      | Output    | 4     | Data input to internal counter    |

---

## Internal Counter Module

The design uses the provided **4-bit counter** module.

```verilog
module count4(
    input clk,
    input enable,
    input load,
    input [3:0] d,
    output reg [3:0] Q
);
```

### Priority

```
load > enable
```

| load | enable | Action            |
| ---- | ------ | ----------------- |
| 1    | X      | Load value `d`    |
| 0    | 1      | Increment counter |
| 0    | 0      | Hold value        |

---

## Implementation

```verilog
module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q,
    output c_enable,
    output c_load,
    output [3:0] c_d
);

assign c_d = 4'd1;

// Load when reset or when count reaches 12
assign c_load = reset | (enable & (Q == 4'd12));

// Enable counting normally
assign c_enable = enable & (Q != 4'd12);

count4 counter_inst (
    .clk(clk),
    .enable(c_enable),
    .load(c_load),
    .d(c_d),
    .Q(Q)
);

endmodule
```

---

## Simulation

### Tools Required

* **Icarus Verilog**
* **GTKWave**

Install (Ubuntu):

```
sudo apt install iverilog gtkwave
```

---

## Run Simulation

Compile the design and testbench:

```
iverilog -o sim.out top_module.v tb_top_module.v
```

Run simulation:

```
vvp sim.out
```

View waveform:

```
gtkwave wave.vcd
```

---

## Example Output

```
Time    Q
-------------
0       1
1       2
2       3
...
10      11
11      12
12      1
```

---

## Project Structure

```
1-12-counter/
│
├── top_module.v
├── count4.v
├── tb_top_module.v
├── wave.vcd
└── README.md
```

---

## Concepts Used

* RTL design
* Synchronous counters
* Parallel load counters
* Verilog module instantiation
* Digital design verification

---

## Author

**Arkaprava Paul**
