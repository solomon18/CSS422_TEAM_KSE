*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------

*D0: Temp
*D1: Output
*D2: current Instruction
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
            ADDI.W  #$0A89,(A4)+
            ADDI.W  #$00AB,(A4)+


            LEA     $7000,A4        reset A4
            CLR     D6
            ADDI.B  #16,D6
            JMP     main            branch to main

print       MOVE.B #$00,(A6)        Add terminator to output str
            LEA output,A1           load output to A1
            MOVEQ #13,D0            Load trap code for printing
            TRAP #15                Print output buffer
            SUBI.B  #1,D6
            CMPI.B  #0,D6
            BEQ     done            branch to done
            LEA     output,A6       reset output
************************************************************
*   main
************************************************************
main        MOVE.W  (A4)+,D2        get next word
            MOVE.W  D2,D3           get word for decoding
            JSR     iso12to15       get last 4 bits (12-15)
            MULU    #6,D3           form offset
            LEA     op_jump,A2      load jump table
            JSR     0(A2,D3)        jump
            JMP     print           branch to print
************************************************************
*   OP-Code Jump
************************************************************            
op_jump     JMP     op_0000         Jump to 0000
            JMP     op_0001         Jump to 0001
            JMP     op_0010         Jump to 0010
            JMP     op_0011         Jump to 0011
            JMP     op_0100         Jump to 0100
            JMP     op_0101         Jump to 0101
            JMP     op_0110         Jump to 0110
            JMP     op_0111         Jump to 0111
            JMP     op_1000         Jump to 1000
            JMP     op_1001         Jump to 1001
            JMP     op_1010         Jump to 1010
            JMP     op_1011         Jump to 1011
            JMP     op_1100         Jump to 1100
            JMP     op_1101         Jump to 1101
            JMP     op_1110         Jump to 1100
            JMP     op_1111         Jump to 1111
            RTS                     return
************************************************************
*   0000
*   ADDI
*   ANDI
*   BCHG
*   CMPI
*   EORI
************************************************************
op_0000     MOVE.W  D2,D3
            BTST.L  #8,D3
            BEQ     upper0000
lower0000   JSR     iso6to7
            MULU.W  #6,D3
            LEA     lower0000_2,A2
            JSR     0(A2,D3)
            RTS 
upper0000   JSR     iso9to11
            MULU.W  #6,D3
            LEA     upper0000_2,A2
            JSR     0(A2,D3)
            RTS           
************************************************************
*   BCHG sub table
************************************************************            
lower0000_2 JMP     btst
            JMP     bchg
            JMP     bclr
            JMP     bset
            JMP     movep
btst        JMP     bad_code
bchg        MOVE.B  #'B',(A6)+      Add B to output
            MOVE.B  #'C',(A6)+      Add C to output
            MOVE.B  #'H',(A6)+      Add H to output
            MOVE.B  #'G',(A6)+      Add G to output
            JSR     print5spcs      add 5 spaces to buffer   
            MOVE.B  #'D',(A6)+      Add D to output
            MOVE.W  D2,D3
            JSR     iso9to11
            CMP.B   #%100,D3        check for immediate data
            BEQ     bad_code        immediate data is handled by upper
            MULU.W  #6,D3
            LEA     reg_num,A2
            JSR     0(A2,D3)               
            RTS
bclr        JMP     bad_code
bset        JMP     bad_code
movep       JMP     bad_code
************************************************************
*   ADDI\ANDI\BCHG(I)\CMPI\EORI sub table
************************************************************
upper0000_2 JMP     ori
            JMP     andi
            JMP     subi
            JMP     addi
            JMP     biti
            JMP     eori
            JMP     cmpi
ori         JMP     bad_code            
andi        MOVE.B  #'A',(A6)+      Add A to output
            MOVE.B  #'N',(A6)+      Add N to output
            MOVE.B  #'D',(A6)+      Add D to output
            MOVE.B  #'I',(A6)+      Add I to output
            MOVE.B  #'.',(A6)+      Add '.' to output
            JMP     imm_final
