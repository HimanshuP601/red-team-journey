# Shellcode Collection & Notes

Welcome to the **shellcode** directory! This folder contains my collection of Linux x86_64 shellcode examples, along with detailed notes and explanations on how they work.

## What’s Inside?

- **Notes**: Detailed markdown files explaining shellcode concepts, syscall usage, register initialization, stack string construction, and optimization techniques for null-byte-free shellcode.
- **Shellcode Examples**: Minimal assembly programs demonstrating common shellcode patterns like writing to stdout and exiting cleanly.
- **Disassembly Analysis**: Output from tools like `objdump` showing how the shellcodes translate into machine instructions, with a focus on null byte avoidance.
- **Optimizations**: Variants of basic shellcode optimized for compactness, performance, or shellcode safety.

## How to Use

1. Review the notes to understand the theory and reasoning behind each shellcode.
2. Assemble and link the example shellcodes using NASM and `ld`.
3. Analyze the output with tools like `objdump` or `ndisasm` to study instruction bytes.
4. Modify and adapt the shellcode for your own projects or learning.

## Tools & Commands

```bash
nasm -f elf64 example.asm -o example.o
ld example.o -o example
objdump -d example

