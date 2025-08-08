# 🧠 Function Stack Layout: 32-bit vs 64-bit (Linux)

A reference guide for understanding how function arguments, return addresses, and local variables are managed in memory for:

- ✅ 32-bit (x86 / IA-32 ABI using cdecl)
- ✅ 64-bit (x86_64 / System V AMD64 ABI)

---

## 📌 Argument Passing Overview

| Feature               | 32-bit (x86)            | 64-bit (x86_64 System V)     |
|-----------------------|-------------------------|-------------------------------|
| Argument Passing      | Stack only              | Registers (1–6), then stack   |
| Used Registers        | Mostly stack + EAX/RAX  | RDI, RSI, RDX, RCX, R8, R9    |
| Stack Alignment       | Typically 4 bytes       | 16-byte aligned               |
| Return Value          | EAX                     | RAX                           |
| Cleanup Responsibility| Caller (cdecl)          | Caller (System V)             |
| Stack Growth Direction| Downward                | Downward                      |

---

## 🔢 Register-based Argument Passing (64-bit Only)

| Argument | Register |
|----------|----------|
| 1st      | RDI      |
| 2nd      | RSI      |
| 3rd      | RDX      |
| 4th      | RCX      |
| 5th      | R8       |
| 6th      | R9       |
| 7th+     | Stack    |

---

## 🧰 Function Prologue Examples

### 64-bit (System V AMD64 ABI)

```asm
myfunc:
    push   rbp
    mov    rbp, rsp
    sub    rsp, 0x20   ; Allocate space for locals
```

### 32-bit (cdecl ABI)

```asm
myfunc:
    push   ebp
    mov    ebp, esp
    sub    esp, 0x10   ; Allocate space for locals
```

---

## 🗂️ Stack Layout (Visual Comparison)

### 64-bit Example Function

```c
int myfunc(int a1, int a2, ..., int a9);
```

**Stack Layout (after function prologue):**

```
  Address        | Content              | Notes
  -------------- | ---------------------|-------------------------
  rbp + 0x20     | Argument 9 (a9)      | Passed via stack
  rbp + 0x18     | Argument 8 (a8)      | Passed via stack
  rbp + 0x10     | Argument 7 (a7)      | Passed via stack
  rbp + 0x08     | Return Address       | Pushed by CALL
  rbp + 0x00     | Old RBP              | Pushed by push rbp
  rbp - 0x08     | Local Variable 1     |
  rbp - 0x10     | Local Variable 2     |
```

---

### 32-bit Example Function

```c
int myfunc(int a1, int a2, int a3);
```

**Stack Layout (after function prologue):**

```
  Address        | Content              | Notes
  -------------- | ---------------------|-------------------------
  ebp + 0x10     | Argument 3 (a3)      | Passed via stack
  ebp + 0x0C     | Argument 2 (a2)      | Passed via stack
  ebp + 0x08     | Argument 1 (a1)      | Passed via stack
  ebp + 0x04     | Return Address       | Pushed by CALL
  ebp + 0x00     | Old EBP              | Pushed by push ebp
  ebp - 0x04     | Local Variable 1     |
  ebp - 0x08     | Local Variable 2     |
```

---

## 🧪 Return Value Conventions

| ABI      | Register |
|----------|----------|
| 32-bit   | EAX      |
| 64-bit   | RAX      |

---

## ⚙️ GCC Compilation Tips

**Compile for 32-bit:**
```bash
gcc -m32 -fno-stack-protector -z execstack -no-pie -g -o prog32 prog.c
```

**Compile for 64-bit:**
```bash
gcc -fno-stack-protector -z execstack -no-pie -g -o prog64 prog.c
```

---

## 🔍 Tools for Exploration

- `gdb` — Debug and inspect stack (`info registers`, `x/20x $rsp`)
- `objdump -d -M intel` — Disassemble binaries
- `readelf -a <binary>` — Inspect ELF header and ABI info

---

## 📎 References

- [System V AMD64 ABI (PDF)](https://refspecs.linuxfoundation.org/elf/x86_64-abi-0.99.pdf)
- [cdecl Calling Convention](https://wiki.osdev.org/X86_Call_Conventions)
- [Stack Alignment (OSDev)](https://wiki.osdev.org/System_V_ABI)

---
