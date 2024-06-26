printString MACRO p
lea dx,p 
mov ah,9 
int 21h    
ENDM


printGraphicsStr MACRO str
    mov ah,06h ;scroll window up
    mov al,1  ;store value 1 in al register
    mov bh,10110100b ;set color
    mov ch,0 ;set top row of window
    mov cl,0 ;set left most colum of window
    mov dh,25 ; set bottom row of window
    mov dl,25 ; set right most column of window
    mov dx,184fh ; set dx rgister to video memory
    int 10h ; interrupt for graphics
    printString str
    call enterkey
ENDM



dosseg
.model small
.stack 100h
.data
;;this is only string that are only print int terminal
gameTitle db '                          Tic Tac Toe game !$'
init00 db "     The first user is 'X' and second user is 'Y' or Vice Versa$"
init01 db "    If you want to stop the Game then enter '#' in place of symbol$"



wrongIndex1 db 'The user already exist$'
wrongLetter db 'please input correct symbol$'
wrongIndex db 'Index Error: $'
invalidIndex db 'Invalid Index'



printSymbol db 'enter symbol: $' 
printPlace db 'enter place: $'



tempArray0 db '0,1,2$'
tempArray1 db '3,4,5$'
tempArray2 db '6,7,8$'



place db 0
symbol db ?

winner db 'The Winner is: $'
draw db 'The match is drawn$'



array db '___'
X db 'X'
Y db 'Y'

.code
;description
main PROC
    
    ;;declare data segment
    mov ax,@data
    mov ds,ax

    ;;;game starting


    ;printitng some strings
    call startingTitle
   


    ;print temporary Array
    printString tempArray0
    call enterkey
    printString tempArray1
    call enterkey  
    printString tempArray2
    call enterkey
    call enterkey


   



