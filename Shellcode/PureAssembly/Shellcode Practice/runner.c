#include<stdio.h>
#include<sys/mman.h>
#include<string.h>

unsigned char shellcode[] = 
 "\xeb\x1d\x5e\x48\x31\xc0\xb0\x01\x48\x31\xff\x48\xff\xc7\x48\x31\xd2\xb2\x07\x0f\x05\x48\x31\xc0\xb0\x3c\x48\x31\xff\x0f\x05\xe8\xde\xff\xff\xff\x48\x65\x6c\x6c\x6f\x21\x0a";
int main(){
	void *exec_mem = mmap(NULL , sizeof(shellcode) , PROT_READ | PROT_WRITE | PROT_EXEC , 
	     MAP_PRIVATE | MAP_ANONYMOUS , -1 , 0);
	     
	     
	if (exec_mem == MAP_FAILED) {
		perror("nmap failed");
		return 1;
		
	}
	
	memcpy(exec_mem , shellcode , sizeof(shellcode));
	printf("Shellcode length : %lu bytes \n" , sizeof(shellcode));
	void (*func)() = (void (*)())exec_mem;
	func();
	munmap(exec_mem , sizeof(shellcode));
	return 0;
}     

