%include 'functions.asm'

section .data
	msg1 db 'Its first msg.', 0x0A 	
	msg2 db 'Its second msg.', 0x0A 
	
section .text	
global _start
_start:
	mov rsi , msg1
	call sprint
	
	mov rsi , msg2
	call sprint
	
	call quit
	