subi        JMP     bad_code 
addi        MOVE.B  #'A',(A6)+      Add A to output
            MOVE.B  #'D',(A6)+      Add D to output
            MOVE.B  #'D',(A6)+      Add D to output
            MOVE.B  #'I',(A6)+      Add I to output
            MOVE.B  #'.',(A6)+      Add '.' to output
            BRA     imm_final           
biti        JSR iso6to7
            CMP.B   #%00,D3
            BEQ     bad_code
            CMP.B   #%01,D3
            BEQ     bchgi
            CMP.B   #%10,D3
            BEQ     bad_code
            BRA     bad_code
bchgi       MOVE.B  #'B',(A6)+      Add B to output
            MOVE.B  #'C',(A6)+      Add C to output
            MOVE.B  #'H',(A6)+      Add H to output
            MOVE.B  #'G',(A6)+      Add G to output
            JMP     imm_final
eori        MOVE.B  #'E',(A6)+      Add E to output
            MOVE.B  #'O',(A6)+      Add O to output
            MOVE.B  #'R',(A6)+      Add R to output
            MOVE.B  #'I',(A6)+      Add I to output
            MOVE.B  #'.',(A6)+      Add '.' to output
            JMP     imm_final 
            RTS
cmpi        MOVE.B  #'E',(A6)+      Add E to output
            MOVE.B  #'O',(A6)+      Add O to output
            MOVE.B  #'R',(A6)+      Add R to output
            MOVE.B  #'I',(A6)+      Add I to output
            MOVE.B  #'.',(A6)+      Add '.' to output
            JMP     imm_final 
            RTS
imm_final   JSR     immediate
            MOVE.B  #',',(A6)+      Add ',' to output
            JSR     addressing      jump to addressing
            *TODO: check if the mode is correct
            RTS
************************************************************
*   0001
*   MOVE.B
************************************************************
op_0001     MOVE.B  #'M',(A6)+      Add M to output
            MOVE.B  #'O',(A6)+      Add O to output
            MOVE.B  #'V',(A6)+      Add V to output
            MOVE.B  #'E',(A6)+      Add E to output
            MOVE.B  #'.',(A6)+      Add . to output
            MOVE.B  #'B',(A6)+      Add B to output
            JSR     print5spcs      add 5 spaces to buffer
            JSR     addressing      jump to addressing sub routine
            *TODO: check if the mode is correct
            RTS            
************************************************************
*   0010 
*   MOVE.W
************************************************************
op_0010     MOVE.B  #'M',(A6)+      Add M to output
            MOVE.B  #'O',(A6)+      Add O to output
            MOVE.B  #'V',(A6)+      Add V to output
            MOVE.B  #'E',(A6)+      Add E to output
            MOVE.B  #'.',(A6)+      Add . to output
            MOVE.B  #'W',(A6)+      Add W to output
            JSR     print5spcs      add 5 spaces to buffer
            JSR     addressing      jump to addressing sub routine
            *TODO: check if the mode is correct            
            RTS
************************************************************
*   0011 
*   MOVE.L
************************************************************
op_0011     MOVE.B  #'M',(A6)+      Add M to output
            MOVE.B  #'O',(A6)+      Add O to output
            MOVE.B  #'V',(A6)+      Add V to output
            MOVE.B  #'E',(A6)+      Add E to output
            MOVE.B  #'.',(A6)+      Add . to output
            MOVE.B  #'L',(A6)+      Add L to output
            JSR     print5spcs      add 5 spaces to buffer
            JSR     addressing      jump to addressing sub routine
            *TODO: check if the mode is correct            
            RTS
************************************************************
*   0100
*   CLR
*   JSR
*   LEA
*   MOVEM
*   RTS
************************************************************
op_0100         MOVE.W  D2,D3           get current instruction
                BTST.L  #8,D3
                BNE     lea_or_chk
                JSR     iso8to11        get next 4 bits (8-11)
                MULU.W  #6,D3           form offset
                LEA     sub0100,A2      load jump table
                JSR     0(A2,D3)
                RTS
