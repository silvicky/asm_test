section .text
;Usage:
;none
;Quit
quit:
mov eax,1
mov ebx,0
int 80h
ret

;Usage:
;EAX=char
;Print EAX to console
print:
push edx
push ecx
push ebx
push eax
mov edx,1
mov ecx,esp
mov ebx,1
mov eax,4
int 80h
pop eax
pop ebx
pop ecx
pop edx
ret

;Usage:
;none
;Print a LF to console
print_lf:
push eax
mov eax,10
call print
pop eax
ret

;Usage:
;EAX=string
;Print EAX to console
strprt:
push edx
push ecx
push ebx
push eax
mov ecx,eax
call strlen
mov edx,eax
mov eax,4
mov ebx,1
int 80h
pop eax
pop ebx
pop ecx
pop edx
ret