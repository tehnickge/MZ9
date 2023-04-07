section .data ;Секция инициализированных данных
    InputQMsg db "Enter Q number: "
    lenInputQ equ $-InputQMsg
    InputAMsg db "Enter A number: "
    lenInputA equ $-InputAMsg
    razd db 0xa
    ResMsg db "Calculation result: "
    lenRes equ $-ResMsg
section .bss ;Секция неинициализированных данных
    Q resw 1
    A resw 1
    F resw 1
    AQ resw 1
    InBuf resb 6
    lenIn equ $-InBuf
    OutBuf resb 4
    lenOut equ $-OutBuf
    section .text ;Секция кода
global _start
_start:
    ;Вывод сообщения об вводе числа Q
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout = 1
    mov rsi, InputQMsg ; адрес выводимой строки
    mov rdx, lenInputQ ; длина строки
    syscall ; вызов системной функции
    ; Считываем введенную переменную Q
    mov rax, 0 ; системная функция 0 (read)
    mov rdi, 0 ; дескриптор файла stdin = 0
    mov esi, InBuf ; адрес вводимой строки
    mov rdx, lenIn ; длина строки
    syscall
    call StrToInt64
    cmp EBX, 0
    jne StrToInt64.Error
    mov [Q], ax ;Записали Q

    ;Вывод сообщения об вводе числа A
    mov rax, 1
    mov rdi, 1
    mov rsi, InputAMsg
    mov rdx, lenInputA
    syscall
    ;Считываем введенную переменную A
    mov rax, 0
    mov rdi, 0
    mov esi, InBuf
    mov rdx, lenIn
    syscall
    call StrToInt64
    cmp EBX, 0
    jne StrToInt64.Error
    mov [A], ax ;Записали A
    
    ;Блок вычислений
    mov dx, [Q]
    mov ax, [Q]     ;ax = Q
    imul ax, ax     ;ax * ax
    imul ax, dx     ;ax * Q (a^a )
    mov [F], ax     ;F = ax(Q^3)
    mov ax, [A]     ;ax = A
    imul ax, ax     ;A^2
    mov bl, [Q]
    cwd
    idiv bl
    mov [AQ], al    ; a^2 / q
    mov ax, [Q]
    mov dx, [A]
    imul ax, dx
    mov cx, 2
    imul ax, cx      ; 2 * q * a
    mov dx, [F]      ; 2 * q * a
    sub dx, ax       ; q^3 - 2 * q * a
    add dx, [AQ]     ; q^3 - 2 * q * a + a^2 / 2
    mov [F], dx
    syscall

    ;Блок вывода сообщения о результате
    mov rax, 1
    mov rdi, 1
    mov rsi, ResMsg
    mov rdx, lenRes
    syscall
    ; Блок вывода самого результата
    mov esi, OutBuf
    mov ax, [F]
    cwde
    call IntToStr64
    mov rax, 1
    mov rdi, 1
    mov rsi, OutBuf
    mov rdx, lenOut
    syscall
    ;Завершение работы программы
    mov rax, 60
    xor rdi, rdi
    syscall    
%include "lib64.asm"
