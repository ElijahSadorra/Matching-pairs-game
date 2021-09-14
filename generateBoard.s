        B test_generateBoard


; Our board 
; 0, represents an empty space
; 1-8 represents the number of bombs around us
; 66 represents there is a bomb at this location
; No more than 8 bombs
testGenboard   
        DEFW    0, 0, 0, 0
        DEFW    0, 0, 0, 0
        DEFW    0, 0, 0, 0
        DEFW    0, 0, 0, 0


        ALIGN
test_generateBoard
        MOV     R13, #0x10000
	ADR     R0, testGenboard 
        BL      generateBoard

        ADR     R0, testGenboard 
        MOV     R1,#15
        MOV     R2,#4
        BL      printMaskedBoard
        SWI     2


; generateBoard
; Input R0 -- array to generate board in
generateBoard
; Insert your implementation here
; Delete this code between the [snip]s and insert your implementation here
        STMFD R13!, {R4,R5, R6, R12}
        MOV R5, R0
        MOV R12, R14
        MOV R2, #0
        MOV R3, #0
        B forcond
forloop B innerforcond
innerloop
        MOV R4, R2
back    BL randu
        MOV R0, R0 ASR #8
        AND R0, R0, #0xf
        MOV R6, R0
        LDR R0, [R5, R6, LSL #2]
        CMP R0, #0
        BNE back
        STR R4, [R5, R6, LSL #2]
        ADD R3, R3, #1
        MOV R2, R4
innerforcond
        CMP R3, #2
        BNE innerloop
        MOV R3, #0
        ADD R2, R2, #1
forcond CMP R2, #8
        BNE forloop
        MOV R0, R12
        LDMFD R13!, {R4, R5, R6, R12}
        MOV PC, R0



; DO NOT CHANGE ANYTHING AFTER THIS POINT...
; randu -- Generates a random number
; Input: None
; Ouptut: R0 -> Random number
randu   LDR R2,mult
        MVN R1,#0x80000000
        LDR R0,seed
        MUL R0,R2,R0
        AND R0,R0,R1
        STR R0,seed
        MOV PC, R14

        ALIGN
seed    DEFW    0xC0FFEE
mult    DEFW    65539

        ALIGN
        include printMaskedBoard.s
        ALIGN
        SWI 2
