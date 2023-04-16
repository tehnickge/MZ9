    section .data

    section .bss
        OutBuf  resb    10
        matrix  resw    49
        sum     resw    1
        lenres  resd    1

    section .text
global  _start
_start:
    lea ebx, [matrix]
    mov ecx, 28
    mov eax, 0

cyl1:
        ; push counts in matrix 1...49
        mov     [EBX],  eax
        inc     eax
        add     ebx,    2 ; i++
        loop    cy1 

; возращаем в ebx, указатель на 1 элемент в матрице.
lea [ebx],  [matrix]  

mov ecx, 4 ; 4 - string.size()
mov dx, 0
mov sum, dx
string:
        push    ecx,
        mov     ecx,     6
        push    ebx

        mov     ax,     [ebx]
        push    ax              ; сохраням значение 
        mov     bl,     3
        idiv    bl
        cmp     ah,     0
        je sum
        pop     ax
        jmp column 

sum:
        pop     ax
        add     word [sum], ax

column:
        mov     ax,     [ebx + 2]
        push    ax
        mov     bl,     3
        idiv    bl
        cmp     ah,     0
        je sum
        pop     ax
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

        add ebx, 2Ы
        pop ecx
        loop mat

exit:
        ; exit
        mov     eax, 1
        xor     ebx, ebx
        int     80h

%include "lib.asm"
