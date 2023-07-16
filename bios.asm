section .text
bits 16
;Usage:
;none
;Quit
quit:
mov ah,0
int 16h
int 19h
ret

;Usage:
;EAX=char
;Print EAX to console
print:
push eax
mov ah,0eh
int 10h
pop eax
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