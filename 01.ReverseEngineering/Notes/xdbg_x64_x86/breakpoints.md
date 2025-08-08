# Breakpoints in x64dbg — Setting, Types, and Usage

Breakpoints allow you to pause execution at specific points, essential for dynamic analysis.

---

## Types of Breakpoints

1. **Software Breakpoints**
   - Insert a special instruction (`INT 3` / `0xCC`) at the target address.
   - When CPU executes this, debugger takes control.
   - Can be set on code, but modifying code can sometimes be detected by anti-debug.

2. **Hardware Breakpoints**
   - Use CPU debug registers to watch addresses without modifying code.
   - Can watch execution, memory reads/writes.
   - Limited number (usually 4).

3. **Memory Breakpoints (Memory Access)**
   - Watch for read, write, or execute access on a memory region.
   - Useful for tracking data changes or self-modifying code.

---

## Setting Breakpoints in x64dbg

- Right-click on instruction → **Toggle breakpoint (F2)**
- Use breakpoint pane to manage all breakpoints
- Conditional breakpoints: pause only if condition is true (e.g., `eax == 5`)

---

## Conditional Breakpoints

- Add conditions to breakpoints for complex debugging
- Example: break only if a register or memory matches a value

---

## Breakpoint Hit Actions

- Break and show CPU state
- Run commands or scripts automatically (advanced debugging)
- Log messages without stopping (trace breakpoints)

---

## Best Practices

- Use hardware breakpoints for stealthy debugging
- Use conditional breakpoints to avoid noise
- Remove breakpoints carefully to restore original code

---

# References

- Intel Software Developer’s Manual (Debugging)
- x64dbg Wiki and tutorials
