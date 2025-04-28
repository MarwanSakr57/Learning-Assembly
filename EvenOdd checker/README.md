# 🕹️ Even or Odd Checker in Assembly (8086)

A simple even-or-odd number checker written in x86 Assembly for the **EMU8086** environment.  
It reads a multi-digit integer from the keyboard, determines whether it’s even or odd, and lets you retry or exit.

---

### 💡 Features
- Reads multi-digit numbers using BIOS keyboard interrupt (`INT 16h`).
- Parses and builds the integer via stack operations and register math.
- Checks parity by inspecting the least-significant bit (`AND 1`).
- Provides a retry/exit menu and handles invalid (non-digit) input.

---

### 🔧 Requirements:
- [emu8086](https://emu8086-microprocessor-emulator.en.softonic.com/) or any other x86 real-mode emulator.
- Windows or DOS-compatible system (or DOSBox for Linux/macOS users).

---

### ▶️ How to Run
1. Open **EMU8086**.  
2. Load `even_or_odd.asm`.  
3. Compile (Build) the program.  
4. Run it in the emulator window.  
5. Follow on-screen prompts to enter a number and view the result.

---