mainLoop:    ;;main method
;;taking place and user symbol
    again:
    printString printPlace

    call input
    sub al,48
    mov place,al
    call enterkey

    printString printSymbol
    call input
    mov symbol,al
    call enterkey




    mov si,0
    mov dl,place
    cbw    ;convert byte to word
    add si,dx
    mov dl,symbol

    ifGameIsShutDown:
        cmp dl,35
        je gameClose
        jmp checkingIfUserAlreadyExist
            gameClose:
                jmp endGame
    checkingIfUserAlreadyExist:
        mov dl,array[si]
        cmp dl,88
        je userExist
        cmp dl,89
        je userExist
        
        jmp checkingIfUserSymbolIsWrong
            userExist:
                printString wrongIndex
                printString wrongIndex1
                call enterkey
                call enterkey

                jmp again
    checkingIfUserSymbolIsWrong:
        mov dl,symbol
        cmp dl,88     ;compares with the immediate value 88 which correspond to character 'X'
        jl wrongSymbol
        cmp dl,89      
        jg wrongSymbol
        jmp checkingIfIndexIsGreaterThan8
            wrongSymbol:
                printString wrongLetter
                call enterkey
                call enterkey

                jmp again
    checkingIfIndexIsGreaterThan8:
        mov dl,place
        cmp dl,8
        jg  invalidI
        cmp dl,0
        jl invalidI
        jmp next 
            invalidI:
                printString wrongIndex
                printString invalidIndex
                call enterkey
                call enterkey
                printString tempArray0
                call enterkey
                printString tempArray1
                call enterkey
                printString tempArray2
                call enterkey

                jmp again


        

        next:
           mov si,0
        mov dl,place
        cbw   ;convert byte to word
        add si,dx
        mov dl,symbol
        mov array[si], dl
        call enterkey
        call enterkey  


        call printArray
        call enterkey
        call enterkey
     


    ;;checking ROW WISE 
    mov al,88
    condition01:
        mov si,0
        mov dl,array[si]
        cmp dl,al
        je cond01
        jmp condition02
            cond01:
            mov si,1
            mov dl,array[si]
            cmp dl,al
            je cond02
            jmp condition02
        
                cond02:
                mov si,2
                mov dl,array[si]
                cmp dl,al
                je gameEnd
                jmp condition02
    condition02:
        mov si,3
        mov dl,array[si]
        cmp dl,al
        je cond11
        jmp condition03
            cond11:
                mov si,4
                mov dl,array[si]
                cmp dl,al
                je cond12
                jmp condition03
                cond12:
                    mov si,5
                    mov dl,array[si]
                    cmp dl,al
                    je gameEnd
                    jmp condition03
    
    condition03:
        mov si,6
        mov dl,array[si]
        cmp dl,al
        je cond21
        jmp condition04
            cond21:
                mov si,7
                mov dl,array[si]
                cmp dl,al
                je cond22
                jmp condition04
                cond22:
                    mov si,8
                    mov dl,array[si]
                    cmp dl,al
                    je gameEnd
                    jmp condition04

    gameEnd:
    jmp gameEnd1

    ;checking DIAGONAL WISE
    condition04:
    mov si,0
    mov dl,array[si]
    cmp dl,al
    je cond31
    jmp condition05
        cond31:
        mov si,4
        mov dl,array[si]
        cmp dl,al
        je cond32
        jmp condition05
            cond32:
                mov si,8
                mov dl,array[si]
                cmp dl,al
                je gameEnd1
                jmp condition05
    
    condition05:
    mov si,2
    mov dl,array[si]
    cmp dl,al
    je cond41
    jmp condition06
        cond41:
            mov si,4
            mov dl,array[si]
            cmp dl,al
            je cond42
            jmp condition06
            cond42:
                mov si,6
                mov dl,array[si]
                cmp dl,al
                je  gameEnd1
                jmp condition06
    
      gameEnd1:
    jmp gameEnd2
    ;;checking column wise
    condition06:
    mov si,0
    mov dl,array[si]
    cmp dl,al
    je cond51
    jmp condition07
    cond51:
        mov si,3
        mov dl,array[si]
        cmp dl,al
        je cond52
        jmp condition07
        cond52:
            mov si,6
            mov dl,array[si]
            cmp dl,al
            je gameEnd2
            jmp condition07
    
    condition07:
    mov si,1
    mov dl,array[si]
    cmp dl,al
    je cond61
    jmp condition08
    cond61:
        mov si,4
        mov dl,array[si]
        cmp dl,al
        je cond62
        jmp condition08
        cond62:
            mov si,7
            mov dl,array[si]
            cmp dl,al
            je gameEnd2
            jmp condition08
    

    condition08:
    mov si,2
    mov dl,array[si]
    cmp dl,al
    je cond71
    jmp condition09
    cond71:
        mov si,5
        mov dl,array[si]
        cmp dl,al
        je cond72
        jmp condition09
        cond72:
            mov si,8
            mov dl,array[si]
            cmp dl,al
            je gameEnd2
            jmp condition09
    

    ;;;;checking for Y
    ;;checking ROWS WISE
