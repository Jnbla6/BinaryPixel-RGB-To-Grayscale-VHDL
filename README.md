# RTL BinaryPixel Grayscale Processor 🚀

<img width="764" height="409" alt="image" src="https://github.com/user-attachments/assets/d14b738d-2bec-40e5-a217-2dd458163a41" />


A high-performance, low-level hardware architecture implemented in VHDL that transforms a 24-bit True Color RGB pixel stream into an optimized 8-bit grayscale intensity. 

Instead of using heavy, resource-intensive division components, this processor operates directly at the silicon layer. It achieves maximum efficiency by combining zero-overhead hardware wire-shifting with a custom-built 8-bit Ripple Carry Adder matrix.

---

## 🛠️ System Architecture & Low-Level Mechanics

The design breaks down the image processing pipeline into raw digital logic across two main functional blocks, coordinated by a structural top-level wrapper:

```text
  [24-bit RGB Input] -> (8-bit Red, 8-bit Green, 8-bit Blue)
                               |
                               v
                     +-------------------+
                     |   shifter.vhd     |  <- Zero-gate wire shifting
                     +-------------------+
                       /       |       \
                    R/4       G/2       B/4
                     \         |         /
                      v        |        /
                +-----------+  |       /
                | gryadder1 |  |      /   <- Adds (R/4) + (B/4)
                +-----------+  |     /
                      \        |    /
                    (R/4+B/4)  |   /
                        \      |  /
                         v     v v
                    +-----------+
                    | gryadder2 |         <- Adds Intermediate Sum + (G/2)
                    +-----------+
                          |
                          v
                 [8-bit Gray Output]
```

### 1. The Bit-Shifter (`shifter.vhd`)
Takes the 24-bit stream and applies physical logical right shifts to perform hardware-optimized division. By rerouting the copper traces, we approximate the human eye luminosity conversion formula without consuming a single logic gate:

$$\text{Grayscale} \approx \frac{R}{4} + \frac{G}{2} + \frac{B}{4}$$

* **Red (`Rrhf`)**: Shifted right by 2 bits (÷ 4)
* **Green (`Grhf`)**: Shifted right by 1 bit (÷ 2)
* **Blue (`Brhf`)**: Shifted right by 2 bits (÷ 4)

### 2. The Logic Gate Adder (`gryadder.vhd`)
A synthesizable loop that unrolls into an 8-bit Ripple Carry Adder array. It combines the shifted color channels bit-by-bit using pure boolean equations executed at the gate level:
* $$Sum = A \oplus B \oplus C_{in}$$
* $$C_{out} = (A \cdot B) + (C_{in} \cdot (A \oplus B))$$

---

## 📊 Verification & Waveform Simulation

The design was verified using **GHDL** and analyzed inside **VS Code** using the **VaporView** / **GTKWave** waveform viewer.

### Simulation Test Case (The Teal Pixel)
* **Input Pixel (24-bit RGB)**: `00110011 11001100 11111111` (Red: 51, Green: 204, Blue: 255)
* **Hardware Shifter Execution**: 
    * R/4 = 12 (`00001100`)
    * G/2 = 102 (`01100110`)
    * B/4 = 63 (`00111111`)
* **Adder Pipeline Aggregation**: 12 + 102 + 63 = 177
* **Final Output (8-bit Grayscale)**: `10101001` (Decimal 177)

---

## 🚀 How to Run the Toolchain

### 1. Requirements
* **GHDL** (VHDL Simulator)
* **Python 3** (with `Pillow` library for image processing)

### 2. Automated Python Testbench Pipeline
The project features a full Python orchestration script (`run_system.py`) that acts as a bridge between real image files and the GHDL compiler. It extracts image pixels into binary data text, runs the GHDL simulation, and reassembles the hardware text results back into a viewable PNG photo.

1. Drop your target image into the directory and name it `input.png`.
2. Execute the master script:
   ```bash
   python run_system.py
   ```
3. Open `output_gray.png` to view your final image processed natively by the VHDL gate architecture.

### 3. Manual GHDL Compilation
To compile and generate the waveform file manually via the command line, run:
```bash
ghdl -a shifter.vhd greyadder.vhd toplevel_rgbtogrey.vhd gry_tb.vhd && ghdl -e gry_tb && ghdl -r gry_tb --vcd=wave.vcd
```
