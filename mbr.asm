bits 16
org 0600h
jmp start
options db "1-4GSR",0dh,0ah
errdisk db "diskerr",0dh,0ah
bootdrv db 0
dap dd 00010010h,0,0,0
start:
cli
xor ax,ax
mov ss,ax
mov es,ax
mov sp,ax
mov ds,ax
mov cx,0200h
mov si,7c00h
mov di,0600h
rep movsb
jmp 0:begin
begin:
sti 
mov [bootdrv],dl
mov ax,3
int 10h
.before_menu:
call menu
jmp .before_menu
menu:
mov ah,3
mov bh,0
int 10h
mov cx,0008h
mov bp,options
mov ax,1301h
mov bl,0fh
int 10h
mov ax,0
int 16h
sub al,"0"
cmp al,4
jle partition
cmp al,37h
je gap
cmp al,43h
je shutdown
cmp al,42h
je reboot
jmp menu

shutdown:
mov ax,5301h
xor bx,bx
int 15h
mov ax,530eh
mov cx,0101h
int 15h
mov ax,5308h
mov bl,1
xor ch,ch
int 15h
mov ax,5307h
mov cl,3
int 15h
ret

reboot:
jmp 0xffff:0
ret

gap:
mov dword [dap+4],00007c00h
mov dword [dap+8],1
mov si,dap
mov ax,4201h
mov dl,[bootdrv]
int 13h
jmp 7c00h
ret

disk_err:
mov ah,3
mov bh,0
int 10h
mov cx,0009h
mov bp,errdisk
mov ax,1301h
mov bx,000ch
int 10h
ret

times 218-($-$$) db 0
times 6 db 0

partition:
;activate what we are booting
and byte [07beh],7fh
and byte [07ceh],7fh
and byte [07deh],7fh
and byte [07eeh],7fh
mov bx,07aeh
shl al,4
add bl,al
or byte [bx],80h
;write new mbr
mov dl,[bootdrv]
mov ax,4301h
mov dword [dap+4],00000600h
mov dword [dap+8],0
mov si,dap
int 13h
jc disk_err
;read pbr
mov dword [dap+4],00007c00h
mov si,bx
add si,8
mov di,dap+8
movsd
mov si,dap
mov ax,4201h
int 13h
jc disk_err
mov si,bx
jmp 7c00h
ret

times 440-($-$$) db 0
times 70 db 0
db 0x55,0xaa