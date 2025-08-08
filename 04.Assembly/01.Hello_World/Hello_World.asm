section .text
global _start:
_start:
	jmp printer
	
execute:
	;write (int fd , const void *buf , size_t count)
	pop rsi
	mov dil , 1
	mov dl , 13
	mov al , 1
	syscall
	
	mov al , 60
	xor rdi , rdi
	syscall
	
	
printer:
	call execute
	db 'Hello, World!',0x0a		
