section .text
bits 16
org 100h
;Usage:
;none
;Quit
quit:
int 20h
ret

;Usage:
;EAX=char
;Print EAX to console
print:
push edx
push eax
mov dl,al
mov ah,2
int 21h
pop eax
pop edx
ret

;Usage:
;none
;Print a LF to console
print_lf:
push eax
mov al,13
call print
mov al,10
call print
pop eax
ret

;Usage:
;EAX=string
;Print EAX to console
strprt:
push eax
.start:
cmp byte [eax],0
jz .end
push eax
mov eax,[eax]
call print
pop eax
inc eax
jmp .start
.end:
pop eax
ret