lea_or_chk      BTST.L  #6,D3
                BEQ     bad_code
                MOVE.B  #'L',(A6)+      Add L to output
                MOVE.B  #'E',(A6)+      Add E to output
                MOVE.B  #'A',(A6)+      Add A to output   
                JSR     iso9to11        get bits 9-11 for A register
                JSR     print5spcs      add 5 spaces to buffer
                JSR     addressing      jump to addressing sub routine
            *TODO: check if the mode is correct            
sub0100         JMP     sub0100_0            
                JMP     sub0100_1
                JMP     sub0100_2       CLR, only here for jump offset
                JMP     sub0100_3
                JMP     sub0100_4
                JMP     sub0100_5
                JMP     sub0100_6
                JMP     sub0100_7
                JMP     sub0100_8
                JMP     sub0100_9
                JMP     sub0100_10
                JMP     sub0100_11
                JMP     sub0100_12
                JMP     sub0100_13
                JMP     sub0100_14
                JMP     sub0100_15
sub0100_0       JMP     bad_code            instruction unknown
sub0100_1       JMP     bad_code            clr_or_chk handles this
sub0100_2       MOVE.B  #'C',(A6)+          Add C to output
                MOVE.B  #'L',(A6)+          Add L to output
                MOVE.B  #'R',(A6)+          Add R to output   
                MOVE.B  #'.',(A6)+          Add . to output 
                JSR     iso6to7             isolate bits 6 and 7 for size
                MULU.W  #6,D3
                LEA     get_size,A2
                JSR     0(A2,D3)
                JSR     print5spcs          add 5 spaces to buffer
                JSR     addressing
            *TODO: check if the mode is correct                
                RTS
sub0100_3       JMP     bad_code            clr_or_chk handles this
sub0100_4       JMP     bad_code            instruction unknown
sub0100_5       JMP     bad_code            clr_or_chk handles this
sub0100_6       JMP     bad_code            instruction unknown
sub0100_7       JMP     bad_code            clr_or_chk handles this
sub0100_8       JSR     iso3to5             get bits 3 to 5 for mode
                CMP.B   #%000,D3            check if 000
                BEQ     bad_code
                MOVE.B  #'M',(A6)+          Add M to output
                MOVE.B  #'O',(A6)+          Add o to output
                MOVE.B  #'V',(A6)+          Add V to output 
                MOVE.B  #'E',(A6)+          Add E to output  
                MOVE.B  #'M',(A6)+          Add M to output
                MOVE.B  #'.',(A6)+          Add . to output 
                MOVE.W  D2,D3               get current instruction
                BTST.L  #6,D3
                BEQ     movem_w_0
                MOVE.B  #'L',(A6)+          Add L to output
                JMP     com_movem_0
movem_w_0       MOVE.B  #'W',(A6)+          Add W to output
com_movem_0     JSR     print4spcs 
                *TODO: get register mask               
                RTS
sub0100_9       JMP     bad_code            clr_or_chk handles this
sub0100_10      JMP     bad_code            instruction unknown 
sub0100_11      JMP     bad_code            clr_or_chk handles this
sub0100_12      MOVE.B  #'M',(A6)+          Add M to output
                MOVE.B  #'O',(A6)+          Add O to output
                MOVE.B  #'V',(A6)+          Add V to output 
                MOVE.B  #'E',(A6)+          Add E to output  
                MOVE.B  #'M',(A6)+          Add M to output
                MOVE.B  #'.',(A6)+          Add . to output 
                MOVE.W  D2,D3               get current instruction
                BTST.L  #6,D3
                BEQ     movem_w_1
                MOVE.B  #'L',(A6)+          Add L to output
                JMP     com_movem_0
movem_w_1       MOVE.B  #'W',(A6)+          Add W to output
com_movem_1     JSR     print4spcs
                *TODO: get register mask
                RTS 
