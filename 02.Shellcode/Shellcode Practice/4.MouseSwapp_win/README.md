# MouseSwapp_win — Windows Shellcode Practice

## 📌 Overview

**MouseSwapp_win** is a Windows x64 shellcode practice project that demonstrates
manual Windows API resolution and execution **without using an import table**.

The shellcode dynamically resolves and invokes the `SwapMouseButton` API to swap
the left and right mouse buttons at runtime.  
This project focuses on **low-level Windows internals, shellcode constraints,
and position-independent assembly code**.

---

## 🎯 Objective

The goal of this project is to practice:

- Writing **position-independent Windows shellcode**
- Manually resolving Windows APIs at runtime
- Traversing the **Process Environment Block (PEB)**
- Parsing PE export tables
- Executing user-mode Windows APIs without imports

---

## ⚙️ Shellcode Behavior

The shellcode performs the following actions:

1. Accesses the **TEB** to locate the **PEB**
2. Walks the loaded module list to find `kernel32.dll`
3. Resolves the address of:
   - `LoadLibraryA`
   - `GetProcAddress`
4. Loads `user32.dll`
5. Resolves the `SwapMouseButton` API
6. Calls `SwapMouseButton(TRUE)`
7. (Optional) Exits cleanly using `ExitProcess`

All API resolution is done **manually at runtime**.

## 🛠️ Building the Shellcode

Assemble the shellcode using **NASM**:

```bash
nasm -f bin shellcode.asm -o shellcode.bin
```
The resulting binary contains raw shellcode bytes suitable for execution via
a loader or injector.

