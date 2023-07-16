jmp _start
%define SYSTEM_NAME 'bios'
%strcat SYSTEM_ASM SYSTEM_NAME,'.asm'
%include SYSTEM_ASM
%include 'general.asm'
global _start
section .text
_start:
;mov eax,[val]
;call print_int
;call print_lf
mov eax,240
mov ebx,46
call exgcd
call debug
call quit
;section .bss
;valx resb 4
;valy resb 4
;section .data
msg db '-123456789',0h
val dd 123456
len equ $-msg
times 510-($-$$) db 0
db 0x55,0xaa