sub0100_13      JMP     bad_code            clr_or_chk handles this
sub0100_14      JSR     iso4to7             get next 4
                CMP.B   #%0100,D3           TRAP
                BEQ     bad_code
                CMP.B   #%0101,D3           LINK/UNLK
                BEQ     bad_code
                CMP.B   #%0111,D3           needs more decoding
                BEQ     sub0100_14_sub2     everything else falls to 15
                JSR     iso6to7             get bits 6 and 7
                CMP.B   #%10,D3
                BNE     bad_code
                MOVE.B  #'J',(A6)+          Add J to output
                MOVE.B  #'S',(A6)+          Add S to output
                MOVE.B  #'R',(A6)+          Add R to output
                JSR     print5spcs          
                JSR     addressing
            *TODO: check if the mode is correct                
sub0100_15      JMP     bad_code            clr_or_chk handles this
sub0100_14_sub2 JSR     iso0to3
                CMP.B   #%0101,D3           check if RT
                BEQ     rts
                JMP     bad_code                     
rts             MOVE.B  #'R',(A6)+          Add R to output
                MOVE.B  #'T',(A6)+          Add T to output
                MOVE.B  #'S',(A6)+          Add S to output
                RTS                
************************************************************
*   0101
*   SUBQ
************************************************************
op_0101     MOVE.B  #'S',(A6)+      Add S to output
            MOVE.B  #'U',(A6)+      Add U to output
            MOVE.B  #'B',(A6)+      Add B to output
            MOVE.B  #'Q',(A6)+      Add Q to output
            MOVE.B  #'.',(A6)+      Add . to output 
            MOVE.W  D2,D3           get word back
            LSL.W   #8,D3           shift left 8
            LSR.W   #8,D3           shift right 8
            LSR.W   #6,D3           shift right 6
            MULU    #6,D3           create offset
            LEA     get_size,A2     load size jump table
            JSR     0(A2,D3)        jump to size table  
            JSR     print5spcs      add 5 spaces to buffer
            JSR     addressing      jump to addressing sub routine
            *TODO: check if the mode is correct     
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
op_0111     MOVE.B  #'M',(A6)+      Add M to output
            MOVE.B  #'O',(A6)+      Add O to output
            MOVE.B  #'V',(A6)+      Add V to output
            MOVE.B  #'E',(A6)+      Add E to output
            MOVE.B  #'Q',(A6)+      Add Q to output
            MOVE.B  #'.',(A6)+      Add . to output
            MOVE.W  D2,D3           get word back
            LSL.W   #8,D3           shift left 8
            LSR.W   #8,D3           shift right 8
            LSR.W   #6,D3           shift right 6
            MULU    #6,D3           create offset
            LEA     get_size,A2     load size jump table
            JSR     0(A2,D3)        jump to size table
            JSR     print5spcs      add 5 spaces to buffer           
            JSR     addressing      jump to addressing sub routine
            *TODO: check if the mode is correct
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
op_1010     BRA     bad_code
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
op_1110     JSR     iso6to7         get size of instruction
            CMP.B   #3,d3           long
            BLT     regShift            
            JSR     iso9to10        get type of memory shift
            CMP.B   #0,D3           arithmetic shift
            BEQ     aMemShift
            CMP.B   #1,D3           logical shift
            BEQ     lMemShift
            CMP.B   #2,D3           rotate with extend
            BEQ     xMemError
            CMP.B   #3,d3           rotate
            BEQ     rMemShift
regShift    MOVE.B  D3,D4           move size to D4
            JSR     iso3to4         get shift type
            MULU.W  #6,D3           form offset
            LEA     sub1110,A2      load op_1110_sub to A2
            JSR     0(A2,D3)        jump to table 
            MOVE.B  #'.',(A6)+      Add . to output
            MULU.W  #6,D4           form offset for size
            LEA     get_size,A2     load size jump table
            JSR     0(A2,D4)
            BTST.L  #5,D2           get i/r
            BEQ     getShiftNum        
            JSR     print4spcs      add 4 spaces to buffer
            MOVE.B  #'D',(A6)+      Add 'D' to output            
            JSR     iso9to11        get num of shifts
            MULU.W  #6,D3
            LEA     reg_num,A2      load reg addressing jump
            JSR     0(A2,D3)        jump to table             
            MOVE.B  #',',(A6)+      Add ',' to output   
            MOVE.B  #'D',(A6)+      Add 'D' to output            
            JSR     iso0to2         get source register
            MULU.W  #6,D3           create offset
            LEA     reg_num,A2      load reg addressing jump
            JSR     0(A2,D3)        jump to table          
            RTS
