# 🔍 x64dbg Practical Notes

These notes are based on real exploration and hands-on use of `x64dbg` — not theory. I use this tool for binary analysis, game modding, and patching executables during crackme practice and reversing challenges.

This isn't a basic overview — it’s what actually helps when stepping through and modifying binaries.

---

## 🧠 Core Concepts in Practice

### 🪛 Modifying Game Binaries / Crackmes

- **Find the target instruction**:
  - Use `Ctrl + G` to jump to a known address (from strings or disassembly).
  - Use the **Search > Current Module > String References** (`Ctrl + R`) to locate text like “Wrong Password”.
  - Backtrace from that string to the function that compares the input (e.g., `strcmp`, `strncmp`, or inline comparison).

- **Set breakpoints**:
  - `F2` — Software breakpoint
  - Use on key comparison points (right after the user input is read, or before conditionals like `JNZ`, `JE`, etc.)

- **Trace condition checks**:
  - Use `F7` (Step Into) and `F8` (Step Over) to trace control flow.
  - Watch for conditional jumps like `JE`, `JNE`, `JL`, etc. These usually decide "correct password" logic.
  - Modify jump instructions (`JNZ` → `JZ`) directly in the hex editor to flip logic.

- **Modify instructions (patching)**:
  - Right-click → Binary → Edit → Change the bytes.
  - After testing, save via `File → Patch file` or `Patch → Save patched file`.

---

## 🔬 What You Actually Use Often

| Feature | Use Case |
|--------|----------|
| **CPU tab** | Shows current instruction pointer (`EIP`/`RIP`) and surrounding assembly. Watch jumps, calls, and stack state. |
| **Stack tab** | Helps understand function call arguments and return addresses. Crucial during tracing. |
| **Log tab** | Output from modules, API calls, plugin messages. Check when breakpoints hit or external behavior is triggered. |
| **Memory Map (Ctrl+M)** | Locate readable/writable sections, code segments, and base addresses for patching or dumping memory. |
| **Breakpoints window** | Manage, enable/disable breakpoints — especially useful when tracing loops or nested conditions. |
| **Hex dump (Ctrl+D)** | View and edit memory at specific addresses. Useful when observing variable changes, patching constants, or changing string values. |

---

## 🧪 Typical Flow When Reversing a CrackMe

1. Load the binary in x64dbg
2. Set breakpoint on WinMain or program entry (`Ctrl + G → main`)
3. Use **string references** to locate verification checks (`"Wrong"`, `"Correct"`, etc.)
4. Follow cross-references to comparison logic
5. Set breakpoints before jumps
6. Modify `JNE`, `JE`, `CMP`, or `CALL` instructions as needed
7. Patch and save binary

---

## 🧷 Notes & Tricks

- Use **run till return (Ctrl + F9)** to skip large unknown functions
- Use **`Analyze > Analyze current module`** to make unknown code navigable
- Watch registers like `EAX`, `EBX` right after function calls — they often store results (`EAX == 0` → false return, etc.)
- If input is passed to `strcmp`, trace the actual user input in memory and compare it to the stored correct value
- Use the **docking system** to layout CPU, Stack, and Memory Map for a more intuitive view

---

## 📂 My Related Notes

- [Registers and CPU Internals](./registers.md)
- [Memory Layout and Stack](./memory_layout.md)
- [Breakpoint Strategy](./breakpoints.md)
- [Control Flow and Patching](./control_flow_tracing.md)

---

## ⚙️ Plugins Worth Exploring

- **Scylla**: Dump memory and fix IAT
- **Labeless**: Integration with IDA
- **xAnalyzer**: Auto-analysis of functions and patterns

---
