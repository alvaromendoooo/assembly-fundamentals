default rel

section .bss
    input resb 4             ; Buffer to read input from stdin

section .data
    star db '*'
    newline db 10

section .text
    global _start

_start:
    ; 1. Read input integer from stdin
    mov rax, 0               ; sys_read
    mov rdi, 0               ; stdin
    mov rsi, input
    mov rdx, 4
    syscall

    ; 2. Convert ASCII character input to integer count N
    movzx r12, byte [input]
    sub r12, '0'             ; r12 = total rows N

    mov r13, 1               ; r13 = current row index (1 to N)

.outer_loop:
    cmp r13, r12
    jg .done                 ; If current_row > N, exit

    ; Inner loop: print '*' current_row times
    mov r14, 0               ; r14 = star counter
.inner_loop:
    cmp r14, r13
    jge .print_newline

    ; Print single '*'
    mov rax, 1               ; sys_write
    mov rdi, 1               ; stdout
    mov rsi, star
    mov rdx, 1
    syscall

    inc r14
    jmp .inner_loop

.print_newline:
    ; Print newline character at the end of each row
    mov rax, 1               ; sys_write
    mov rdi, 1               ; stdout
    mov rsi, newline
    mov rdx, 1
    syscall

    inc r13                  ; Move to next row
    jmp .outer_loop

.done:
    mov rax, 60              ; sys_exit
    xor rdi, rdi             ; exit code 0
    syscall            ; return to C runtime caller instead of raw syscall
