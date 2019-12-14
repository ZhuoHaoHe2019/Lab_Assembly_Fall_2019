.model small
.386

.code
;计算斐波那契数列

start:
    mov ax,2000H
    mov ds,ax

    mov eax,1
    ;输入想要计算的位数

    mov cx,40

    mov edx,0
s:  
    ;eax入栈，并调用fibo函数
    push eax
    call fibo
    ;调用打印输出函数
    call printf

    ;eax出栈
    pop eax
    ;eax = eax + 1
    inc eax
    ;循环，计算下一位斐波那契数
    loop s


    mov ax,4c00H
    int 21H

fibo:
;    if(eax == 1 || eax == 2)
;       {
;           eax = 1
;           return ;              
;       }

    cmp eax,1
    je _get_out
    cmp eax,2
    je _get_out

;增加48位加法
;-------------------------------------------------------------

;   把eax,ebx,ecx入栈，防止干扰
    push ebx
    push ecx
    push edx

;开始计算斐波那契数 递归
    push eax
;   把eax入栈保存

;   ebx = eax = fibo(n-1)    
    sub eax,1
    call fibo
    mov ebx,eax
;   fibo(n-1) 高位edx
;   fibo(n-1) 低位eax->edx

;   eax出栈准备调用
    pop eax
;   fibo(n-1) 高位edx保存
    push edx

;   ecx = eax = fibo(n-2)
    sub eax,2
    call fibo
    mov ecx,eax
;   fibo(n-2) 高位edx
;   fibo(n-2) 低位eax

;   fibo(n-1)低位 ebx->eax
    mov eax,ebx
;   fibo(n-1)高位 edx->(pop) ebx
    pop ebx

;   fibo(n) = fibo(n-1) + fibo(n-2)
;   低位加低位，高位加高位 
    add eax,ecx
    adc edx,ebx


;-------------------------------------------------------------
;把斐波那契数存放在内存中


    pop edx
    pop ecx
    pop ebx
;返回函数
    ret

    
_get_out:
    mov eax,1
    ret

; ---------------------------------------------------------------
printf:
;eax<=‭      4294967296
; 47    2971215073
    ;若10,000,000,000<ax<=100,000,000,000则转pt12
    cmp edx,1
    jnb pt12
    ;若1000000000<=ax<=10000000000则转pt11
    cmp eax,1000000000
    jnb pt11
    ; 36 ->  14930352
    ;若100000000<=ax<=1000000000则转pt10
    cmp eax,100000000
    jnb pt10
    ;若10000000<=ax<=100000000则转pt9
    cmp eax,10000000
    jnb pt9
    ;若1000000<=ax<=10000000则转pt8
    cmp eax,1000000
    jnb pt8
    ;若100000<=ax<=1000000则转pt7 
    cmp eax,100000
    jnb pt7
    ;若10000<=ax<=100000则转pt6 
    cmp eax,10000
    jnb pt6    
    ;若1000<=ax<=10000则转pt5 
    cmp ax,1000
    jnb pt5      
    ;若100<=ax<1000则转pt4
    cmp ax,100
    jnb pt4    
    ;若10<=ax<100则转pt3  
    cmp ax,10
    jnb pt3      
    jmp pt2  

; --------------------------------------------------------------------------
pt12:
    mov dl,al   
    add dl,30H
    mov ah,2H
    int 21H
    jmp pt11
;1,000,000,000<ax<=10,000,000,000
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
;100,000,000<ax<=1,000,000,000
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
    div ebx      
    mov ebx,edx  
    mov dl,al
    add dl,30H  
    mov ah,2H
    int 21H     ;输出千位数
    mov eax,ebx
;100<ax<=1000
pt4:
    mov bl,100  
    div bl      
    mov bl,ah   
    mov dl,al   
    add dl,30H
    mov ah,2H
    int 21H     ;输出百位数dl
    mov al,bl   ;余数转移到al中
    mov ah,0
;10<ax<=100
pt3:
    mov bl,10   
    div bl      
    mov bl,ah   
    mov dl,al   
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