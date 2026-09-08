; Test 01

;section .data
;    msg db "Hello, Assembly!", 10
;    len equ $ - msg
;section .text
;    global _start
;_start:
;    mov rax, 1
;    mov rdi, 1
;    mov rsi, msg
;    mov rdx, len
;    syscall
;    mov rax, 60
;    xor rdi, rdi
;    syscall

; Test 02

section .data
    digit db 0, 10          ; byte 0 = the character, byte 1 = a newline

section .text
    global _start
_start:
    mov byte [digit], '9'

    mov rax, 1              ; write
    mov rdi, 1              ; stdout
    mov rsi, digit
    mov rdx, 2              ; the character byte AND the newline byte
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall
