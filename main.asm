section .data
    msg db "Hello, Assembly!", 10
    len equ $ - msg
section .text
    global _start
_start:
    ; mov rax, 1 ... syscall
    ; mov rax, 60 ... syscall
    mov rax, 60
    xor rdi, rdi
    syscall
