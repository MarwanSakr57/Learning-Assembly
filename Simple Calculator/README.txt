# 🧮 Simple Calculator in Assembly (8086)

This is a simple calculator written in x86 Assembly using the **emu8086** environment.  
It supports the following operations:

- Addition (+)
- Subtraction (-)
- Multiplication (×)
- Division (÷)

### 💡 Features:
- Takes two multi-digit numbers as input from the keyboard.
- Displays the result using interrupt-based I/O.
- Uses BIOS and DOS interrupts (INT 21h, INT 16h) to handle user interaction.
- Implements number parsing and viewing using only registers and stack logic.

### 🔧 Requirements:
- [emu8086](http://www.emu8086.com/) or any other x86 real-mode emulator.
- Windows or DOS-compatible system (or DOSBox for Linux/macOS users).

### ▶️ How to Run:
1. Open `emu8086`.
2. Load the `.asm` file.
3. Compile and run it inside the emulator.

### 🧠 What I Learned:
- Handling input with `INT 16h` and output with `INT 21h`.
- Using stack operations to reverse and process multi-digit numbers.
- Converting ASCII input to integers and vice versa.
- Writing clean, label-based structure in Assembly.


