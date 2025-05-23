# 🔍 Notes: Minimal x86_64 Assembly "Hello World" with Shellcode Considerations

---

## 📌 Objective

- Understand basic syscall-based I/O in x86_64 assembly on Linux.
- Compare a **simple version** vs an **optimized, shellcode-safe version**.
- Analyze disassembled binary to study the presence of null bytes.
- Learn how to avoid null bytes when writing shellcode (useful in CTFs, exploit dev).

---

## 1️⃣ Basic Version (Memory-Based String)

```nasm
section .data
    txt db 'Hello Himanshu!', 0xA
    len equ $ - txt

section .text
    global _start
_start:
    mov rax, 1          ; syscall number for write
    mov rdi, 1          ; file descriptor (stdout)
    lea rsi, [txt]      ; address of string
    mov rdx, len        ; length of string
    syscall             ; make syscall

    mov rax, 60         ; syscall number for exit
    mov rdi, 1          ; exit code
    syscall             ; make syscall
````

### 🧠 Disassembly Output

```text
40100a: 48 8d 34 25 00 20 40 00 lea rsi,[0x402000]
```

➡️ Contains `00` (null bytes) — **bad for shellcode** (many injection scenarios break here).

---

## 2️⃣ Optimized Version (Stack-Based String)

```nasm
section .text
    global _start
_start:
    xor rax, rax
    push rax                        ; null terminator
    xor rbx, rbx
    mov rbx, 0x217568736e616d      ; "namhsu!"
    push rbx
    xor rbx, rbx
    mov rbx, 0x6948206f6c6c6548     ; "Hello Hi"
    push rbx

    mov al, 1                       ; syscall write
    mov dil, 1                      ; stdout
    mov rsi, rsp                    ; pointer to string
    mov dl, 15                      ; string length
    syscall

    mov al, 60                      ; syscall exit
    mov dil, 0                      ; exit code
    syscall
```

### ✅ Disassembly Shows No Null Bytes

```text
401007: 48 bb 6d 61 6e 73 68 75 21 00  movabs rbx,0x217568736e616d
401015: 48 bb 48 65 6c 6c 6f 20 48 69  movabs rbx,0x6948206f6c6c6548
```

✔️ All instructions and data are **non-null**, making the code **shellcode-safe**.

---

## 🔄 Register Usage Overview

| Register | Used For               | Description                 |
| -------- | ---------------------- | --------------------------- |
| `rax`    | syscall number         | `1 = write`, `60 = exit`    |
| `rdi`    | arg 1: fd or exit code | `1 = stdout`, `0 = exit(0)` |
| `rsi`    | arg 2: buffer pointer  | pointer to string           |
| `rdx`    | arg 3: buffer length   | string length               |
| `rsp`    | stack pointer          | used to hold our string     |

---

## 📉 Visual: Stack Layout

```
Stack Top (rsp) ↓
+---------------------------+
| 0x6948206f6c6c6548        | <- "Hello Hi"
+---------------------------+
| 0x217568736e616d00        | <- "namhsu!\0"
+---------------------------+
| 0x0000000000000000        | <- Null terminator
+---------------------------+
```

---

## ❗ Shellcode vs Normal Binary

| Criteria           | Basic (Memory) | Optimized (Stack) |
| ------------------ | -------------- | ----------------- |
| Uses `.data`?      | ✅ Yes          | ❌ No              |
| Null bytes present | ❌ Yes          | ✅ No              |
| Shellcode-safe     | ❌ No           | ✅ Yes             |
| Hardcoded address  | ✅ Yes          | ❌ No              |

---

## 🛠️ Compilation & Linking

```bash
nasm -f elf64 hello.asm -o hello.o
ld hello.o -o hello

nasm -f elf64 hello_opt.asm -o hello_opt.o
ld hello_opt.o -o hello_opt
```

---

## 📚 Tips for Shellcoding

* ❌ Avoid static `.data` sections.
* ✅ Build strings on the stack using `push`.
* ❌ Avoid `mov rsi, [addr]` with hardcoded pointers — may embed nulls.
* ✅ Use `xor reg, reg` to zero registers efficiently.
* ✅ Check objdump for null bytes: `objdump -d binaryname | grep 00`

---

## 📖 References

* [x86\_64 Linux syscall table](https://filippo.io/linux-syscall-table/)
* [Exploit Writing Tutorial](https://www.exploit-db.com/docs/english/28476-linux-x86-assembly-shellcode.pdf)
* [Shellcode Design Principles](https://reverseengineering.stackexchange.com/questions/4241/how-to-avoid-null-bytes-in-x86-64-assembly-shellcode)
* [NASM Documentation](https://nasm.us/doc/)

---

