.model small
.386

.code

start:
    mov eax,1
    mov cx,47
s:  
    push eax
    call fibo

    call printf

    pop eax
    inc eax

    loop s


    mov ax,4c00H
    int 21H

fibo:
    cmp eax,1
    je _get_out
    cmp eax,2
    je _get_out

    ;todo:如果 ax == 1,则直接跳出函数，返回
    push ebx
    push ecx
    push edx

    mov edx,eax  
    sub eax,1
    call fibo
    mov ebx,eax

    mov eax,edx
    sub eax,2
    call fibo
    mov ecx,eax

    mov eax,ebx
    add eax,ecx

    pop edx
    pop ecx
    pop ebx

    ret

    
_get_out:
    mov eax,1
    ret

printf:
;eax<=‭      4294967296
; 47    2971215073
    cmp eax,1000000000
    jnb pt11
    ; 36 ->  14930352
    cmp eax,100000000
    jnb pt10
    cmp eax,10000000
    jnb pt9
    cmp eax,1000000
    jnb pt8
    cmp eax,100000
    jnb pt7
    cmp eax,10000
    jnb pt6
    cmp ax,1000
    jnb pt5      ;若ax>=1000则转L3
    cmp ax,100
    jnb pt4      ;若100<=ax<1000则转L4
    cmp ax,10
    jnb pt3      ;若10<=ax<100则转L5
    jmp pt2  
;100,000,000<ax<=1,000,000,000\

; 35 ->  9,227,465
; 36 -> 14,930,352
; 
pt11:
    mov edx,0
    mov ebx,1000000000
    div ebx
    mov ebx,edx
    mov dl,al
    add dl,30H
    mov ah,2H
    int 21H
    mov eax,ebx
pt10:    
    mov edx,0
    mov ebx,100000000
    div ebx
    mov ebx,edx
    mov dl,al
    add dl,30H
    mov ah,2H
    int 21H
    mov eax,ebx
;10,000,000<ax<=100,000,000
pt9:    
    mov edx,0
    mov ebx,10000000
    div ebx
    mov ebx,edx
    mov dl,al
    add dl,30H
    mov ah,2H
    int 21H
    mov eax,ebx
; ;1,000,000<ax<=10,000,000
pt8:    
    mov edx,0
    mov ebx,1000000
    div ebx
    mov ebx,edx
    mov dl,al
    add dl,30H
    mov ah,2H
    int 21H
    mov eax,ebx

;修改了乱码问题

;100,000<ax<=1,000,000
pt7:    
    mov edx,0
    mov ebx,100000
    div ebx
    mov ebx,edx
    mov dl,al
    add dl,30H
    mov ah,2H
    int 21H
    mov eax,ebx
;10000<ax<=100000
pt6:    
    mov edx,0
    mov ebx,10000
    div ebx
    mov ebx,edx
    mov dl,al
    add dl,30H
    mov ah,2H
    int 21H
    mov eax,ebx
;1000<ax<=10000
pt5:    
    mov edx,0
    mov ebx,1000
    div ebx      ;ax除以1000，商ax余dx
    mov ebx,edx   ;把余数存放在bx中
    mov dl,al
    add dl,30H  ;输出空格
    mov ah,2H
    int 21H     ;输出千位数
    mov eax,ebx
;100<ax<=1000
pt4:
    mov bl,100  
    div bl      ;al除以100
    mov bl,ah   ;余数ah存放在bl中
    mov dl,al   ;商al存放在dl中
    add dl,30H
    mov ah,2H
    int 21H     ;输出百位数dl
    mov al,bl   ;余数转移到al中
    mov ah,0
;10<ax<=100
pt3:
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
pt2:   
    mov dl,al   
    add dl,30H
    mov ah,2H
    int 21H
;空格
pt1:
    mov dl,20H  
    mov ah,2H
    int 21H

    ret


;todo:需要直接返回到上一层，即直接返回fibo(1)和fibo(2)的值，而不需要再执行接下来的操作

end start