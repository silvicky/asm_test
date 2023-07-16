section .text
;Usage:
;EAX=int EBX=int
;EAX=exgcd(EAX,EBX,ECX,EDX)
;and EAX*ECX+EBX*EDX=gcd(EAX,EBX) where EA/BX are original
exgcd:
push esi
cmp ebx,0
jz .end
push edx
mov edx,0
div ebx
push eax
mov eax,ebx
mov ebx,edx
mov edx,ecx
pop esi
pop ecx
push esi
call exgcd
pop esi
push ecx
mov ecx,edx
pop edx
push eax
mov eax,esi
push edx
mul ecx
pop edx
sub edx,eax
pop eax
jmp .end2
.end:
mov ecx,1
mov edx,0
.end2:
pop esi
ret

;Usage:
;EAX=int EBX=int
;EAX=gcd(EAX,EBX)
gcd:
push edx
.loop:
cmp ebx,0
jz .end
mov edx,0
div ebx
mov eax,ebx
mov ebx,edx
jmp .loop
.end:
pop edx
ret

;Usage:
;EAX=string
;Turn EAX to integer
s2i:
push ebx
push ecx
push edx
push esi
mov ecx,10
mov ebx,eax
mov eax,0
mov esi,1
cmp byte [ebx],'-'
jnz .loop
mov esi,-1
inc ebx
.loop:
cmp byte [ebx],0
jz .end
mul ecx
mov edx,0
add dl,[ebx]
sub dl,'0'
add eax,edx
inc ebx
jmp .loop
.end:
mul esi
pop esi
pop edx
pop ecx
pop ebx
ret

;Usage:
;EAX=string
;Turn EAX to its length
strlen:
push ebx
mov ebx,eax
.nxt:
cmp byte [eax],0
jz .end
inc eax
jmp .nxt
.end:
sub eax,ebx
pop ebx
ret

;Usage:
;...
;Print EAX EBX ECX EDX EDI ESI
debug:
push eax
call print_int
call print_lf
mov eax,ebx
call print_int
call print_lf
mov eax,ecx
call print_int
call print_lf
mov eax,edx
call print_int
call print_lf
mov eax,edi
call print_int
call print_lf
mov eax,esi
call print_int
call print_lf
pop eax
call print_lf
ret

;Usage:
;EAX=int
;Print EAX to console
;TODO: resolve
print_int:
push eax
push ecx
push edx
push esi
mov ecx,0
cmp eax,0
jl .rev
jmp .resol
.rev:
push ebx
mov ebx,eax
mov eax,0
sub eax,ebx
pop ebx
push eax
mov eax,'-'
call print
pop eax
.resol:
inc ecx
mov edx,0
mov esi,10
div esi
add edx,48
push edx
cmp eax,0
jnz .resol
.output:
dec ecx
pop eax
call print
cmp ecx,0
jnz .output
pop esi
pop edx
pop ecx
pop eax
ret