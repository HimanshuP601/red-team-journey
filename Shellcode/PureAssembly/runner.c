#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

unsigned char shellcode[] =
"\x48\x31\xdb\x66\xbb\x6f\x0a\x66\x53\x66\xbb\x6c\x6c\x66\x53\x66\xbb\x48\x65\x66\x53\xb0\x01\x40\xb7\x01\x48\x89\xe6\xb2\x06\x0f\x05\xb0\x3c\x48\x31\xff\x0f\x05";

int main() {
    size_t shellcode_len = sizeof(shellcode) - 1; // ✅ FIXED LENGTH

    void *exec_mem = mmap(NULL, shellcode_len, PROT_READ | PROT_WRITE | PROT_EXEC,
                          MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (exec_mem == MAP_FAILED) {
        perror("mmap failed");
        return 1;
    }

    memcpy(exec_mem, shellcode, shellcode_len);
    printf("Shellcode length: %zu bytes\n", shellcode_len);

    void (*func)() = (void (*)())exec_mem;
    func();

    munmap(exec_mem, shellcode_len);
    return 0;
}

