# 🧮 Classroom Grades Sorter (x86 Assembly)

Welcome to the **Classroom Grades Sorter**, a simple educational project built entirely in **x86 Assembly**. This tool allows sorting a set of student grades using the **Bubble Sort** algorithm, showcasing classic low-level programming and direct hardware interfacing.

## 🚀 Features
- Accepts a list of student grades
- Sorts them using the Bubble Sort algorithm
- Displays the sorted results
- Two versions:
  - 💻 **EMU8086** version (PC console-based)
  - 📟 **MTS-86C Kit** version (hardware: keypad + LCD)

---

## 🛠️ Assembly Concepts & Techniques

This project serves as a practical example of several fundamental x86 assembly principles:

- 🧠 **Bubble Sort**: One of the simplest sorting algorithms, implemented using nested loops and memory comparisons.
- 🎯 **DOS Buffered Input**: In the EMU8086 version, input is handled using DOS interrupt `INT 21h` with function `0Ah` (buffered keyboard input).
- 🔧 **Direct Memory Access**:
  - In the MTS-86C version, keypad and LCD are interfaced using predefined memory-mapped I/O addresses.
  - Input is read using custom subroutines that read the keypad.
  - Output is written directly to an LCD using dedicated output subroutines.

---

## 💻 EMU8086 Version

This version is built for use with the [EMU8086 Emulator](https://emu8086-microprocessor-emulator.en.softonic.com/), a Windows-based 8086 microprocessor simulator. It runs in a console window and interacts through keyboard and screen using DOS interrupts.

### ✅ How to Run:
1. Open the project in EMU8086.
2. Compile and run.
3. Enter grades via keyboard.
4. View the sorted results.

---

## 🧰 MTS-86C Kit Version

This version is designed for the **MTS-86C educational trainer kit**, which includes:
- A matrix keypad for input.
- An LCD display for output.

This version communicates directly with I/O hardware using:
- Predefined **input/output ports** (e.g., `IN` and `OUT` instructions).
- Subroutines for:
  - Reading a key from the keypad.
  - Writing a character to a specific LCD address.
  - Delays and cursor control.

The focus is on real hardware interaction and teaching embedded assembly basics.


