; DO NOT MODIFY THIS FILE
; BUT FEEL FREE TO STUDY HOW IT WORKS
; AND TO USE IT TO TEST YOUR SUBROUTINES
        B main

; Our board 
; 0-7 represents a  letter  on the board
; Each letter appears twice

board   DEFW    0, 0, 0, 0
        DEFW    0, 0, 0, 0
        DEFW    0, 0, 0, 0
        DEFW    0, 0, 0, 0

prompt  DEFB "Enter square to reveal: ",0
already DEFB "That square has already been revealed...\n", 0
fndPair DEFB "You've found a match\n",0
noMatch DEFB "No match found\n",0
winMsg  DEFB "You successfully found all the pairs...\n",0
anyKey  DEFB "Press any key to continue...\n",0

        ALIGN
main    MOV R13, #0x10000
        ADR R0, board 
        MOV R1,#0
        MOV R4, #15
fl      STR R1, [R0, R4 LSL #2]
        SUB R4, R4, #1
        CMP R4, #0
        BGE fl
        BL generateBoard

        ADR R5, board
        MOV R4, #8
mLoop   BL cls
        MOV     R1, #-1
        MOV     R2, #-1
        MOV     R0,R5
        BL      printMaskedBoard
        MOV     R0, #10
        SWI     0
        SWI     0
reread  ADR     R0, prompt
        BL      boardSquareInput
        MOV     R6,R0
        LDR     R0, [R5, R6 LSL #2]

        CMP     R0, #-1
        BNE     processSquare
        MOV     R0, #10
        SWI     0

        ADRL    R0, already
        SWI     3
        B       reread
processSquare
        BL      cls
        MOV     R0,R5
        MOV     R1,R6
        MOV     R2,#-1
        BL      printMaskedBoard

        MOV     R0, #10
        SWI     0
        SWI     0

sndReRead
        ADR     R0, prompt
        BL      boardSquareInput
        MOV     R7, R0

        LDR     R0, [R5, R7 LSL #2]
        CMP     R0, #-1
        BNE     processSecondSquare
        MOV     R0, #10
        SWI     0

        ADRL    R0, already
        SWI     3
        B       reread

processSecondSquare
        BL      cls

        MOV     R0,R5
        MOV     R1,R6
        MOV     R2,R7
        BL      printMaskedBoard

        LDR     R0, [R5, R6 LSL #2]
        LDR     R1, [R5, R7 LSL #2]

        CMP     R0,R1
        BNE     notMatch

        ADRL     R0, fndPair
        SWI     3

        MOV     R0,#-1
        STR     R0, [R5, R6 LSL #2]
        STR     R0, [R5, R7 LSL #2]

        SUB     R4,R4,#1

        B       endMatchIf
notMatch
        ADRL     R0, noMatch
        SWI     3

endMatchIf

        ADRL     R0, anyKey
        SWI     3
        SWI     1


        CMP     R4,#0
        BGT     mLoop

win     ADRL R0, winMsg
        SWI 3
        SWI 2

;; cls : Clear the screen
cls     MOV R1,#20*40
        MOV R0,#8
clsLoop SWI 0
        SUBS R1,R1,#1
        BGE clsLoop
        MOV PC,R14

        ALIGN
; boardSquareInput
        include boardSquareInput.s
        ALIGN
        SWI 2

;        ALIGN
; printMaskedBoard
;        include printMaskedBoard.s
;        ALIGN
;        SWI 2

        ALIGN
; generateBoard -- which includes printMaskedBoard
        include generateBoard.s
        ALIGN
        SWI 2