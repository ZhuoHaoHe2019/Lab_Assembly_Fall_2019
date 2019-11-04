assume cs:code

code segment

start:
;main faction
    mov ax,2
NEXT:
    mov cx,ax
    mov bx,2
    ;ax是被除数 1~10000
    ;bx是除数
s:  
    mov ax,cx
    cmp bx,ax   ;bx是否等于ax
    jz L2       ;如果等于则转到L2
    mov dx,0    ;把dx清空
    div bx      ;ax除以bx，ax存商，dx存余数
    cmp dx,0    ;bx是否整除dx
    jz L1       ;如果整除则转到L1
    inc bx      ;bx++
    cmp bx,101  ;如果bx到100还没有整除ax
    jz L2       ;转到L2，即ax是素数
    jmp s       ;跳到s，进行循环
L1:
    mov ax,cx   ;把cx赋值给ax,cx中存放的是原来的ax，即被除数
    cmp ax,10000;判断是否到达一万
    jz L7       ;如果到达一万则进行收尾工作L7
    inc ax      ;没达到一万就ax++
    jmp NEXT    ;回到主语句
L2:;输出素数（先行判断，确定ax的范围）
    mov ax,cx
    cmp ax,1000
    jnb L3      ;若ax>=1000则转L3
    cmp ax,100
    jnb L4      ;若100<=ax<1000则转L4
    cmp ax,10
    jnb L5      ;若10<=ax<100则转L5
    jmp L6      ;若ax<10则转L6
L3: ;ax>=1000
    mov dx,0
    mov bx,1000
    div bx      ;ax除以1000，商ax余dx
    mov bx,dx   ;把余数存放在bx中
    mov dl,al
    add dl,30H  ;输出空格
    mov ah,2H
    int 21H     ;输出千位数
    mov ax,bx   ;余数转移到ax中
L4: ;100<ax<=1000
    mov bl,100  
    div bl      ;al除以100
    mov bl,ah   ;余数ah存放在bl中
    mov dl,al   ;商al存放在dl中
    add dl,30H
    mov ah,2H
    int 21H     ;输出百位数dl
    mov al,bl   ;余数转移到al中
    mov ah,0
L5:  ;10<ax<=100
    mov bl,10   
    div bl      ;bl除以10
    mov bl,ah   ;余数ah存放在bl中
    mov dl,al   ;商al存放在dl中
    add dl,30H
    mov ah,2H   
    int 21H     ;输出十位数dl
    mov al,bl   ;余数转移到al中
    mov ah,0    ;ax高位清零
L6:  ;ax<10
    mov dl,al   
    add dl,30H
    mov ah,2H
    int 21H     ;输出个位数dl

    mov dl,20H  
    mov ah,2H
    int 21H     ;输出空格
    jmp L1      ;转到L1
L7:
    mov ax,4c00H
    int 21H
code ends

end start