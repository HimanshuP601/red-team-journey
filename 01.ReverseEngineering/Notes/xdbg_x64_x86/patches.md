# Patching Code in x64dbg — Techniques and Tips

Patching means modifying program code or data at runtime or on disk. It’s a common step in reverse engineering to bypass checks or alter behavior.

---

## Common Patch Types

- **NOPing instructions**
  - Replace unwanted instructions with `NOP` (no operation, `0x90`) to skip code.
- **Changing jumps**
  - Flip conditional jumps (`JE` ↔ `JNE`) to change logic.
- **Replacing immediate values**
  - Modify constants used in comparisons or calculations.
- **Inserting jumps**
  - Inject `JMP` instructions to redirect execution flow.

---

## How to Patch in x64dbg

1. Pause program at target code.
2. Right-click instruction → **Assemble** to modify opcode or instruction.
3. Use **Binary Editor** or **Memory Map** for direct hex editing.
4. Test patched code live, then save modified executable if desired.

---

## Saving Patched Executables

- Use **Dump Module** → save patched memory region as new file.
- Verify patched binary works outside debugger.

---


