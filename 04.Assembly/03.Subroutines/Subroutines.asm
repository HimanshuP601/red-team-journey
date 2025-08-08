section .data
	msg db 'Currently i am in 4th year , May i achive my goal :)' , 0x0a
	
section .text
global _start
_start:
	mov rax , msg
	call strlen
	
	mov rdi , 1
	mov rsi , msg
	xor rax , rax
	mov al , 1
	syscall
	
	mov al , 60
	xor rdi , rdi
	syscall
	
strlen:
	
	mov rdx , rax
loop:
	cmp byte[rdx] , 0
	je finished
	inc rdx
	jmp loop
finished:
	sub rdx , rax
	
	ret	
	
