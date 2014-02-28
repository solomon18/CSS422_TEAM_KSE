*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
                  
*D0: Temp
*D1: Output
*D2: Instruction 1st word
*D3: Instruction 2nd word
*D4: JSR variable
*D5: JSR variable
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

            ORG     $1000

START:
            LEA     output,A6
            LEA     $7000,A4
            CLR     (A4)
            ADDI.W  #$00,(A4)+
            ADDI.W  #$11,(A4)+
            ADDI.W  #$AB,(A4)+
            ADDI.W  #$BA,(A4)+
            ADDI.W  #$77,(A4)+
            ADDI.W  #$6F,(A4)+
            ADDI.W  #$55,(A4)+
            ADDI.W  #$05,(A4)+
            ADDI.W  #$AC,(A4)+
            ADDI.W  #$4D,(A4)+
            ADDI.W  #$3A,(A4)+
            ADDI.W  #$AA,(A4)+
            ADDI.W  #$BB,(A4)+
            ADDI.W  #$CC,(A4)+
            ADDI.W  #$DD,(A4)+
            ADDI.W  #$15,(A4)+

            LEA     $7000,A4        *reset A4
            CLR     D6
            ADDI.B  #16,D6
            BRA     addressing

print       MOVE.B #$00,(A6)        * Add terminator to output str
            LEA output,A1           * load output to A1
            MOVEQ #13,D0            * Load trap code for printing
            TRAP #15                * Print output buffer
            SUBI.B  #1,D6
            CMPI.B  #0,D6
            BEQ     done
            LEA     output,A6       *reset output
            BRA     addressing

*---------------------------------------------------------------
*   Addressing
*   Extract the 6 least significant digits from the instruction
*---------------------------------------------------------------
addressing  MOVE.W  (A4)+,D2
            MOVE.B  D2,D4           *get byte instruction for parsing
            LSL.B   #5,D4           *move left 5, clears left most
            ROR.B   #5,D4           *rotate right 5 
            MOVE.B  D2,D5           *get instruction for parsing
            LSR.B   #3,D5           *move mode bits to 0-3
            LSL.B   #5,D5           *move left 5, clears left most
            ROR.B   #5,D5           *rotate right 5             
            LEA     add_mode,A2
            MULU    #6,D4           *form offset
            MULU    #6,D5           *form offset
            JSR     0(A2,D4)        *jump offset based on D2 
            BRA     print  
*---------------------------------------------------------------
*   Addressing Mode Jump Table
*---------------------------------------------------------------
add_mode    JMP     add_mode000     *Dn
            JMP     add_mode001     *An
            JMP     add_mode010     *(An)
            JMP     add_mode011     *(An)+
            JMP     add_mode100     *-(An)
            JMP     add_mode101     *(d16,An)
            JMP     add_mode110     *(d8,An,Xn)
            JMP     add_mode111     *(XXX).W, (XXX).L, #<data>
            RTS
*---------------------------------------------------------------
*   Addressing Modes
*---------------------------------------------------------------        
add_mode000 MOVE.B  #'D',(A6)+      *Add D to output 
            LEA     reg_num,A2 
            JSR     0(A2,D5)         *get reg num
            RTS
add_mode001 MOVE.B  #'A',(A6)+      *Add A to output  
            LEA     reg_num,A2 
            JSR     0(A2,D5)         *get reg num
            RTS
add_mode010 MOVE.B  #'(',(A6)+      *Add ( to output 
            MOVE.B  #'A',(A6)+      *Add A to output
            LEA     reg_num,A2 
            JSR     0(A2,D5)         *get reg num
            MOVE.B  #')',(A6)+      *Add ) to output
            RTS
add_mode011 MOVE.B  #'(',(A6)+      *Add ( to output 
            MOVE.B  #'A',(A6)+      *Add A to output
            LEA     reg_num,A2 
            JSR     0(A2,D5)         *get reg num
            MOVE.B  #')',(A6)+      *Add ) to output
            MOVE.B  #'+',(A6)+      *Add + to output
            RTS
add_mode100 MOVE.B  #'-',(A6)+      *Add - to output 
            MOVE.B  #'(',(A6)+      *Add ( to output 
            MOVE.B  #'A',(A6)+      *Add A to output
            LEA     reg_num,A2 
            JSR     0(A2,D5)         *get reg num
            MOVE.B  #')',(A6)+      *Add ) to output
            RTS
add_mode101 MOVE.B  #'(',(A6)+      *Add ( to output 
            MOVE.B  #'D',(A6)+      *Add D to output
            MOVE.B  #'1',(A6)+      *Add 1 to output 
            MOVE.B  #'6',(A6)+      *Add 6 to output 
            MOVE.B  #',',(A6)+      *Add , to output 
            MOVE.B  #'A',(A6)+      *Add A to output
            LEA     reg_num,A2 
            JSR     0(A2,D5)         *get reg num
            MOVE.B  #')',(A6)+      *Add ) to output
            RTS
add_mode110 MOVE.B  #'(',(A6)+      *Add ( to output 
            MOVE.B  #'D',(A6)+      *Add D to output
            MOVE.B  #'8',(A6)+      *Add 8 to output
            MOVE.B  #',',(A6)+      *Add , to output 
            MOVE.B  #'A',(A6)+      *Add A to output
            LEA     reg_num,A2 
            JSR     0(A2,D5)         *get reg num
            MOVE.B  #',',(A6)+      *Add , to output 
            MOVE.B  #'X',(A6)+      *Add X to output         
            MOVE.B  #')',(A6)+      *Add ) to output
            RTS
add_mode111 JSR     immediate       *go to immediate
*---------------------------------------------------------------
*   Register Jump Table
*---------------------------------------------------------------
reg_num     JMP     reg_num000      *register num 0
            JMP     reg_num001      *register num 1
            JMP     reg_num010      *register num 2
            JMP     reg_num011      *register num 3
            JMP     reg_num100      *register num 4
            JMP     reg_num101      *register num 5
            JMP     reg_num110      *register num 6
            JMP     reg_num111      *register num 7
*---------------------------------------------------------------
*   Register Number Jump Table
*---------------------------------------------------------------
reg_num000  MOVE.B  #'0',(A6)+         *register num 0
            RTS
reg_num001  MOVE.B  #'1',(A6)+         *register num 1
            RTS
reg_num010  MOVE.B  #'2',(A6)+         *register num 2
            RTS
reg_num011  MOVE.B  #'3',(A6)+         *register num 3
            RTS            
reg_num100  MOVE.B  #'4',(A6)+         *register num 4
            RTS
reg_num101  MOVE.B  #'5',(A6)+         *register num 5
            RTS
reg_num110  MOVE.B  #'6',(A6)+         *register num 7
            RTS
reg_num111  MOVE.B  #'7',(A6)+         *register num 8
            RTS                        
*-------------------------------------------------------------
*   Immediate Data
*-------------------------------------------------------------
immediate   *not implemented



* Put variables and constants here
output DS.B 80

done    CLR     D0    
        END     START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
