[bits 64]


LM_VGAClear:
    push rdi
    push rax
    push rcx

    shl rdi, 8
    mov rax, rdi

    mov al, ` `
    mov rdi, VGA_START
    mov rcx, VGA_SIZE / 2

    rep stosw

    pop rcx
    pop rax
    pop rdi
    ret


; Args
; rsi       String to print
LM_VGAPrint:
    push rax
    push rdx
    push rdi
    push rsi

    mov rdx, VGA_START
    shl rdi, 8

LM_VGAPrint_LoopStart:
    cmp byte[rsi], 0    ; Check for null terminator
    je LM_VGAPrint_LoopEnd

    ; Handle strings that are too long
    cmp rdx, VGA_START + VGA_SIZE
    je LM_VGAPrint_LoopEnd

    mov rax, rdi
    mov al, byte[rsi]

    mov word[rdx], ax
    add rsi, 1
    add rdx, 2
    jmp LM_VGAPrint_LoopStart
LM_VGAPrint_LoopEnd:
    pop rsi
    pop rdi
    pop rdx
    pop rax
    ret
