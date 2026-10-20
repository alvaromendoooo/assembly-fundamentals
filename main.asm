default rel

section .data
    digit db 0, 10

section .text
    global main             ; Renamed from _start to main

main:
    xor rcx, rcx

.loop:
    cmp rcx, 10
    jge .done

    test rcx, 1
    jnz .next

    mov al, cl
    add al, '0'
    mov [digit], al

    push rcx
    mov rax, 1              ; sys_write
    mov rdi, 1              ; stdout
    mov rsi, digit
    mov rdx, 2
    syscall
    pop rcx

.next:
    inc rcx
    jmp .loop

.done:
    mov rax, 0              ; return 0 from main()
    ret                     ; return to C runtime caller instead of raw syscall
