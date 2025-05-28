
# 🐧 Linux vs 🪟 Windows Shellcode

This section highlights the key differences between Linux and Windows shellcode, based on the article:  
[**Introduction to Windows Shellcode Development – Part 1**](https://securitycafe.ro/2015/10/30/introduction-to-windows-shellcode-development-part1/)

---

## 📊 Comparison Table

| Feature                      | Linux Shellcode                                | Windows Shellcode                                         |
|-----------------------------|--------------------------------------------------|------------------------------------------------------------|
| 🔧 System Call Mechanism    | Uses direct syscalls via `int 0x80` or `syscall` | Relies on Windows API functions (no direct syscalls)       |
| 📚 Dependencies              | Minimal – no DLLs required                      | Needs to load and parse DLLs (e.g., kernel32.dll)          |
| 📍 Function Resolution       | Syscall numbers are fixed and known             | Must locate functions dynamically (via PEB and export table) |
| 🧠 Complexity                | Simpler and more predictable                    | More complex due to address randomization and API lookup   |
| 🐚 Shell Execution           | Spawns `/bin/sh` using `execve()`               | Spawns `cmd.exe` using `WinExec()` or `CreateProcessA()`   |
| 🔢 Size                     | Small (15–40 bytes typical)                     | Larger due to API resolution logic                         |
| 🚫 Null Byte Handling        | Avoid nulls (`0x00`) due to string parsing      | Same, plus needs to avoid other bad chars (e.g., `\x0a`)   |
| 🏗️ Code Positioning         | Usually position-independent by default         | Must be fully position-independent                         |
| 🧪 Testing Tools             | GDB, strace, simple environments                | x64dbg, Immunity Debugger, more setup needed               |

---

## 🧩 Shellcode Execution Flow (Step-by-Step)

### 🐧 Linux Shellcode Steps

1. **Start at entry point**: Execution jumps directly to the shellcode.
2. **Syscall setup**: Place syscall number for `execve()` in the `eax` register.
3. **Arguments setup**:
   - Pointer to `"/bin/sh"` is set in `ebx`
   - `ecx` and `edx` are set to 0 for no arguments or environment
4. **Trigger syscall**: Call `int 0x80` (or `syscall` on x64).
5. **Shell spawns**: `/bin/sh` is executed.

```asm
; Classic Linux shellcode
xor eax, eax
push eax
push 0x68732f2f ; //sh
push 0x6e69622f ; /bin
mov ebx, esp
push eax
mov edx, esp
push ebx
mov ecx, esp
mov al, 0xb
int 0x80
```

---

### 🪟 Windows Shellcode Steps

1. **Get Current Thread’s PEB (Process Environment Block)**:
   - Accessed via the FS segment register on 32-bit (`fs:[0x30]`)
2. **Locate the Loaded Modules List**:
   - Traverse `PEB->Ldr->InMemoryOrderModuleList`
3. **Find `kernel32.dll` base address**:
   - Used for calling APIs like `WinExec`, `CreateProcessA`, etc.
4. **Parse the PE header** of `kernel32.dll`:
   - Navigate to Export Table
5. **Find function names** and get their **addresses**:
   - Compare against hashed function names or string comparisons.
6. **Call the function**:
   - For example: `WinExec("cmd.exe", SW_SHOW)`
7. **Clean up / Exit** (optional): Call `ExitProcess` or similar.

```asm
; Pseudo-steps for WinExec shellcode
1. locate_kernel32:
    - Traverse PEB to find base address
2. find_function:
    - Parse PE exports to find address of WinExec
3. call_winexec:
    - Call WinExec("cmd.exe")
```

---

## 🧠 Summary

- **Linux shellcode** is straightforward and depends on kernel syscalls.
- **Windows shellcode** is more involved:
  - It must dynamically locate required functions at runtime.
  - Heavily depends on OS internals like PEB and PE structures.

> 🔐 Windows shellcode must be more stealthy and resilient due to security features like ASLR, DEP, etc.

---

📌 For full reference:  
[👉 Introduction to Windows Shellcode – Part 1](https://securitycafe.ro/2015/10/30/introduction-to-windows-shellcode-development-part1/)
