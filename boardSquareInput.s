        B test_BoardSquareInput

tprompt  DEFB "Enter square to reveal: ",0
tmesg    DEFB "You entered the index ",0
newline  DEFB "\n", 0

    ALIGN
test_BoardSquareInput
        ADR R0, tprompt
        BL boardSquareInput

        MOV R1, R0
        ADR R0, tmesg
        SWI 3
        MOV R0,R1
        SWI 4
        MOV R0,#10
        SWI 0
        SWI 2


; boardSquareInput -- read board position from keyboard
; Input:  R0 ---> prompt string address
; Ouptut: R0 <--- index

boardSquareInput
; Insert your implementation here
        MOV R1, #4
        MOV R2, #0
loop    ADR R0, tprompt
        SWI 3
again   SWI 1
        CMP R0, #10
        BEQ loopcond
        CMP R0, #65
        BLT num
        CMP R0, #90
        BGT lower
        SWI 0
        SUB R0, R0, #65
        MUL R2, R0, R1
        B again
lower   SWI 0
        SUB R0, R0, #97
        MUL R2, R0, R1
        B again
num     SUB R0, R0, #48
        SWI 4 
        SUB R0, R0, #1
        ADD R2, R2, R0
        B again 
loopcond
        CMP R2, #0
        BLT reset
        CMP R2, #15
        BGT reset
        ADR R0 , newline
        SWI 3
        MOV R0, R2
        MOV PC, R14

reset   MOV R2, #0
        ADR R0, newline
        SWI 3
        B loop