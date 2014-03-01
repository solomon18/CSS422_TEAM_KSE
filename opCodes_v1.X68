*-----------------------------------------------------------
* Title      : 1st Jump table for main Opcode
* Written by : Alvaro Licea, Jr.
* Date       : 2-27-2014
* Description: Jump tables for the first 4 bits
*-----------------------------------------------------------
START    ORG    $1000

**********************************************************************
* main jump table for the first 4 bits (from the left)               *
**********************************************************************  
optable JSR op0000      * disassemble code that begins with 0000
        RTS
        JSR op0001      * disassemble code that begins with 0001
        RTS
        JSR op0010      * disassemble code that begins with 0010
        RTS
        JSR op0011      * disassemble code that begins with 0011
        RTS
        JSR op0100      * disassemble code that begins with 0100
        RTS
        JSR op0101      * disassemble code that begins with 0101
        RTS
        JSR op0110      * disassemble code that begins with 0110
        RTS
        JSR op0111      * disassemble code that begins with 0111
        RTS
        JSR op1000      * disassemble code that begins with 1000
        RTS
        JSR op1001      * disassemble code that begins with 1001
        RTS
        JSR op1010      * disassemble code that begins with 1010
        RTS
        JSR op1011      * disassemble code that begins with 1011
        RTS
        JSR op1100      * disassemble code that begins with 1100
        RTS
        JSR op1101      * disassemble code that begins with 1101
        RTS
        JSR op1110      * disassemble code that begins with 1110
        RTS
        JSR op1111      * disassemble code that begins with 1111
        RTS

**********************************************************************
* op0000 - disassembles code that begins with 0000                   *
**********************************************************************
op0000  MOVE.W  D7,D3       * move instruction for shifting
        LSR.W   #$8,D5      * get the next 4 bits by shifting
        ANDI.W  #$000F,D5   * turn the remaining bits to 0
        * next table lookup code goes here *
        RTS
    
**********************************************************************
* op0001 - disassembles MOVE.B                                       *
**********************************************************************
op0001  MOVE.Q  #$1,D3
        MOVE.B  #'M',(A4)+
        MOVE.B  #'O',(A4)+
        MOVE.B  #'V',(A4)+
        MOVE.B  #'E',(A4)+
        MOVE.B  #'.',(A4)+
        MOVE.B  #'B',(A4)+
        * next table lookup code goes here
        * send to ea code goes here
        * Put variables and constants here
        RTS
        
**********************************************************************
* op0010 - disassembles MOVE.L/MOVEA.L                               *
**********************************************************************
op0010  MOVE.Q  #$1,D3
        MOVE.B  #'M',(A4)+
        MOVE.B  #'O',(A4)+
        MOVE.B  #'V',(A4)+
        MOVE.B  #'E',(A4)+
        MOVE.B  #'.',(A4)+
        
        * next table lookup code goes here
        * send to ea code goes here
        * Put variables and constants here
        RTS

    END    START   

