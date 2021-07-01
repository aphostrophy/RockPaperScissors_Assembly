    SYS_EXIT  equ 1
    SYS_READ  equ 3
    SYS_WRITE equ 4
    STDIN     equ 0
    STDOUT    equ 1

global _start

section .bss
    name resb 16
    name_len resb 1
    choice resb 1
    choice2 resb 1
    time resb 32

section .data
    message: db "Rock Paper Scissors Game Made Using Assembly!",0xA
    lenmessage equ $-message
    message2: db "Instruction: 1 = ROCK, 2=PAPER, 3=SCISSORS",0xA
    lenmessage2 equ $-message2

    helloMsg : db "Hello "
    lenHelloMsg equ $-helloMsg

    helloSuffixMsg: db " ,you should go first and our bot will generate a random choice of its own!",0xA
    lenHelloSuffixMsg equ $-helloSuffixMsg

    rock: db "ROCK",0xA
    paper : db "PAPER",0xA
    scissors : db "SCISSORS",0xA

    semicolon: db ":"
    newline : db 0xA

section .text
_start:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, message
    mov edx, lenmessage
    int 0x80

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, message2
    mov edx, lenmessage2
    int 0x80

    call _getName

    call _printInstruction

    call _printName
    call _printSemiColon

    mov eax,SYS_READ
    mov ebx,STDIN
    mov ecx,choice
    mov edx,1
    int 0x80

    mov eax,[choice]
    sub eax,'0'

    cmp eax,1
    je printRock
    cmp eax,2
    je printPaper
    cmp eax,3
    je printScissors

    printRock:
        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, rock
        mov edx, 4
        int 0x80
        call _printNewline
        jmp nextPlayer

    printPaper:
        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, paper
        mov edx, 5
        int 0x80
        call _printNewline
        jmp nextPlayer

    printScissors:
        mov eax,SYS_WRITE
        mov ebx,STDOUT
        mov ecx,scissors
        mov edx,8
        int 0x80
        call _printNewline
        jmp nextPlayer

    nextPlayer:
        call _generateRandomNum


    ; Exit Program
    mov eax,SYS_EXIT
    mov ebx,0x0
    int 0x80

_getName:
    mov eax,SYS_READ
    mov ebx,STDIN
    mov ecx,name
    mov edx,16
    int 0x80

    mov [name_len],eax

    ret

_printName:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, name
    mov edx, [name_len]
    dec edx
    int 0x80

    ret

_printSemiColon:
    mov eax,SYS_WRITE
    mov ebx,STDOUT
    mov ecx, semicolon
    mov edx, 1
    int 0x80

    ret

_printNewline:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, newline
    mov edx, 1
    int 0x80

    ret

_printInstruction:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, helloMsg
    mov edx, lenHelloMsg
    int 0x80

    call _printName

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, helloSuffixMsg
    mov edx, lenHelloSuffixMsg
    int 0x80

    ret

_generateRandomNum:
    mov eax, 355
    mov ebx, time      
    mov ecx, 4
    mov edx, 0      
    int 0x80

    mov al,[time]
    cbw
    mov bl,3
    idiv bl

    cmp ah,0
    je a
    cmp ah,-1
    je b
    cmp ah,1
    je b
    cmp ah,2
    je c
    cmp ah,-2
    je c

    else:
        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, semicolon
        mov edx, 1
        int 0x80

        call _printNewline

        jmp end

    a:
        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, rock
        mov edx, 4
        int 0x80

        call _printNewline

        jmp end

    b:
        mov eax, SYS_WRITE
        mov ebx, STDOUT
        mov ecx, paper
        mov edx, 5
        int 0x80

        call _printNewline

        jmp end

    c:
        mov eax,SYS_WRITE
        mov ebx,STDOUT
        mov ecx,scissors
        mov edx,8
        int 0x80

        call _printNewline

        jmp end

    end:        
        ret
