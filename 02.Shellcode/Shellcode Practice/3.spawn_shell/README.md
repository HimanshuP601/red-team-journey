# spawn_shell — Linux `/bin/sh` Shellcode Practice

## 📌 Overview

**spawn_shell** is a Linux shellcode practice project that demonstrates
how to spawn a `/bin/sh` shell using **position-independent assembly shellcode**.

The shellcode directly invokes the `execve` system call to execute
`/bin/sh` without relying on libc or any imported functions.  
This is a classic and foundational shellcode payload used in exploit
development and low-level binary exploitation.

---

## 🎯 Objective

This project focuses on learning and practicing:

- Writing **position-independent Linux shellcode**
- Direct **syscall-based execution**
- Understanding Linux process execution internals
- Avoiding null bytes and bad characters
- ELF exploitation fundamentals

---

## ⚙️ Shellcode Behavior

The shellcode performs the following steps:

1. Prepares the `/bin/sh` string on the stack or in registers
2. Sets up arguments for the `execve` syscall:
   - `filename` → `/bin/sh`
   - `argv` → NULL or pointer array
   - `envp` → NULL
3. Invokes the `execve` system call
4. Replaces the current process with an interactive shell

No libc functions or external dependencies are used.

---
## 🛠️ Building the Shellcode

To assemble the shellcode using **NASM**:

```bash
nasm -f elf64 shellcode.asm -o shellcode.o
ld shellcode.o -o shellcode
```
To extract raw shellcode bytes:
```bash
objdump -d shellcode | grep '[0-9a-f]:' | \
cut -f2 | tr -d ' \n' | sed 's/../\\x&/g'
```

