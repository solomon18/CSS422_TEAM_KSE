*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

*D0: Temp
*D1: Output
*D2: Instruction 1st word
*D3: JSR variable
*D4: JSR variable
*D5: Unused
*D6: Unused
*D7: Unused

*A0: 
*A1: 
*A2: Used in jump table addressing
*A3: Size
*A4: start memory
*A5: end memory
*A6: Decoded output
*A7: Do not use

    ORG    $1000
START:                  ; first instruction of program
            LEA     output,A6
            LEA     $7000,A4
            CLR     (A4)
            ADDI.W  #$5100,(A4)+
            ADDI.W  #$00AB,(A4)+
            ADDI.W  #$ABBA,(A4)+
            ADDI.W  #$BA77,(A4)+
            ADDI.W  #$776F,(A4)+
            ADDI.W  #$6F15,(A4)+
            ADDI.W  #$1505,(A4)+
            ADDI.W  #$05AC,(A4)+
            ADDI.W  #$AC4D,(A4)+
            ADDI.W  #$4D3A,(A4)+
            ADDI.W  #$3AAA,(A4)+
            ADDI.W  #$AABB,(A4)+
            ADDI.W  #$BBCC,(A4)+
            ADDI.W  #$CCDD,(A4)+
            ADDI.W  #$DD15,(A4)+
            ADDI.W  #$1513,(A4)+

            LEA     $7000,A4        *reset A4
            CLR     D6
            ADDI.B  #16,D6
            BRA     main            *branch to main

print       MOVE.B #$00,(A6)        * Add terminator to output str
            LEA output,A1           * load output to A1
            MOVEQ #13,D0            * Load trap code for printing
            TRAP #15                * Print output buffer
            SUBI.B  #1,D6
            CMPI.B  #0,D6
            BEQ     done            *branch to done
            LEA     output,A6       *reset output

************************************************************
*   main
************************************************************
main        MOVE.W  (A4)+,D2        *get next word
            MOVE.W  D2,D3           *get word for decoding
            LSR.W   #8,D3           *move right 8
            LSR.W   #4,D3           *move right 4
            MULU    #6,D3           *form offset
            LEA     op_jump,A2      *load jump table
            JSR     0(A2,D3)        *jump
            BRA     print           *branch to print
************************************************************
*   OP-Code Jump
************************************************************            
op_jump     JMP     op_0000         *Jump to 0000
            JMP     op_0001         *Jump to 0001
            JMP     op_0010         *Jump to 0010
            JMP     op_0011         *Jump to 0011
            JMP     op_0100         *Jump to 0100
            JMP     op_0101         *Jump to 0101
            JMP     op_0110         *Jump to 0110
            JMP     op_0111         *Jump to 0111
            JMP     op_1000         *Jump to 1000
            JMP     op_1001         *Jump to 1001
            JMP     op_1010         *Jump to 1010
            JMP     op_1011         *Jump to 1011
            JMP     op_1100         *Jump to 1100
            JMP     op_1101         *Jump to 1101
            JMP     op_1110         *Jump to 1100
            JMP     op_1111         *Jump to 1111
            RTS                     *return
************************************************************
*   0000
*   ADDI
*   ANDI
*   BCHG
*   CMPI
*   EORI
************************************************************
op_0000     RTS

************************************************************
*   0001
*   MOVE.B
************************************************************
op_0001     MOVE.B  #'M',(A6)+      *Add M to output
            MOVE.B  #'O',(A6)+      *Add O to output
            MOVE.B  #'V',(A6)+      *Add V to output
            MOVE.B  #'E',(A6)+      *Add E to output
            MOVE.B  #'.',(A6)+      *Add . to output
            MOVE.B  #'B',(A6)+      *Add B to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output         
            RTS
            
************************************************************
*   0010 
*   MOVE.W
************************************************************
op_0010     MOVE.B  #'M',(A6)+      *Add M to output
            MOVE.B  #'O',(A6)+      *Add O to output
            MOVE.B  #'V',(A6)+      *Add V to output
            MOVE.B  #'E',(A6)+      *Add E to output
            MOVE.B  #'.',(A6)+      *Add . to output
            MOVE.B  #'W',(A6)+      *Add W to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output          
            RTS

************************************************************
*   0011 
*   MOVE.L
************************************************************
op_0011     MOVE.B  #'M',(A6)+      *Add M to output
            MOVE.B  #'O',(A6)+      *Add O to output
            MOVE.B  #'V',(A6)+      *Add V to output
            MOVE.B  #'E',(A6)+      *Add E to output
            MOVE.B  #'.',(A6)+      *Add . to output
            MOVE.B  #'L',(A6)+      *Add L to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output           
            RTS

