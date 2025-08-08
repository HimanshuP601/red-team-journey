# Registers in x64dbg — Deep Dive

Registers are the CPU’s working variables and play a critical role in reverse engineering and patching. Understanding their purpose, behavior, and common usage patterns accelerates analysis.

---

## General Purpose Registers (GPRs)

These are your main data registers, used for arithmetic, pointer calculations, and passing parameters.

| Register  | Usage / Convention                              | Notes and Common Use                      |
| --------- | ---------------------------------------------- | ---------------------------------------- |
| **RAX**   | Accumulator — often stores function return values | Result of many instructions; `EAX` lower 32 bits |
| **RBX**   | Base register, often callee-saved               | Rarely used as pointer by convention    |
| **RCX**   | 1st argument in Windows x64 calling convention | Loop counters, shifts, string ops        |
| **RDX**   | 2nd argument in calling convention              | Also used for division/remainder         |
| **RSI**   | Source index — often source pointer in mem ops  | String operations (`movs`, `stos`)        |
| **RDI**   | Destination index — destination pointer          | String and array operations               |
| **RBP**   | Base pointer — frame pointer                      | Tracks stack frame base for local vars    |
| **RSP**   | Stack pointer — top of the stack                  | Critical for function call/return         |
| **R8-R15**| Additional argument registers (Windows x64)     | Used for passing extra parameters         |

---

### How registers behave during function calls

- **Windows x64 calling convention** passes first 4 integer/pointer args in `RCX`, `RDX`, `R8`, `R9`.
- Return values come back in `RAX`.
- Callee saves: `RBX`, `RBP`, `RDI`, `RSI`, `R12-R15` must be preserved by called function.
- Caller saves others (`RAX`, `RCX`, `RDX`, `R8`, `R9`, `R10`, `R11`).

Knowing this helps you trace input parameters and return values inside functions during debugging.

---

## Segment Registers

Used mainly for memory segmentation and protected mode operation — less relevant for most modern reverse engineering but occasionally critical in very low-level or embedded code.

- **CS** (Code Segment) points to code segment descriptor.
- **DS**, **SS**, **ES**, **FS**, **GS** — data and stack segment registers.
- `FS` and `GS` are often used by OS for thread-local storage (TLS).

---

## Instruction Pointer (`RIP`)

- Points to the next instruction to execute.
- Watching `RIP` is key to understanding control flow, jumps, and function calls.
- Modifying `RIP` (via jump, call, ret, or debugger) changes program execution.

---

## Flags Register (RFLAGS)

Contains bits indicating CPU state after operations — essential for conditional jumps and logic.

Important flags:

| Flag | Meaning                     | Usage                                   |
|-------|-----------------------------|-----------------------------------------|
| CF    | Carry Flag                  | Arithmetic carry/borrow                  |
| ZF    | Zero Flag                   | Set if result is zero                    |
| SF    | Sign Flag                   | Sign of result (negative/positive)      |
| OF    | Overflow Flag               | Signed overflow detection                |
| PF    | Parity Flag                 | Parity of lower byte                     |

Flags affect instructions like `JZ` (jump if zero), `JC` (jump if carry), etc., which are essential breakpoints in cracking logic.

---

## CPU Register Size Notation (x86-64)

| 64-bit (QWORD) | 32-bit (DWORD) | 16-bit (WORD) | 8-bit (BYTE)                 | Size              |
| -------------- | -------------- | ------------- | ---------------------------- | ----------------- |
| **RAX**        | **EAX**        | **AX**        | **AH** (high) / **AL** (low) | 8 bytes (64 bits) |
| **RBX**        | **EBX**        | **BX**        | **BH** / **BL**              | 8 bytes (64 bits) |
| **RCX**        | **ECX**        | **CX**        | **CH** / **CL**              | 8 bytes (64 bits) |
| **RDX**        | **EDX**        | **DX**        | **DH** / **DL**              | 8 bytes (64 bits) |
| **RSI**        | **ESI**        | **SI**        | **SIL**                      | 8 bytes (64 bits) |
| **RDI**        | **EDI**        | **DI**        | **DIL**                      | 8 bytes (64 bits) |
| **RBP**        | **EBP**        | **BP**        | **BPL**                      | 8 bytes (64 bits) |
| **RSP**        | **ESP**        | **SP**        | **SPL**                      | 8 bytes (64 bits) |
| **R8**         | **R8D**        | **R8W**       | **R8B**                      | 8/4/2/1 bytes     |
| **R9**         | **R9D**        | **R9W**       | **R9B**                      | 8/4/2/1 bytes     |
| ...            | ...            | ...           | ...                          | ...               |

> **Note:** For registers like `RBX`, `RCX`, `RDX`, etc., the size is always 64-bit for the full register (e.g., RBX), even though the table previously showed 4 or 2 bytes incorrectly. The 64-bit registers hold 8 bytes (64 bits). The 32-bit, 16-bit, and 8-bit parts are subsets of those registers.  

---

## Practical Tips:

- When stepping through code, watch how registers change to infer function logic.
- Use the **CPU** pane in x64dbg to see live register changes.
- Breakpoints on `CMP` or `TEST` instructions often depend on flag changes, so watch related registers.
- Changing register values on the fly can force code down different paths for testing.

---

# References

- [Microsoft x64 calling convention](https://learn.microsoft.com/en-us/cpp/build/x64-calling-convention)
- Intel Software Developer’s Manual (vol. 1, 2, 3)
