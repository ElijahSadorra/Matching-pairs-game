        B test_printBoard

; Our board 
; 0-7 represents a  letter  on the board
; Each letter appears twice

sampleBoard	DEFW 	3, 1, 4, 7, 5, 1, 7, 6, 6, 0, 2, 5, 0, 4, 2, 3
space       DEFW  32
newline     DEFB "\n", 0

        ALIGN
test_printBoard    
        ADR R0, sampleBoard 
        BL printBoard
        SWI 2

; printBoard -- print the board 
; Input: R0 <-- Address of board
printBoard
; Insert your implementation here
        MOV R1, R0
        MOV R2, #1
        MOV R3, #0
        ADR R0, space
        SWI 3
        B loop1
whileloop
        ADR R0, space
        SWI 3
        SWI 3
        MOV R0, R2
        SWI 4
        ADD R2, R2, #1
loop1   CMP R2, #5
        BNE whileloop
        ADR R0, space
        SWI 3
        SWI 3
        ADR R0, newline
        SWI 3
        SWI 3
        MOV R0, #2
        MOV R2, #0
        B loop2
whileloop2
        ADD R0, R2, #65
        SWI 0
        B inloop
whileinloop
        ADR R0, space
        SWI 3
        SWI 3
        MOV R0, #4
        MUL R0, R2, R0
        ADD R0, R0, R3
        LDR R0, [R1, R0, LSL #2]
        ADD R0, R0, #65
        SWI 0
        ADD R3, R3, #1
inloop  CMP R3, #4
        BNE whileinloop
        ADR R0, newline
        SWI 3
        SWI 3
        ADD R2, R2, #1
        MOV R3, #0
loop2   CMP R2, #4
        BNE whileloop2
        MOV PC, R14