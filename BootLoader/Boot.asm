; Our code gets loaded at address 0x7c00. We specify this
; to avoid issues when jumping around in the code
[org 0x7c00]

[bits 16]

; Set base and stack pointer above where BIOS loads
; our boot sector so that it won't overwrite us
mov bp, 0x0500
mov sp, bp

mov byte[BOOT_DRIVE], dl

mov bx, HELLO_WORLD_MSG
call RM_PrintString

mov bx, 0x0002  ; Load the 2nd sector, since 1st is already loaded
mov cx, 0x0005  ; The number of additional sectors
mov dx, 0x7E00  ; 0x7E00 is 512 bytes after 0x7C00
call RM_LoadDisk

call RM_SwitchToPM
jmp $

%include "RealMode/GDT.asm"
%include "RealMode/LoadDisk.asm"
%include "RealMode/PrintHex.asm"
%include "RealMode/PrintString.asm"
%include "RealMode/SwitchToPM.asm"

BOOT_DRIVE db 0x0

; Global variables
; Using ` allows us to use C-style escapes such as '\r' or '\n' or '\t'
HELLO_WORLD_MSG db `Hello world!\r\n`, 0

; We add padding to the boot sector so that it is
; 512 bytes. This allows BIOS to find the 2 byte
; magic number at the end of the boot sector
times 510 - ($ - $$) db 0x0

; Define the magic number, allowing BIOS to find the
; end of our boot sector
dw 0xaa55



PROTECTED_MODE_SECTION:
[bits 32]

BeginProtectedMode:
    call PM_InitLongMode

    call PM_VGAClear
    mov esi, LONG_MODE_MSG
    call PM_VGAPrint

    call PM_InitPageTable
    call PM_SwitchToLM
    jmp $


%include "ProtectedMode/GDT.asm"
%include "ProtectedMode/InitLongMode.asm"
%include "ProtectedMode/InitPageTable.asm"
%include "ProtectedMode/SwitchToLM.asm"
%include "ProtectedMode/VGA.asm"


; Global variables
VGA_START:      equ 0xb8000
; VGA Memory is 80 chars wide and 25 chars tall.
; Each char is 2 bytes
VGA_SIZE:       equ 80 * 25 * 2
VGA_STYLE:      equ 0xf
LONG_MODE_MSG:  db `64-bit long mode supported`, 0

times 512 - ($ - PROTECTED_MODE_SECTION) db 0x0



LONG_MODE_SECTION:
[bits 64]


BeginLongMode:
    mov rdi, VGA_STYLE_BLUE
    call LM_VGAClear
    mov rsi, LONG_MODE_BOOT_MSG
    call LM_VGAPrint
    call 0x8200     ; Kernel is at 1MB
    jmp $


%include "LongMode/VGA.asm"

; Global variables
VGA_STYLE_BLUE:     equ 0x1f
LONG_MODE_BOOT_MSG: db `Running in 64-bit long mode`, 0

times 512 - ($ - LONG_MODE_SECTION) db 0x0
