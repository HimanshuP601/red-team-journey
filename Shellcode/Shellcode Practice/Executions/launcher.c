#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

 unsigned char shellcode[] = 
  "\xeb\x17\x5e\x48\x31\xc0\xb0\x01\x40\xb7\x01\xb2\x07\x0f\x05\x48\x31\xc0\xb0\x3c\x48\x31\xff\x0f\x05\xe8\xe4\xff\xff\xff\x48\x65\x6c\x6c\x6f\x21\x0a";//64-bit shellcode


int main() {

    
    size_t size = sizeof(shellcode);

    // Allocate RWX memory using mmap
    void *exec = mmap(NULL, size, 
                      PROT_READ | PROT_WRITE | PROT_EXEC,
                      MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
    
    if (exec == MAP_FAILED) {
        perror("mmap");
        return 1;
    }

    // Copy shellcode into executable memory
    memcpy(exec, shellcode, size);

    // Cast to function and call
    ((void(*)())exec)();

    return 0;
}

