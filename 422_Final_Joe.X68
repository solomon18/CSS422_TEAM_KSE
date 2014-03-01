*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
* Displays greeting to user

*-----------------------------------------------------------
*       Greetings
*
*-----------------------------------------------------------
greeting    MOVE.B      #task0,D0           *Start of greeting, Loads D0 with greet
                  LEA            greet,A1             *Load greeting address to A1
                 TRAP          #15                    *Run
                 
                 MOVE.B     #task2,D0           *D0 input from user
                 LEA            decision,A1        *Input ptr to A1
                 TRAP         #15                     *Run
                 
                 MOVE.B     (A1),D2                *D2 holds first byte of input
                 CMPI.B       #UCY,D2             *Check if D2 == Y
                 BEQ            begin                 *Start disassembling
                 CMPI.B       #LCY,D2             *Check if D2 == y
                 BEQ            begin                 *Start disassembling
                 CMPI.B       #UCN,D2             *Check if D2 == N
                 BEQ            stop                   *Stop
                 CMPI.B       #LCN,D2             *Check if D2 == n                        
                 BEQ            stop                   *Stop                 


*-----------------------------------------------------------
*       I/O Routine
*
*-----------------------------------------------------------
LF               EQU     $0A                 *ASCII value for Line feed
CR              EQU     $0D                 *ASCII value for Carriage return
task0           EQU     00                  *Task0 from Berger, print string w/ newline
task1           EQU     01                  *Task1 from Berger, prompt for input w/o newline
task2           EQU     02                  *Task2 from Berger, prompt and wait for input
UCN            EQU     $4E                 *ASCII value for N for User Prompt
LCN            EQU     $6E                 *ASCII value for n for User Prompt
UCY            EQU     $59                 *ASCII value for Y for User Prompt
LCY            EQU     $79                 *ASCII value for y for User Prompt

*-----------------------------------------------------------
*       I/O Prompts Jump Table
*
*-----------------------------------------------------------
greet           DC.B        CR,LF,'TEAM KSE Disassembler - CSS422 Winter 2014',CR,LF
                   DC.B        'Ready to start?',CR,LF
                   DC.B        'Please enter Yes or No (Y/N)'
                                

*-----------------------------------------------------------
*       I/O Variables
*
*-----------------------------------------------------------
decision	   DS.B	 20	            *to hold User's Response

*-----------------------------------------------------------
*       I/O Error Flags
*
*-----------------------------------------------------------
stop            STOP     #$2700


    END    START        ; last line of source

