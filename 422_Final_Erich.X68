*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

*assuming the instruction is loaded in D0

* Put program code here
*---------------------------------------------------------------
*   Addressing
*   Extract the 6 least significant digits from the instruction
*---------------------------------------------------------------
addressing  MOVE.W  D0,D1           *get instruction for parsing
            ADDI.W  ea_regMask,D1   *isolate the register
            MOVE.W  D0,D2           *get instruction for parsing
            ADDI.W  ea_modeMask,D2  *isolate the mode
            LEA     add_mode,A0
            JSR     (A0,D2)         *jump offset based on D2   
            RTS
*---------------------------------------------------------------
*   Addressing Mode Jump Table
*---------------------------------------------------------------
add_mode    JMP     add_mode000     * Dn
            JMP     add_mode001     * An
            JMP     add_mode010     *(An)
            JMP     add_mode011     *(An)+
            JMP     add_mode100     *-(An)
            JMP     add_mode101     *(d16,An)
            JMP     add_mode110     *(d8,An,Xn)
            JMP     add_mode111     *(XXX).W, (XXX).L, #<data>
*---------------------------------------------------------------
*   Addressing Modes
*---------------------------------------------------------------        
add_mode000 MOVE.B  #'B',(A7)+      *Add D to output 
            LEA     reg_num,A1 
            JSR     (A1,D1)         *get reg num
            RTS
add_mode001 MOVE.B  #'A',(A7)+      *Add A to output  
            LEA     reg_num,A1 
            JSR     (A1,D1)         *get reg num
            RTS
add_mode010 MOVE.B  #'(',(A7)+      *Add ( to output 
            MOVE.B  #'A',(A7)+      *Add A to output
            LEA     reg_num,A1 
            JSR     (A1,D1)         *get reg num
            MOVE.B  #')',(A7)+      *Add ) to output
            RTS
add_mode011 MOVE.B  #'(',(A7)+      *Add ( to output 
            MOVE.B  #'A',(A7)+      *Add A to output
            LEA     reg_num,A1 
            JSR     (A1,D1)         *get reg num
            MOVE.B  #')',(A7)+      *Add ) to output
            MOVE.B  #'+',(A7)+      *Add + to output
            RTS
add_mode100 MOVE.B  #'-',(A7)+      *Add - to output 
            MOVE.B  #'(',(A7)+      *Add ( to output 
            MOVE.B  #'A',(A7)+      *Add A to output
            LEA     reg_num,A1 
            JSR     (A1,D1)         *get reg num
            MOVE.B  #')',(A7)+      *Add ) to output
            RTS
add_mode101 MOVE.B  #'(',(A7)+      *Add ( to output 
            MOVE.B  #'D',(A7)+      *Add D to output
            MOVE.B  #'1',(A7)+      *Add 1 to output 
            MOVE.B  #'6',(A7)+      *Add 6 to output 
            MOVE.B  #',',(A7)+      *Add , to output 
            MOVE.B  #'A',(A7)+      *Add A to output
            LEA     reg_num,A1 
            JSR     (A1,D1)         *get reg num
            MOVE.B  #')',(A7)+      *Add ) to output
            RTS
add_mode110 MOVE.B  #'(',(A7)+      *Add ( to output 
            MOVE.B  #'D',(A7)+      *Add D to output
            MOVE.B  #'8',(A7)+      *Add 8 to output
            MOVE.B  #',',(A7)+      *Add , to output 
            MOVE.B  #'A',(A7)+      *Add A to output
            LEA     reg_num,A1 
            JSR     (A1,D1)         *get reg num
            MOVE.B  #',',(A7)+      *Add , to output 
            MOVE.B  #'X',(A7)+      *Add X to output         
            MOVE.B  #')',(A7)+      *Add ) to output
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
reg_num000  MOVE.B  #'0',(A7)+         *register num 0
            RTS
reg_num001  MOVE.B  #'1',(A7)+         *register num 1
            RTS
reg_num010  MOVE.B  #'2',(A7)+         *register num 2
            RTS
reg_num011  MOVE.B  #'3',(A7)+         *register num 3
            RTS            
reg_num100  MOVE.B  #'4',(A7)+         *register num 4
            RTS
reg_num101  MOVE.B  #'5',(A7)+         *register num 5
            RTS
reg_num110  MOVE.B  #'6',(A7)+         *register num 7
            RTS
reg_num111  MOVE.B  #'7',(A7)+         *register num 8
            RTS                        
*-------------------------------------------------------------
*   Immediate Data
*-------------------------------------------------------------
immediate   *not implemented
*-------------------------------------------------------------
*   Masks
*-------------------------------------------------------------
ea_regMask  DC.W    $0007           *bits 1-3
ea_modeMask DC.W    $0038           *bits 3-5


* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
