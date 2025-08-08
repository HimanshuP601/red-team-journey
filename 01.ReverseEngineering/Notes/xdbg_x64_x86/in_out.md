
# Input/Output Instruction Demonstration

This document demonstrates how input and output instructions work at the assembly level for basic C programs. It includes string and integer input/output scenarios, showing how memory is allocated and how the respective instructions are executed.

---

## 🧵 String Input/Output (C Program)

```c
#include <stdio.h>

int main() {
    char name[100];
    printf("Enter Your name:");
    scanf("%s", name);
    printf("Hello %s", name);
}
```

### Memory Allocation

- From `.data` section:
  - `0xadd1` – Address for `"Enter Your name:"`  
    Hex: `45 6E 74 65 72 20 59 6F 75 72 20 6E 61 6D 65 3A`
  - `0xadd2` – Address for `"%s"`  
    Hex: `25 73`
  - `0xadd3` – Address for `"Hello %s"`  
    Hex: `48 65 6C 6C 6F 20 25 73`

- From `.bss` section:
  - `0xadd4` – Address for variable `name` (uninitialized, dynamic)

### Instructions

```asm
push ebp
mov ebp, esp

; printf("Enter Your name:");
push 0xadd1
call 0xprintf

; scanf("%s", name);
push 0xadd4         ; destination buffer
push 0xadd2         ; "%s"
call 0xscanf

; printf("Hello %s", name);
push 0xadd4         ; name
push 0xadd3         ; "Hello %s"
call 0xprintf

mov esp, ebp
pop ebp
```

---

## 🔢 Integer Input/Output (C Program)

```c
#include <stdio.h>

int main() {
    int num;
    printf("Enter a number:");
    scanf("%d", &num);
    printf("Number was %d", num);
}
```

### Memory Allocation

- From `.data` section:
  - `0xadd1` – Address for `"Enter a number:"`
  - `0xadd2` – Address for `"%d"`
  - `0xadd3` – Address for `"Number was %d"`

- From `.bss` section:
  - `0xadd4` – Address for variable `num` (uninitialized)

### Instructions

```asm
push ebp
mov ebp, esp

; printf("Enter a number:");
push 0xadd1
call 0xprintf

; scanf("%d", &num);
push 0xadd4
push 0xadd2
call 0xscanf

; printf("Number was %d", num);
push dword ptr [0xadd4]  ; push the value of num
push 0xadd3
call 0xprintf

mov esp, ebp
pop ebp
```

---

## Notes

- String inputs/outputs require memory for character arrays and are handled via `%s`.
- Integer values are stored and accessed via dword-sized memory blocks, allowing direct value access using `dword ptr [addr]`.
- `.bss` is used for dynamic (uninitialized) variables.
- `.data` holds static strings and initialized values.

---