************************************************************
*   0100
*   CLR
*   JSR
*   LEA
*   MOVEM
*   RTS
************************************************************
op_0100     RTS

************************************************************
*   0101
*   SUBQ
************************************************************
op_0101     MOVE.B  #'S',(A6)+      *Add S to output
            MOVE.B  #'U',(A6)+      *Add U to output
            MOVE.B  #'B',(A6)+      *Add B to output
            MOVE.B  #'Q',(A6)+      *Add Q to output
            MOVE.B  #'.',(A6)+      *Add . to output 
            MOVE.W  D2,D3           *get word back
            LSL.W   #8,D3           *shift left 8
            LSR.W   #8,D3           *shift right 8
            LSR.W   #6,D3           *shift right 6
            MULU    #6,D3           *create offset
            LEA     get_size,A2     *load size jump table
            JSR     0(A2,D3)        *jump to size table  
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output         
            RTS

************************************************************
*   0110
*   BCC
*   BGT
*   BLE
*   BVS
************************************************************
op_0110     RTS

************************************************************
*   0111
*   MOVEQ
************************************************************
op_0111     MOVE.B  #'M',(A6)+      *Add M to output
            MOVE.B  #'O',(A6)+      *Add O to output
            MOVE.B  #'V',(A6)+      *Add V to output
            MOVE.B  #'E',(A6)+      *Add E to output
            MOVE.B  #'Q',(A6)+      *Add Q to output
            MOVE.B  #'.',(A6)+      *Add . to output
            MOVE.W  D2,D3           *get word back
            LSL.W   #8,D3           *shift left 8
            LSR.W   #8,D3           *shift right 8
            LSR.W   #6,D3           *shift right 6
            MULU    #6,D3           *create offset
            LEA     get_size,A2     *load size jump table
            JSR     0(A2,D3)        *jump to size table
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output             
            RTS
            
************************************************************
*   1000
*   DIVU
*   LOR
************************************************************
op_1000     RTS

************************************************************
*   1001
*   SUB
*   SUBA
************************************************************
op_1001     RTS

************************************************************
*   1010 unknown
************************************************************
op_1010     MOVE.B  #'B',(A6)+      *Add B to output
            MOVE.B  #'A',(A6)+      *Add A to output
            MOVE.B  #'D',(A6)+      *Add D to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #'C',(A6)+      *Add C to output
            MOVE.B  #'O',(A6)+      *Add O to output
            MOVE.B  #'D',(A6)+      *Add D to output
            MOVE.B  #'E',(A6)+      *Add E to output
            RTS

************************************************************
*   1011
*   CMP
*   CMPA
*   EOR
************************************************************
op_1011     RTS

************************************************************
*   1100
*   AND
*   MULS
************************************************************
op_1100     RTS

************************************************************
*   1101
*   ADD
*   ADDA
************************************************************
op_1101     RTS

************************************************************
*   1110
*   ASR
*   LSL
*   ROL
************************************************************
op_1110     RTS

************************************************************
*   1111 unknown
************************************************************
op_1111     MOVE.B  #'B',(A6)+      *Add B to output
            MOVE.B  #'A',(A6)+      *Add A to output
            MOVE.B  #'D',(A6)+      *Add D to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #'C',(A6)+      *Add C to output
            MOVE.B  #'O',(A6)+      *Add O to output
            MOVE.B  #'D',(A6)+      *Add D to output
            MOVE.B  #'E',(A6)+      *Add E to output
            RTS

************************************************************
*   Size Jump Table
************************************************************
get_size    JMP size00              *illegal
            JMP size01              *BYTE
            JMP size10              *WORD
            JMP size11              *LONG
            RTS
************************************************************
*   Size Sub-Jump Table
************************************************************
size00      MOVE.B  #'B',(A6)+      *Add B to output
            MOVE.B  #'A',(A6)+      *Add A to output
            MOVE.B  #'D',(A6)+      *Add D to output
            MOVE.B  #' ',(A6)+      *Add ' ' to output
            MOVE.B  #'S',(A6)+      *Add S to output
            MOVE.B  #'I',(A6)+      *Add I to output
            MOVE.B  #'Z',(A6)+      *Add Z to output
            MOVE.B  #'E',(A6)+      *Add E to output
            RTS
size01      MOVE.B  #'B',(A6)+      *Add B to output
            RTS
size10      MOVE.B  #'W',(A6)+      *Add W to output
            RTS
size11      MOVE.B  #'L',(A6)+      *Add L to output
            RTS           

* Put variables and constants here
output  DS.B 80

done    CLR     D0
        END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
