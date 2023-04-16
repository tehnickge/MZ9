 section .data
        three   dw      3

section .bss
        OutBuf  resb    10
        matrix  resw    28
        summ    resw    1
        lenres  resd    1

    section .text
global  _start
_start:
    lea EBX, [matrix]
    mov ecx, 28
    mov eax, 0

cyl1:
        ; push counts in matrix 0...27
        mov     [EBX],  eax
        inc     eax
        add     ebx,    2 ; i++
        loop    cyl1 

; возращаем в ebx, указатель на 1 элемент в матрице.
lea EBX,  [matrix]  

mov ecx, 4 ; 4 - string.size()
mov word [summ], 0
mov eax, 0
string:
        push    ecx
        mov     ecx,     7
        push    ebx
        jmp column 

column:
        mov     ax,   [ebx]
        push    ax
        cwd             ;dx:ax
        idiv    word [three] 
        cmp     dx,     0
        je sum
        pop     ax
        jmp next
sum:
        pop     ax
        add     word [summ], ax
next:
        add     ebx,    2
loop column

        pop     ebx
        pop     ecx
        add     ebx,    14
loop string

lea     ebx,    [matrix]

mov ecx, 28
mov eax, 0
mat:
        push ecx
        mov eax, [ebx]  ; загрузка числа в регистр
        mov esi, OutBuf ; загрузка адреса буфера вывода
        call IntToStr

        mov dword [lenres], eax

        push ebx
        mov eax, 4
        mov ebx, 1      ; дескриптор файла stdout=1
        mov ecx, esi    ; адрес выводимой строки
        mov edx, [lenres]    ; длина выводимой строки
        int 80h         ; вызов системной функции
        pop ebx

        add ebx, 2
        pop ecx
        loop mat


    mov eax, [summ]
    mov esi, OutBuf
    call IntToStr
    mov dword [lenres], eax
    mov eax, 4
    mov ebx, 1
    mov ecx , esi
    mov edx, [lenres]
    int 80h

exit:
        ; exit
        mov     eax, 1
        xor     ebx, ebx
        int     80h

%include "lib.asm"