gameEnd2:
jmp gameEnd3
    
  
    condition09:
      mov al,89
        mov si,0
        mov dl,array[si]
        cmp dl,al
        je cond81
        jmp condition10
            cond81:
            mov si,1
            mov dl,array[si]
            cmp dl,al
            je cond82
            jmp condition10
        
                cond82:
                mov si,2
                mov dl,array[si]
                cmp dl,al
                je gameEnd3
                jmp condition10
    condition10:
        mov si,3
        mov dl,array[si]
        cmp dl,al
        je cond91
        jmp condition11
            cond91:
                mov si,4
                mov dl,array[si]
                cmp dl,al
                je cond102
                jmp condition11
                cond102:
                    mov si,5
                    mov dl,array[si]
                    cmp dl,al
                    je gameEnd3
                    jmp condition11
    
    condition11:
        mov si,6
        mov dl,array[si]
        cmp dl,al
        je cond111
        jmp condition12
            cond111:
                mov si,7
                mov dl,array[si]
                cmp dl,al
                je cond112
                jmp condition12
                cond112:
                    mov si,8
                    mov dl,array[si]
                    cmp dl,al
                    je gameEnd3
                    jmp condition12

    gameEnd3:
    jmp gameEnd4

    ;checking DIAGONAL WISE
    condition12:
    mov si,0
    mov dl,array[si]
    cmp dl,al
    je cond121
    jmp condition13
        cond121:
        mov si,4
        mov dl,array[si]
        cmp dl,al
        je cond122
        jmp condition13
            cond122:
                mov si,8
                mov dl,array[si]
                cmp dl,al
                je gameEnd4
                jmp condition13
    
    condition13:
    mov si,2
    mov dl,array[si]
    cmp dl,al
    je cond131
    jmp condition14
        cond131:
            mov si,4
            mov dl,array[si]
            cmp dl,al
            je cond132
            jmp condition14
            cond132:
                mov si,6
                mov dl,array[si]
                cmp dl,al
                je  gameEnd4
                jmp condition14
    
    gameEnd4:
    jmp gameEnd5
    ;;checking column wise
    condition14:
    mov si,0
    mov dl,array[si]
    cmp dl,al
    je cond141
    jmp condition15
    cond141:
        mov si,3
        mov dl,array[si]
        cmp dl,al
        je cond142
        jmp condition15
        cond142:
            mov si,6
            mov dl,array[si]
            cmp dl,al
            je gameEnd5
            jmp condition15
    
    condition15:
    mov si,1
    mov dl,array[si]
    cmp dl,al
    je cond151
    jmp condition16
    cond151:
        mov si,4
        mov dl,array[si]
        cmp dl,al
        je cond152
        jmp condition16
        cond152:
            mov si,7
            mov dl,array[si]
            cmp dl,al
            je gameEnd5
            jmp condition16
    
  gameEnd5:
    jmp gameEnd6

    condition16:
    mov si,2
    mov dl,array[si]
    cmp dl,al
    je cond161
    jmp checkingIfAllPlacesFull
    cond161:
        mov si,5
        mov dl,array[si]
        cmp dl,al
        je cond162
        jmp checkingIfAllPlacesFull
        cond162:
            mov si,8
            mov dl,array[si]
            cmp dl,al
            je gameEnd6
            jmp checkingIfAllPlacesFull
    checkingIfAllPlacesFull:
    mov cx,9
    mov si,0
        lp:
        mov dl,array[si]
        cmp dl,'_'
        jne nextt
        jmp mainLoop
        nextt:
        inc si
        loop lp
    printGraphicsStr draw
    call enterkey
    call enterkey
    

    jmp endGame
    

gameEnd6:
printString winner
mov dl,al
call printDX


endGame:    


mov ah,4ch
int 21h
main ENDP
 

 ;description
 enterkey PROC
    mov dx,10
    mov ah,2
    int 21h
    mov dx,13
    mov ah,2
    int 21h
    ret  ;end of subroutine
 enterkey ENDP

 ;description
 printDX PROC
    mov ah,2
    int 21h
    ret
 printDX ENDP

 ;description
 input PROC
    mov ah,1
    int 21h
    ret
 input ENDP

 ;description
 printArray PROC
    mov cx,3
    mov si,0
    lp1:
    push cx
    mov cx,3
    lp2:
        mov dl,array[si]
        call printDX
        mov dl,','
        call printDX
        inc si
        loop lp2
    call enterkey
    pop cx
    loop lp1
ret
 printArray ENDP
 ;description
startingTitle PROC
     mov ah,6
    mov al,3
    mov bh,10011101b
    mov ch,0
    mov cl,0
    mov dh,25
    mov dl,25
    mov dx,184fh
    int 10h
    printString gameTitle
    call enterkey

    mov ah,6
    mov al,1
    mov bh,00110100b
    mov ch,0
    mov cl,0
    mov dh,25
    mov dl,25
    mov dx,184fh
    int 10h
    printString init00
    call enterkey

    mov ah,6
    mov al,1
    mov bh,00110100b
    mov ch,0
    mov cl,0
    mov dh,25
    mov dl,25
    mov dx,184fh
    int 10h
    printString init01
    call enterkey
    call enterkey
    call enterkey
    call enterkey
    call enterkey
    call enterkey
    call enterkey
    call enterkey
    call enterkey
    call enterkey
    call enterkey

ret

startingTitle ENDP
end main