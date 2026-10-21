default rel

section .bss
    buffer resb 32           ; Buffer for input reading
    num_str resb 32          ; Buffer for integer-to-string formatting

section .data
    prefix db "! = ", 0

section .text
    global _start
    global fact

; ------------------------------------------------------------------------------
; Function: fact
; Input:  rdi = N (0 <= N <= 9)
; Output: rax = N!
; ABI:    System V AMD64 ABI (preserves rbx, rsp, rbp, r12-r15)
; ------------------------------------------------------------------------------
fact:
    mov rax, 1               ; Base case: 0! = 1 and 1! = 1
    cmp rdi, 1
    jle .done

    mov rcx, rdi             ; Loop counter from N down to 2
.loop:
    imul rax, rcx            ; rax = rax * rcx
    dec rcx
    cmp rcx, 1
    jg .loop

.done:
    ret

; ------------------------------------------------------------------------------
; Starter code entry point
; ------------------------------------------------------------------------------
_start:
    ; 1. Read single digit character from stdin
    mov rax, 0               ; sys_read
    mov rdi, 0               ; stdin
    mov rsi, buffer
    mov rdx, 32
    syscall

    ; 2. Convert ASCII character digit to integer N
    movzx rdi, byte [buffer]
    sub rdi, '0'             ; Pass N in rdi to fact

    ; Save original N in callee-saved register rbx per System V ABI
    mov rbx, rdi             

    ; 3. Call fact(N) -> returns result in rax
    call fact
    push rax                 ; Preserve N! result on stack across printing

    ; 4. Print N
    mov rdi, rbx
    call print_uint

    ; 5. Print "! = " prefix
    mov rax, 1               ; sys_write
    mov rdi, 1               ; stdout
    mov rsi, prefix
    mov rdx, 4               ; length of "! = "
    syscall

    ; 6. Print N!
    pop rdi                  ; Pass N! as argument to print_uint
    call print_uint

    ; Print newline
    mov byte [buffer], 10
    mov rax, 1               ; sys_write
    mov rdi, 1               ; stdout
    mov rsi, buffer
    mov rdx, 1
    syscall

    ; Exit
    mov rax, 60              ; sys_exit
    xor rdi, rdi             ; status 0
    syscall

; Helper: Print an unsigned integer passed in rdi
print_uint:
    mov rax, rdi
    mov rcx, num_str + 31    ; Point to end of buffer
    mov byte [rcx], 0        ; Null terminator
    mov rbx, 10

.convert_loop:
    xor rdx, rdx
    div rbx                  ; rax = quotient, rdx = remainder
    add dl, '0'              ; Convert digit to ASCII
    dec rcx
    mov [rcx], dl
    test rax, rax
    jnz .convert_loop

    ; Calculate length
    mov rdx, num_str + 31
    sub rdx, rcx             ; rdx = string length

    ; sys_write
    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    syscall
    ret
