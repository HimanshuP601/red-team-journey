# Code Caves in x64dbg — What They Are and How to Use Them

Code caves are unused or free areas of memory inside an executable where you can inject custom code without increasing the file size. They are essential for patching and extending program behavior without rewriting the entire binary.

---

## What is a Code Cave?

- A **code cave** is a contiguous block of unused bytes inside a program’s executable section (usually filled with `0x00` or `0x90` NOPs).
- These areas are safe to overwrite because they are not used by the original program logic.
- Common in PE files (.exe, .dll), often leftover space after compiler optimizations or alignment padding.

---

## Why Use Code Caves?

- Insert custom instructions to extend or alter program functionality.
- Avoid increasing file size or creating new sections.
- Hook functions or insert new logic without major restructuring.
- Perform runtime patches or hacks.

---

## How to Find Code Caves in x64dbg

1. Open **Memory Map** (`Ctrl+M`).
2. Look for executable sections (`.text`) with free or unused space.
3. Use **Search for unused bytes** feature:
   - Go to **Search** → **Find** → **Find byte sequence**.
   - Search for long runs of `0x00` or `0x90`.
4. Alternatively, use plugins/scripts to automate code cave detection.

---

## Injecting Code into a Code Cave

1. **Choose a suitable cave**  
   Must be large enough to hold your injected code.

2. **Write your custom assembly code**  
   Use the **Assemble** feature or external assembler to generate bytes.

3. **Patch original code to jump to your cave**  
   - Overwrite instructions at target with a jump (`JMP`) to cave address.
   - Usually a 5-byte relative jump (`E9 <offset>`).

4. **At end of cave, jump back to original flow**  
   Return to instruction immediately after the overwritten code.

---


