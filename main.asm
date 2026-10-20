default rel

section .bss
    line resb 128            ; Input buffer
    rev  resb 128            ; Output buffer for reversed string

section .text
    global _start

_start:
    ; 1. Read input line from stdin
    mov rax, 0               ; sys_read
    mov rdi, 0               ; file descriptor: stdin
    mov rsi, line            ; buffer pointer
    mov rdx, 128             ; max bytes to read
    syscall                  ; rax now contains the number of bytes read

    cmp rax, 0
    jle .done                ; Exit if read failed or 0 bytes read

    ; 2. Determine string length excluding trailing newline
    mov rcx, rax             ; rcx = total bytes read
    dec rcx                  ; Adjust index to point to last byte read

    ; If last character is '\n' (ASCII 10), drop it from length calculation
    cmp byte [line + rcx], 10
    jne .prepare_reverse
    dec rcx                  ; Pointer now at the last actual character

.prepare_reverse:
    ; At this point:
    ; rcx = index of last character in `line`
    ; rcx + 1 = total character count to reverse
    cmp rcx, 0
    jl .print_newline_only   ; If line was empty (only '\n'), just print newline

    mov rbx, rcx             ; rbx = length - 1 (used for character loop)
    xor rsi, rsi             ; rsi = index for target buffer `rev`

.reverse_loop:
    mov al, [line + rbx]     ; Read character from end of `line`
    mov [rev + rsi], al      ; Write character to start of `rev`
    inc rsi                  ; Move forward in `rev`
    dec rbx                  ; Move backward in `line`
    cmp rbx, 0
    jge .reverse_loop

    ; Append newline to reversed string
    mov byte [rev + rsi], 10
    inc rsi                  ; rsi now holds the total output length

    ; 3. Print reversed string
    mov rax, 1               ; sys_write
    mov rdi, 1               ; file descriptor: stdout
    mov rsi, rev             ; buffer pointer
    mov rdx, rsi             ; output length
    mov rsi, rev             ; reset buffer address for write
    syscall
    jmp .done

.print_newline_only:
    mov byte [rev], 10
    mov rax, 1               ; sys_write
    mov rdi, 1               ; stdout
    mov rsi, rev
    mov rdx, 1
    syscall

.done:
    mov rax, 60              ; sys_exit
    xor rdi, rdi             ; exit code 0
    syscall    ; return to C runtime caller instead of raw syscall