aMemShift   JSR     arithm          arithmetic shift
            JMP     memAddress      get EA
lMemShift   JSR     logical         logical shift
            JMP     memAddress      get EA      
rMemShift   JSR     rotate          rotate
memAddress  JSR     print5spcs      add 5 spaces to buffer
            JSR     addressing      jump to addressing
            *TODO: check if the mode is correct
            RTS
getShiftNum JSR     print4spcs      add 4 spaces to buffer
            MOVE.B  #'#',(A6)+      Add '#' to output            
            JSR     iso9to11        get num of shifts
            MULU.W  #6,D3           create offset
            LEA     reg_num,A2      cheep binary to num
            JSR     0(A2,D3)        jump to table
            MOVE.B  #',',(A6)+      Add ',' to output   
            MOVE.B  #'D',(A6)+      Add 'D' to output            
            JSR     iso0to2         get source register
            MULU.W  #6,D3           create offset
            LEA     reg_num,A2      load reg addressing jump
            JSR     0(A2,D3)        jump to table
            RTS
xMemError   JMP     bad_code                    
************************************************************
*   LS\AS\RO sub table
************************************************************
sub1110     JMP     arithm
            JMP     logical
            JMP     rotate
arithm      MOVE.B  #'A',(A6)+      Add A to output
            MOVE.B  #'S',(A6)+      Add S to output
            JMP     direction
logical     MOVE.B  #'L',(A6)+      Add L to output
            MOVE.B  #'S',(A6)+      Add S to output
            JMP     direction
rotate      MOVE.B  #'R',(A6)+      Add R to output
            MOVE.B  #'O',(A6)+      Add O to output
            JMP     direction
direction   BTST.L  #8,D2           Test bit 5 of instruction
            BEQ     right
            MOVE.B  #'L',(A6)+      Add L to output 
            RTS
right       MOVE.B  #'R',(A6)+      Add R to output            
            RTS
************************************************************
*   1111 unknown
************************************************************
op_1111     BRA     bad_code
************************************************************
* isolate bits 0 to 2 in D3
************************************************************ 
iso0to2     MOVE.W  D2,D3           get current instruction
            ANDI.W  #$7,D3          mask out all but first 3
            RTS
************************************************************
* isolate bits 0 to 3 in D3
************************************************************             
iso0to3     MOVE.W  D2,D3           get current instruction
            ANDI.W  #$F,D3          mask out all but first 3
            RTS       
************************************************************
* isolate bits 3 to 5 in D3
************************************************************ 
iso3to5     MOVE.W  D2,D3           get current instruction
            LSR.W   #3,D3           move bit 3 to location 0
            ANDI.W  #$7,D3          mask out all but first 3
            RTS             
************************************************************
* isolate bits 3 and 4 in D3
************************************************************ 
iso3to4     MOVE.W  D2,D3           get current instruction
            LSR.W   #3,D3           move it 3 to location 0
            ANDI.W  #$3,D3          mask out all but first 2
            RTS 
************************************************************
* isolate bits 4 to 7 in D3
************************************************************ 
iso4to7     MOVE.W  D2,D3           get current instruction
            LSR.W   #4,D3           move it 3 to location 0
            ANDI.W  #$F,D3          mask out all but first 2
            RTS         
************************************************************
* isolate bits 6 and 7 in D3
************************************************************
iso6to7     MOVE.W  D2,D3           get current instruction
            LSR.W   #6,D3           move bit 6 to location 0
            ANDI.W  #$3,D3          mask out all but first 2
            RTS           
