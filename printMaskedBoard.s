        B test_printMaskedBoard

; Our board 
; 0-7 represents a  letter  on the board
; Each letter appears twice
; -1 represent a revealed square

tpmb_sampleBoard	
		DEFW 	-1, 1, 4, 7, 5, 1, 7, -1, 6, 0, 2, 5, 0, 4, 2, 3
space           DEFW  32
aster           DEFW  42
newsline        DEFB "\n", 0


		ALIGN
test_printMaskedBoard
		MOV 	R13, #0x10000
        ADR R0, tpmb_sampleBoard
        MOV R1, #13
        MOV R2, #12
        BL printMaskedBoard
        SWI 2

; printMaskedBoard -- print the board with only the squares visible in R1, R2
; Input: R0 <-- Address of board
;        R1 <-- first Square to reveal
;		 R2 <-- second Square to reveal

printMaskedBoard

;; Insert your solution here...
        STMFD R13!, {R4, R5, R6}
        MOV R4, R1
        MOV R5, R2
        MOV R6, #0
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
        ADR R0, newsline
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
        CMP R0, R4
        BEQ nice
        CMP R0, R5
        BNE skip1
nice    MOV R6, #1
skip1   LDR R0, [R1, R0, LSL #2]
        CMP R0, #-1
        BNE output
        ADR R0, space
        SWI 3
        B skip
output  CMP R6, #1
        BNE skip2
        ADD R0, R0, #65
        SWI 0
        B skip
skip2   ADR R0, aster
        SWI 3
skip    ADD R3, R3, #1
        MOV R6, #0
inloop  CMP R3, #4
        BNE whileinloop
        ADR R0, newsline
        SWI 3
        SWI 3
        ADD R2, R2, #1
        MOV R3, #0
loop2   CMP R2, #4
        BNE whileloop2
        LDMFD R13!, {R4, R5, R6}
        MOV PC, R14