section .data ;Секция инициализированных данных
    InputJMsg db "Enter J number: "
    lenInputJ equ $-InputJMsg
    InputAMsg db "Enter A number: "
    lenInputA equ $-InputAMsg
    InputKMsg db "Enter K number: "
    lenInputK equ $-InputKMsg
    razd db 0xa
    ResMsg db "Calculation result: "
    lenRes equ $-ResMsg
section .bss ;Секция неинициализированных данных
    J resw 1
    A resw 1
    K resw 1
    F resw 1
    InBuf resb 6
    lenIn equ $-InBuf
    OutBuf resb 6
    lenOut equ $-OutBuf
    section .text ;Секция кода
global _start
_start:
    ;Вывод сообщения об вводе числа Q
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout = 1
    mov rsi, InputJMsg ; адрес выводимой строки
    mov rdx, lenInputJ ; длина строки
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
    mov [J], ax ;Записали J

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

    ;Вывод сообщения об вводе числа K
    mov rax, 1
    mov rdi, 1
    mov rsi, InputKMsg
    mov rdx, lenInputK
    syscall
    ;Считываем введенную переменную K
    mov rax, 0
    mov rdi, 0
    mov esi, InBuf
    mov rdx, lenIn
    syscall
    call StrToInt64
    cmp EBX, 0
    jne StrToInt64.Error
    mov [K], ax ;Записали K
    
    ;Блок вычислений
    mov ax, [J]
    cmp ax, 3
    ja L1
    mov ax, 8
    mov [F], ax
    jmp L2
L1:
    mov ax, [A]
    mov dx, [J]
    imul ax, dx     ;A*J 
    mov cx, ax      ;CX = A*J
    mov ax, [J]
    imul ax, ax     ;J^2
    mov bl, [K]     
    idiv bl         ; j^2 / 2 
    mov ah, 0
    sub ax, cx
    mov [F], ax
L2:
    mov [F],ax
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
