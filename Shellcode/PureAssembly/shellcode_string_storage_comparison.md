
# Shellcode String Storage: Push-on-Stack vs Jump-Call-Pop Technique

When writing shellcode that prints strings (e.g., "Hello, World!"), how you store and access the string data is crucial for reliability, size, and position independence.

This document compares two common approaches in shellcode:

- **Push-on-Stack**: Push string parts onto the stack and use `rsp` as a pointer.
- **Jump-Call-Pop**: Embed string inline in code and use jump-call-pop trick to get its address.

---

## 1. Push-on-Stack Shellcode

```asm
section .text
global _start
_start:
    xor rbx, rbx
    mov bx, 0x0a6f      ; '\n' + 'o'
    push bx
    mov bx, 0x6c6c      ; 'l' + 'l'
    push bx
    mov bx, 0x6548      ; 'e' + 'H'
    push bx

    mov al, 1           ; syscall: write
    mov dil, 1          ; fd: stdout
    mov rsi, rsp        ; buffer ptr (stack)
    mov dl, 6           ; length
    syscall

    mov al, 60          ; syscall: exit
    xor edi, edi        ; exit code 0
    syscall
```

### How it works:

- The string is constructed **on the stack** by pushing 16-bit chunks.
- The `rsp` register points to the string buffer.
- The `write` syscall uses `rsp` to print the string.

### Pros

- Simple and minimal instructions.
- Data is built at runtime.

### Cons

- **Not position independent:** relies on the stack being intact and predictable.
- If the shellcode is injected without a proper stack or the stack is cleared, string data is missing.
- If you dump only the `.text` section for injection, the string **won't be included** since it's pushed at runtime.
- Can generate null bytes if string parts are not carefully chosen.

---

## 2. Jump-Call-Pop Shellcode (Loop Technique)

```asm
section .text
global _start
_start:
    jmp message        ; jump over data

print_string:
    pop rsi            ; get pointer to string
    mov rdx, 13        ; string length
    mov rdi, 1         ; stdout
    mov eax, 1         ; syscall: write
    syscall

    mov eax, 60        ; syscall: exit
    xor edi, edi       ; exit code 0
    syscall

message:
    call print_string
    db "Hello, World!", 0x0a
```

### How it works:

- `jmp message` skips over the code to the string.
- `call print_string` pushes the address of the string onto the stack and jumps back.
- `pop rsi` in `print_string` retrieves the string's address from the stack.
- The string is stored **inline in the `.text` section** after the instructions.

### Pros

- **Position independent:** the string address is dynamically resolved at runtime.
- The string is embedded in the shellcode's text section — no external data needed.
- Suitable for shellcode injection where only the text segment is copied.
- Easier to avoid null bytes.
- Reliable across different environments and memory layouts.

### Cons

- Slightly larger code footprint due to control flow instructions.
- More complex to understand at first glance.

---

## Visual Comparison

| Feature                     | Push-on-Stack                   | Jump-Call-Pop                          |
|-----------------------------|--------------------------------|---------------------------------------|
| **String Storage Location** | Stack (runtime)                 | Inline in code (`.text` section)       |
| **Position Independence**   | Low                            | High                                  |
| **String Included in `.text` Section?** | No                         | Yes                                   |
| **String Address Access**   | Known (`rsp` after push)        | Retrieved via `call`/`pop` trick       |
| **Reliability in Injection**| Less reliable (depends on stack) | Highly reliable                        |
| **Size**                    | Smaller                        | Slightly bigger                       |
| **Null Bytes Risk**         | Moderate (care needed)          | Lower (easier to control)             |

---

## Why Jump-Call-Pop is the Preferred Approach for Shellcode

- Shellcode is often injected into unknown memory regions.
- The stack layout may be unpredictable or restricted.
- Embedding strings inline in the `.text` section and calculating their address at runtime guarantees the string is always accessible.
- The `jmp-call-pop` method is the canonical way to achieve **position-independent shellcode** that works robustly on real targets.
- Avoids null bytes and tricky string setup on the stack.
- Widely used in exploit development and advanced shellcoding tutorials.

---

## Summary

| Key Point                         | Takeaway                                           |
|----------------------------------|---------------------------------------------------|
| String data location matters      | Must ensure string is accessible at runtime       |
| Position independence is critical| Jump-call-pop method enables this reliably        |
| Stack data may not be preserved  | Inline `.text` strings are safer for injection    |
| Jump-call-pop is a classic trick | Recommended for any shellcode needing embedded data |

---

## References and Further Reading

- [Shellcoding Techniques — Jump-Call-Pop Trick](https://www.exploit-db.com/docs/english/18504-linux-shellcoding-techniques.pdf)
- [Writing Position Independent Shellcode](https://www.cs.uaf.edu/2013/fall/cs301/lecture/lecture15.html)
- [Advanced Linux Shellcoding](https://www.felixcloutier.com/x86/jmp)
- [Assembly for Exploit Development](https://phrack.org/issues/66/3.html)

---

