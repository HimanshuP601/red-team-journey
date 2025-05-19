# Basic Shellcode Notes

These are quick reference notes for shellcode development and binary analysis.

---

## 🔧 Assembling and Linking (x86_64)

```bash
nasm -f elf64 -o obj file.asm    # Assemble the file into ELF64 object format
ld obj -o executable             # Link the object to create an executable
objdump -M intel -d executable  # Disassemble the executable using Intel syntax
```

---

## 🐍 Python Tricks

```python
'string'[::-1].encode().hex()   # Reverse a string, encode to bytes, and convert to hex
```

---

## 🧠 System Calls

### Get syscall number for `execve`:
```bash
cat /usr/include/x86_64-linux-gnu/asm/unistd_64.h | grep execve
```

- System call numbers are placed into `rax`.
- Return values also come back in `rax`.

---

## 🧪 Extract Shellcode (Opcodes)

### From C Output:
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

### From Rust Output:
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

---

## 🔍 Debugging

### Trace syscalls used by a binary:
```bash
strace -f ./rev_shell
```

---

## 📦 Register Parameter Passing (Linux x86_64)

For system calls:
- **Arguments go into registers in this order:**

```text
rdi, rsi, rdx, r10, r8, r9
```

---

## 🎧 Attacker Side Listener

```bash
nc -lvnp <port>
```

Use this to listen for reverse shells or connect back from the victim.
