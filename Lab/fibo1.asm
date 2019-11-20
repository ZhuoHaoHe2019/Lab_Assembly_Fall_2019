.model small
.386

.code

start:
    mov ax,10
    mov cx,10
s:  
    push ax
    call fibo
;10<ax<=100
    mov bl,10   
    div bl      ;bl除以10
    mov bl,ah   ;余数ah存放在bl中
    mov dl,al   ;商al存放在dl中
    add dl,30H
    mov ah,2H   
    int 21H     ;输出十位数dl
    mov al,bl   ;余数转移到al中
    mov ah,0 
;ax<10
    mov dl,al   
    add dl,30H
    mov ah,2H
    int 21H
;空格
    mov dl,20H  
    mov ah,2H
    int 21H

    pop ax
    sub ax,1
    loop s


    mov ax,4c00H
    int 21H

fibo:
    cmp ax,1
    je _get_out
    cmp ax,2
    je _get_out

    ;todo:如果 ax == 1,则直接跳出函数，返回
    push bx
    push cx
    push dx

    mov dx,ax  
    sub ax,1
    call fibo
    mov bx,ax

    mov ax,dx
    sub ax,2
    call fibo
    mov cx,ax

    mov ax,bx
    add ax,cx

    pop dx
    pop cx
    pop bx

    ret

    
_get_out:
    mov ax,1
    ret


    


;todo:需要直接返回到上一层，即直接返回fibo(1)和fibo(2)的值，而不需要再执行接下来的操作

end start