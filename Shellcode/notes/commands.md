# Reverse Shell Development & Syscall Debugging Notes

## 🛠️ Assembly to Executable

```bash
nasm -f elf64 -o obj file.asm       # Assemble the file
ld obj -o executable                # Link the object file
objdump -M intel -d executable      # Disassemble with Intel syntax
```

---

## 🐍 Python One-liner

Reverse a string and encode it as hex:

```python
'string'[::-1].encode().hex()
```

---

## 🔍 Syscall Information

### Get syscall number for `execve`:

```bash
cat /usr/include/x86_64-linux-gnu/asm/unistd_64.h | grep execve
```

---

## 📦 Extracting Opcodes

### C-style Shellcode Format:

```bash
objdump -d shell_exe -M intel | grep "^ " | awk '
{
  for(i=2;i<=NF;i++) {
    if ($i ~ /^[0-9a-fA-F]{2}$/)
      printf "\x%s", $i
    else
      break
  }
}
END { print "" }
'
```

### Rust-style Shellcode Format:

```bash
objdump -d shell_exe -M intel | grep "^ " | awk '
{
  for(i=2;i<=NF;i++) {
    if ($i ~ /^[0-9a-fA-F]{2}$/)
      printf "0x%s, ", $i
    else
      break
  }
}
END { print "" }
'
```

### Chunked C-style Shellcode (16 bytes per line):

```bash
objdump -d -M intel shell_exe | grep "^ " | awk '
{
  for (i = 2; i <= NF; i++) {
    if ($i ~ /^[0-9a-fA-F]{2}$/) {
      bytes = bytes "\x" $i
      count++
      if (count == 16) {
        print "\" bytes "\""
        bytes = ""
        count = 0
      }
    } else {
      break
    }
  }
}
END {
  if (bytes != "") print "\" bytes "\""
}
'
```

---

## 🔬 Program Behavior Analysis

Use `strace` to trace system calls made by a program:

```bash
strace -f ./rev_shell
```

---

## 🧠 x86-64 Linux Calling Convention

**Register usage for syscall arguments:**

```
rdi, rsi, rdx, r10, r8, r9
```

**Syscall number is placed in:** `rax`  
**Return value is stored in:** `rax`

---

## 🎧 Attacker Side (Listener)

Use Netcat to listen for incoming reverse shell connections:

```bash
nc -lvnp <port>
```

---

## ⚙️ Compilation and Debugging Commands

Compile C runner with execstack permission and without PIE or stack protector:

```bash
gcc -z execstack -no-pie -fno-stack-protector -o runner runner.c
```

Use `strace` to debug and find errors:

```bash
strace -f ./runner
```

