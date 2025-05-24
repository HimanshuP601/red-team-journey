section .text
	global _start
_start:
   xor rax , rax  ; emptying rax register
   mov al , 60
   xor rdi , rdi
   syscall	
