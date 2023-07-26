bits 16
org 7c00h
mine_init:
xor ax,ax
mov es,ax
mov ss,ax
mov sp,ax
mov ds,ax
;generate random seed
int 1ah
or dx,1
mov word [8000h],dx
mov ax,3
int 10h
mov bx,10h
mov ax,[8000h]
row:
cmp bx,0a0h
jg row_end
mov si,2
col:
cmp si,10
jg col_end
;generate random
not ax
imul word [8000h]
xor ax,41267
mov [bx+si+7e00h],ah
shl byte [bx+si+7e00h],1
shr byte [bx+si+7e00h],4
cmp byte [bx+si+7e00h],3
jle aaa
mov byte [bx+si+7e00h],0
jmp aaa2
aaa:
mov byte [bx+si+7e00h],1
dec byte [cnt]
inc byte [cnt+1]
aaa2:
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
mov ax,0
int 16h
mov dh,al
sub dh,47
mov ax,0
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
mov ax,1300h
mov bx,0002h
mov cx,1
mov bp,si
dec dh
dec dl
int 10h
cmp byte [si],'*'
je fail
dec byte [cnt]
cmp byte [cnt],0
je victory
jmp input
mark:
sub dl,65
mov ax,1300h
mov bx,0004h
mov cx,1
mov bp,mark_char
dec dh
int 10h
jmp input

fail:
mov ah,3
mov bh,0
int 10h
mov cx,0007h
mov bp,fail_msg
mov ax,1301h
mov bx,000ch
int 10h
jmp postpre

victory:
mov ah,3
mov bh,0
int 10h
mov cx,000ah
mov bp,victory_msg
mov ax,1301h
mov bx,000eh
int 10h
jmp postpre

postpre:
mov ax,0
int 16h
jmp mine_init

cnt db 100,0
mark_char db "X"
fail_msg db "BOOM!",13,10
victory_msg db "VICTORY!",13,10
times 440-($-$$) db 0
times 70 db 0
db 0x55,0xaa