************************************************************
* isolate bits 8 to 11 in D3
************************************************************
iso8to11    MOVE.W  D2,D3           get current instruction
            LSR.W   #8,D3           move bit 9 to location 1
            ANDI.W  #$F,D3           mask out all but first 2
            RTS
************************************************************
* isolate bits 9 to 10 in D3
************************************************************
iso9to10    MOVE.W  D2,D3           get current instruction
            LSR.W   #8,D3           move bit 9 to location 1
            LSR.W   #1,D3           move bit 9 to loaction 0
            ANDI.W  #$3,D3          mask out all but first 2
            RTS
************************************************************
* isolate bits 9 to 11 in D3
************************************************************            
iso9to11    MOVE.W  D2,D3           get current instruction
            LSR.W   #8,D3           move bit 9 to location 1
            LSR.W   #1,D3           move bit 9 to loaction 0
            ANDI.W  #$7,D3          mask out all but first 3
            RTS 
************************************************************
* isolate bits 12 to 15 in D3
************************************************************            
iso12to15   MOVE.W  D2,D3           get current instruction
            LSR.W   #8,D3           move bit 12 to location 4
            LSR.W   #4,D3           move bit 12 to loaction 0
            ANDI.W  #$F,D3          mask out all but first 3
            RTS         
************************************************************
*   Size Jump Table
************************************************************
get_size    JMP size00              BYTE
            JMP size01              WORD
            JMP size10              LONG
            JMP size11              ILLEGAL
            RTS
************************************************************
*   Size Sub-Jump Table
************************************************************
size00      MOVE.B  #'B',(A6)+      Add B to output
            RTS
size01      MOVE.B  #'W',(A6)+      Add W to output
            RTS
size10      MOVE.B  #'L',(A6)+      Add L to output
            RTS 
size11      JMP     bad_size                    
*-------------------------------------------------------------
*   Immediate Data
*-------------------------------------------------------------
immediate   JSR     iso6to7         isolate bits 6 and 7 for size
            MOVE.B  D3,D4           move size to D4
            MULU.W  #6,D4
            LEA     get_size,A2
            JSR     0(A2,D4)
            JSR     print4spcs      add 4 spaces to buffer           
            MOVE.B  #'#',(A6)+      Add '#' to output
            MOVE.B  #'$',(A6)+      Add '$' to output
            CMP.B   #0,D3           byte
            BEQ     imm_byte
            CMP.B   #1,D3           word
            BEQ     imm_word
            CMP.B   #2,D3           long
            BEQ     imm_long
            RTS            
imm_byte    JSR     get_next_w
            RTS
imm_word    JSR     get_next_w
            RTS
imm_long    JSR     get_next_l
            RTS
get_next_w  CLR     D3
            MOVE.W  (A4)+,D3
            MOVE.W  D3,D4
            LSR.W   #8,D4
            LSR.W   #4,D4
            JSR     GETCHAR            
            MOVE.W  D3,D4
            LSR.W   #8,D4
            JSR     GETCHAR
            MOVE.W  D3,D4
            LSR.W   #4,D4
            JSR     GETCHAR
            MOVE.W  D3,D4
            JSR     GETCHAR
            RTS
get_next_l  CLR     D3
            MOVE.W  (A4)+,D3
            MOVE.W  D3,D4
            LSR.W   #8,D4
            LSR.W   #8,D4
            LSR.W   #8,D4            
            LSR.W   #4,D4
            JSR     GETCHAR            
            MOVE.W  D3,D4
            LSR.W   #8,D4
            LSR.W   #8,D4
            LSR.W   #8,D4            
            JSR     GETCHAR
            MOVE.W  D3,D4
            LSR.W   #8,D4
            LSR.W   #8,D4
            LSR.W   #4,D4
            JSR     GETCHAR
            MOVE.W  D3,D4
            LSR.W   #8,D4
            LSR.W   #8,D4
            JSR     GETCHAR
            MOVE.W  D3,D4
            LSR.W   #8,D4
            LSR.W   #4,D4
            JSR     GETCHAR            
            MOVE.W  D3,D4
            LSR.W   #8,D4
            JSR     GETCHAR
            MOVE.W  D3,D4
            LSR.W   #4,D4
            JSR     GETCHAR
            MOVE.W  D3,D4
            JSR     GETCHAR  
            RTS
