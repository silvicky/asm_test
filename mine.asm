bits 16
org 7c00h
mine_init:
xor ax,ax
mov es,ax
mov ds,ax
mov word [8103h],0
mov byte [8102h],100
;generate random seed
int 1ah
or dx,1
mov word [8100h],dx
mov ax,3
int 10h
mov bx,10h
mov ax,[8100h]
row:
cmp bx,0a0h
jg row_end
mov si,1
col:
cmp si,10
jg col_end
;generate random
not ax
imul word [8100h]
xor ax,41267
mov [bx+si+7e00h],ah
shl byte [bx+si+7e00h],1
shr byte [bx+si+7e00h],4
cmp byte [bx+si+7e00h],2
jle aaa
mov byte [bx+si+7e00h],0
jmp aaa2
aaa:
mov byte [bx+si+7e00h],1
dec byte [8102h]
inc byte [8103h]
inc byte [8104h]
aaa2:
mov byte [bx+si+8000h],0
inc si
jmp col
col_end:
add bx,10h
jmp row
row_end:

mov bx,10h
row2:
cmp bx,0a0h
jg row2_end
mov si,1
col2:
cmp si,10
jg col2_end
cmp byte [bx+si+7e00h],1
je mp
mov al,48
add al,[bx+si+7defh]
add al,[bx+si+7df0h]
add al,[bx+si+7df1h]
add al,[bx+si+7dffh]
add al,[bx+si+7e01h]
add al,[bx+si+7e0fh]
add al,[bx+si+7e10h]
add al,[bx+si+7e11h]
mov [bx+si+7f00h],al
jmp ee
mp:
mov byte [bx+si+7f00h],'*'
ee:
inc si
jmp col2
col2_end:
add bx,10h
jmp row2
row2_end:

mov cl,1
row3:
cmp cl,10
jg row3_end
mov ax,0e3fh
mov bx,000fh
mov ch,1
col3:
cmp ch,10
jg col3_end
int 10h
inc ch
jmp col3
col3_end:
mov al,13
int 10h
mov al,10
int 10h
inc cl
jmp row3
row3_end:

input:
xor ax,ax
int 16h
mov dh,al
sub dh,47
xor ax,ax
int 16h
mov dl,al
cmp al,'a'
jl mark
sub dl,96
mov cl,dh
shl cl,4
add cl,dl
xor ch,ch
mov si,cx
add si,7f00h
cmp byte [si+100h],0
jnz input
mov byte [si+100h],1
mov ax,1300h
mov bx,0002h
mov cx,1
mov bp,si
dec dh
dec dl
int 10h
cmp byte [si],'*'
je fail
dec byte [8102h]
cmp byte [8102h],0
je victory
jmp input
mark:
sub dl,64
mov cl,dh
shl cl,4
add cl,dl
xor ch,ch
mov si,cx
cmp byte [si+8000h],1
je input
dec dh
dec dl
mov cx,1
mov ax,1300h
cmp byte [si+8000h],2
je demark
mov bx,0004h
mov bp,mark_char
int 10h
mov byte [si+8000h],2
cmp byte [si+7e00h],1
jnz end_mark
dec byte [8103h]
end_mark:
dec byte [8104h]
jmp mark_changed
demark:
mov bx,0007h
mov bp,question
int 10h
mov byte [si+8000h],0
cmp byte [si+7e00h],1
jnz end_demark
inc byte [8103h]
end_demark:
inc byte [8104h]
jmp mark_changed
mark_changed:
mov si,8104h
mov di,tmpnum
movsb
add byte [tmpnum],48
print_mine:
mov ax,1300h
mov bx,000dh
mov cx,1
mov dx,000bh
mov bp,tmpnum
int 10h
cmp word [8103h],0
jnz input
jmp victory

fail:
mov bp,fail_msg
jmp postpre

victory:
mov bp,victory_msg
jmp postpre

postpre:
mov ah,3
mov bh,0
int 10h
mov ax,1301h
mov bl,0ch
mov cx,7
int 10h
mov ax,0
int 16h
jmp mine_init

mark_char db "X"
question db "?"
tmpnum db " "
fail_msg db "BOOM!",13,10
victory_msg db "WIN!!",13,10
times 510-($-$$) db 0
db 0x55,0xaa