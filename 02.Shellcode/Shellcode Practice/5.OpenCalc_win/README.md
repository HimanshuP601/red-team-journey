# OpenCalc_win — Windows Shellcode Practice

## 📌 Overview

**OpenCalc_win** is a Windows x64 shellcode practice project demonstrating
manual Windows API resolution and execution **without using an import table**.

The shellcode resolves the necessary Windows APIs at runtime and executes
`calc.exe` (the Windows calculator) as a proof-of-concept.

This project focuses on **low-level Windows internals, shellcode constraints,
and position-independent assembly code**, useful for offensive security research
and exploit development practice.

---

## 🎯 Objectives

This project helps you learn and practice:

- Writing **position-independent Windows shellcode**
- Dynamically resolving Windows APIs at runtime
- Traversing the **Process Environment Block (PEB)**
- Parsing PE export tables
- Executing Windows processes from shellcode

---

## ⚙️ Shellcode Behavior

The shellcode performs the following sequence:

1. Accesses the **TEB** to locate the **PEB**
2. Walks the loaded module list to find `kernel32.dll`
3. Finds the addresses of:
   - `LoadLibraryA`
   - `GetProcAddress`
4. Loads `kernel32.dll` or `ws2_32.dll` as needed
5. Resolves `WinExec`, `CreateProcessA`, or similar process execution APIs
6. Calls the resolved function to launch `calc.exe`
7. (Optional) Exits cleanly using `ExitProcess`

All API lookups are done manually at runtime.

---
## 🛠️ Building the Shellcode

To assemble and generate a flat binary:

```bash
nasm -f bin shellcode.asm -o shellcode.bin
```
The output shellcode.bin contains the raw shellcode bytes suitable for
loading and execution using a loader program.