GETCHAR     ANDI.W  #$000F,D4
            CMP.B #$09,D4           compare against A
            BGT CHARUP              branch to CHARUP
            ADDI.B #$30,D4          Add $30 to get 0-9 ASCII
            BRA ADDCHAR
CHARUP      ADDI.B #$37,D4          Add $37 to get A-F ASCII
ADDCHAR     MOVE.B D4,(A6)+         Load value into output
            RTS                     return           
*---------------------------------------------------------------
*   Addressing
*   Extract the 6 least significant digits from the instruction
*   Assumes mode is in D3
*   Assumes register is in D4
*---------------------------------------------------------------
addressing  CLR     D3
            MOVE.B  D2,D3           get instruction for bytes 3-5 (mode)
            LSR.B   #3,D3           move right 3
            ANDI.B  #7,D3           mask for just first 3 bits
            MOVE.B  D2,D4           get instruction for bytes 3-5 (reg)
            ANDI.B  #7,D4           mask for just first 3 bits      
            LEA     add_mode,A2
            MULU    #6,D3           form offset
            MULU    #6,D4           form offset
            JSR     0(A2,D3)        jump offset based on D3 
            RTS
*---------------------------------------------------------------
*   Addressing Mode Jump Table
*---------------------------------------------------------------
add_mode    JMP     add_mode000     Dn
            JMP     add_mode001     An
            JMP     add_mode010     (An)
            JMP     add_mode011     (An)+
            JMP     add_mode100     -(An)
            JMP     add_mode101     (d16,An)
            JMP     add_mode110     (d8,An,Xn)
            JMP     add_mode111     (XXX).W, (XXX).L, #<data>
            RTS
*---------------------------------------------------------------
*   Addressing Modes
*---------------------------------------------------------------        
add_mode000 MOVE.B  #'D',(A6)+      Add D to output 
            LEA     reg_num,A2 
            JSR     0(A2,D4)        get reg num
            RTS
add_mode001 MOVE.B  #'A',(A6)+      Add A to output  
            LEA     reg_num,A2 
            JSR     0(A2,D4)        get reg num
            RTS
add_mode010 MOVE.B  #'(',(A6)+      Add ( to output 
            MOVE.B  #'A',(A6)+      Add A to output
            LEA     reg_num,A2 
            JSR     0(A2,D4)        get reg num
            MOVE.B  #')',(A6)+      Add ) to output
            RTS
add_mode011 MOVE.B  #'(',(A6)+      Add ( to output 
            MOVE.B  #'A',(A6)+      Add A to output
            LEA     reg_num,A2 
            JSR     0(A2,D4)        get reg num
            MOVE.B  #')',(A6)+      Add ) to output
            MOVE.B  #'+',(A6)+      Add + to output
            RTS
add_mode100 MOVE.B  #'-',(A6)+      Add - to output 
            MOVE.B  #'(',(A6)+      Add ( to output 
            MOVE.B  #'A',(A6)+      Add A to output
            LEA     reg_num,A2 
            JSR     0(A2,D4)        get reg num
            MOVE.B  #')',(A6)+      Add ) to output
            RTS
add_mode101 MOVE.B  #'(',(A6)+      Add ( to output 
            MOVE.B  #'D',(A6)+      Add D to output
            MOVE.B  #'1',(A6)+      Add 1 to output 
            MOVE.B  #'6',(A6)+      Add 6 to output 
            MOVE.B  #',',(A6)+      Add , to output 
            MOVE.B  #'A',(A6)+      Add A to output
            LEA     reg_num,A2 
            JSR     0(A2,D4)        get reg num
            MOVE.B  #')',(A6)+      Add ) to output
            RTS
