%macro pushd 0
    push rax
    push rbx
    push rcx
    push rdx
%endmacro

%macro popd 0
    pop rdx
    pop rcx
    pop rbx
    pop rax
%endmacro

%macro print 2
		pushd
        mov rax, 1
        mov rdi, 1
        mov rdx, %1
        mov rsi, %2
        syscall
		popd
%endmacro

%macro printNumber 1
		pushd
		mov rbx, 0
		mov rax, [%1]
		mov rcx, 10
		%%_divide:
			xor rdx, rdx
			div rcx
			push rdx
			inc rbx
			test rax, rax
			jnz %%_divide
		%%_display:
			pop rax
			add rax, '0'
			mov [result], rax
			print 1, result
			dec rbx
			cmp rbx, 0
			jg %%_display
		popd
%endmacro

section   .text
global    _start

_start: 
		mov edx, 0
		mov eax, 0
	loop:
		xor esi, esi
		cmp edx, len
		jge count
		
		mov esi, dword [x + edx * 4]
		cmp esi, dword [y + edx * 4]
		jl less
		bigger:
			sub esi, dword [y + edx * 4]
			jmp work
		less:
			mov esi, dword [y + edx * 4]
			sub esi, dword [x + edx * 4]
		work:

		add eax, esi
		mov [val], eax
		inc edx
		jmp loop
	count:
		mov ecx, edx
		mov edx, 0
		div ecx
		mov [val], eax
end:
        print mlen, message
		printNumber val
        print nlen, newLine
		print rlen, remMessage
		mov [val], edx
		printNumber val
        print nlen, newLine
        mov       rax, 60
        xor       rdi, rdi
        syscall

section .data
	x dd 5, 3, 2, 6, 1, 7, 4
	len equ ($ - x) / 4
	y dd 0, 10, 1, 9, 2, 8, 5
    
    message db "Average value is: "
    mlen equ $ - message
	remMessage db "Remainder is: "
	rlen equ $ - remMessage
    newLine db 0xA, 0xD
    nlen equ $ - newLine
section .bss
		val resb 1
		result resb 1
		