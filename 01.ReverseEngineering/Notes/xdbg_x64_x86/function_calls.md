# Calling Functions in x64dbg (e.g., `printf`, `scanf`, `strlen`)

This guide explains how to manually call common functions (like `printf`, `scanf`, `strlen`, etc.) inside **x64dbg**, specifically for debugging and reverse engineering x86-64 binaries.

> **Note:** This guide applies to user-mode programs in x64dbg. Calling functions in **shellcode** or **manual mapping** scenarios requires a different approach due to limitations with APIs and memory layout.

---

## Function Calling Format

A typical C-style function call looks like:

```c
function(arg1, arg2, arg3, ..., argN);
```

However, when calling such functions manually (e.g., in x64dbg), we must follow the **Windows x64 calling convention**, which uses registers for the first few arguments and a specific stack setup.

---

## Windows x64 Calling Convention Summary

- **Arguments** (in order):
  - `RCX` → 1st argument
  - `RDX` → 2nd argument
  - `R8` → 3rd argument
  - `R9` → 4th argument
  - Any additional arguments go on the **stack** (right to left)
- **Return Value** → Stored in `RAX`
- **Callee-saved registers**: `RBX`, `RBP`, `RDI`, `RSI`, `R12–R15`
- **Caller must align `RSP`** to a 16-byte boundary **before `CALL`**

---

## General Stack Setup (for manual call)

```assembly
push rbp
mov  rbp, rsp

; [Optional] Push extra arguments if more than 4
; Set RCX, RDX, R8, R9 for the first 4 arguments
; Use `mov` instructions to load them

call <function_address>

mov  rsp, rbp
pop  rbp
```

If the function returns a value, it will be stored in `RAX`.

---

## Example 1: `printf("Hello World!")`

**Steps**:
1. Allocate and store `"Hello World!"` string in the `.data` section (get address, e.g., `0x3234`)
2. Move address into `RCX` (since it's the 1st argument)

**Instructions**:
```assembly
push rbp
mov  rbp, rsp
mov  rcx, 0x3234       ; address of "Hello World!" string
call 0x1222            ; address of `printf` (from function calls list)
mov  rsp, rbp
pop  rbp
```

---

## Example 2: `scanf("%s", &string)`

**Steps**:
- `%s` format string goes into `.data`
- Target variable (uninitialized string) allocated in `.bss`
- Arguments:
  - `RCX` = format string (`%s`)
  - `RDX` = address of the target string

**Instructions**:
```assembly
push rbp
mov  rbp, rsp
mov  rcx, 0xadd2       ; address of "%s" in .data
mov  rdx, 0xadd1       ; address for string in .bss
call 0xscanf           ; address of `scanf`
mov  rsp, rbp
pop  rbp
```

---

## Example 3: `strlen("Nothing in mind")`

**Steps**:
- Allocate `"Nothing in mind"` in `.data`
- Move its address to `RCX` (1st argument)

**Instructions**:
```assembly
push rbp
mov  rbp, rsp
mov  rcx, 0xadd1       ; address of string in .data
call 0xstrlen          ; address of `strlen`
mov  rsp, rbp
pop  rbp
```

- After execution, the return value (i.e., the length of the string) will be in `RAX`.

---

## Notes

- `.data` → Stores **initialized** data (e.g., strings with known content)
- `.bss` → Stores **uninitialized** data (e.g., user input buffers)
- Strings are stored in memory in **little-endian** format
- To find function addresses in x64dbg:
  - Use the **Symbols** tab or search for the function in the **Functions** list
  - Break at `main` or `entry` to analyze dynamic imports (like `printf`, `scanf`)

---

## Practical Tips

- Always align the stack to a 16-byte boundary before calling a function.
- Use `mov` for register setup — **do not push arguments** unless required (e.g., more than 4).
- Monitor `RAX` after `CALL` to inspect the return value.
- Use the **"Call Stack"** and **"CPU"** panes in x64dbg for function flow and register values.