add_mode110 MOVE.B  #'(',(A6)+      Add ( to output 
            MOVE.B  #'D',(A6)+      Add D to output
            MOVE.B  #'8',(A6)+      Add 8 to output
            MOVE.B  #',',(A6)+      Add , to output 
            MOVE.B  #'A',(A6)+      Add A to output
            LEA     reg_num,A2 
            JSR     0(A2,D4)        get reg num
            MOVE.B  #',',(A6)+      Add , to output 
            MOVE.B  #'X',(A6)+      Add X to output         
            MOVE.B  #')',(A6)+      Add ) to output
            RTS
add_mode111 JSR     immediate       go to immediate
*---------------------------------------------------------------
*   Register Jump Table
*---------------------------------------------------------------
reg_num     JMP     reg_num000      register num 0
            JMP     reg_num001      register num 1
            JMP     reg_num010      register num 2
            JMP     reg_num011      register num 3
            JMP     reg_num100      register num 4
            JMP     reg_num101      register num 5
            JMP     reg_num110      register num 6
            JMP     reg_num111      register num 7
*---------------------------------------------------------------
*   Register Number Jump Table
*---------------------------------------------------------------
reg_num000  MOVE.B  #'0',(A6)+      register num 0
            RTS
reg_num001  MOVE.B  #'1',(A6)+      register num 1
            RTS
reg_num010  MOVE.B  #'2',(A6)+      register num 2
            RTS
reg_num011  MOVE.B  #'3',(A6)+      register num 3
            RTS            
reg_num100  MOVE.B  #'4',(A6)+      register num 4
            RTS
reg_num101  MOVE.B  #'5',(A6)+      register num 5
            RTS
reg_num110  MOVE.B  #'6',(A6)+      register num 7
            RTS
reg_num111  MOVE.B  #'7',(A6)+      register num 8
            RTS                        
*---------------------------------------------------------------
*   Print 4 spaces
*---------------------------------------------------------------
print4spcs  MOVE.B  #' ',(A6)+      Add ' ' to output
            MOVE.B  #' ',(A6)+      Add ' ' to output
            MOVE.B  #' ',(A6)+      Add ' ' to output
            MOVE.B  #' ',(A6)+      Add ' ' to output 
            RTS
*---------------------------------------------------------------
*   Print 5 spaces
*---------------------------------------------------------------
print5spcs  MOVE.B  #' ',(A6)+      Add ' ' to output
            MOVE.B  #' ',(A6)+      Add ' ' to output
            MOVE.B  #' ',(A6)+      Add ' ' to output
            MOVE.B  #' ',(A6)+      Add ' ' to output
            MOVE.B  #' ',(A6)+      Add ' ' to output  
            RTS
************************************************************
*   Error messages
************************************************************            
bad_size    MOVE.B  #'B',(A6)+      Add B to output
            MOVE.B  #'A',(A6)+      Add A to output
            MOVE.B  #'D',(A6)+      Add D to output
            MOVE.B  #' ',(A6)+      Add ' ' to output
            MOVE.B  #'S',(A6)+      Add S to output
            MOVE.B  #'I',(A6)+      Add I to output
            MOVE.B  #'Z',(A6)+      Add Z to output
            MOVE.B  #'E',(A6)+      Add E to output
            RTS  
bad_code    MOVE.B  #'B',(A6)+      Add B to output
            MOVE.B  #'A',(A6)+      Add A to output
            MOVE.B  #'D',(A6)+      Add D to output
            MOVE.B  #' ',(A6)+      Add ' ' to output
            MOVE.B  #'C',(A6)+      Add C to output
            MOVE.B  #'O',(A6)+      Add O to output
            MOVE.B  #'D',(A6)+      Add D to output
            MOVE.B  #'E',(A6)+      Add E to output            
            RTS
            
* Put variables and constants here
output  DS.B 80

done    CLR     D0
        END    START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
