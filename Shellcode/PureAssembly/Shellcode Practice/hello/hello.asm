section .text
	global _start
_start:
		jmp short msg
		
	print_string:
		pop rsi 
		xor rax , rax
		mov al , 1
		xor rdi , rdi 
		inc rdi
		xor rdx , rdx
		mov dl , 7
		syscall
		
		xor rax , rax
		mov al , 60
		xor rdi ,rdi
		syscall
		
	msg:
		call print_string
		db "Hello!" , 0x0A
