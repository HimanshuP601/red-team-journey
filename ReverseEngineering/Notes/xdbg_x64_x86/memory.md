# Memory Layout in Windows Executables (Observed via x64dbg)

Memory is divided into various sections essential for program execution and analysis.

---

## Typical Memory Sections

| Section          | Description                                        | Practical Tips / Notes                         |
|------------------|--------------------------------------------------|-----------------------------------------------|
| `.text`          | Contains executable code                          | Usually read-only, but patchable for modding |
| `.data`          | Initialized global/static variables               | Watch here for important config or state     |
| `.bss`           | Uninitialized globals, zero-filled on load       | Often holds flags or counters                  |
| Heap             | Dynamic memory allocated at runtime               | Use heap viewers or watch allocations         |
| Stack            | Stores local vars, return addresses, frames       | Critical for call stack tracing                |
| Mapped Files     | DLLs and shared libraries mapped into memory      | Helpful for hooking API calls or patching     |
| Reserved         | OS or program reserved address space              | Not usable until committed                      |

---

## How to view in x64dbg

- Use **Memory Map (Ctrl+M)** to see sections with permissions and size.
- Right-click to dump or protect memory regions.
- Watch for RWX permissions — often suspicious or patch targets.

---

## Heap and Stack Details

- **Heap**:
  - Created with APIs like `HeapAlloc`, `malloc`, `new`.
  - Can grow/shrink dynamically; analyze with heap viewers/plugins.
- **Stack**:
  - Grows downward.
  - Each function call pushes a new frame with return address, saved registers, and locals.
  - Watch the `RSP` register to track current stack pointer.

---

## Practical usage

- Modify `.text` for patching functions or bypassing checks.
- Monitor `.data` or heap for runtime variables or flags.
- Use stack inspection to find function arguments or saved states.

---

# Further reading

- Windows PE format internals
- Memory management internals (VirtualAlloc, etc.)
- Heap exploitation techniques
