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
            LEA         greet,A1             *Load greeting address to A1
            TRAP        #15                    *Run
            
            MOVE.B      #task2,D0           *D0 input from user
            LEA         decision,A1        *Input ptr to A1
            TRAP        #15                     *Run
            
            MOVE.B      (A1),D2                *D2 holds first byte of input
            CMPI.B      #UCY,D2             *Check if D2 == Y
            BEQ         begin                 *Start disassembling
            CMPI.B      #LCY,D2             *Check if D2 == y
            BEQ         begin                 *Start disassembling
            CMPI.B      #UCN,D2             *Check if D2 == N
            BEQ         stop                   *Stop
            CMPI.B      #LCN,D2             *Check if D2 == n                        
            BEQ         stop                   *Stop                               
              
*-----------------------------------------------------------
*       Begin(Starting address)
*
*-----------------------------------------------------------
begin       JSR         *clr reg
            MOVE.B      #task1,D0           *holds input from user
            LEA         startAddr,A1       *A1 holds string prompt for startAddr
            TRAP        #15                   
            
            MOVE.B      #task2,D0           *holds task2, get input
            
            
            CMPI.B      #00,D1
                
                
                


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
byteL          EQU     08                   *Byte/Address = 8 bytes
wordL         EQU     04                   *word              = 4 bytes

*-----------------------------------------------------------
*       I/O Prompts Jump Table
*
*-----------------------------------------------------------
greet           DC.B        CR,LF,'TEAM KSE Disassembler - CSS422 Winter 2014',CR,LF
                DC.B        'Ready to start?',CR,LF
                DC.B        'Please enter Yes or No (Y/N)'

startAddr       DC.B        'Please enter a Starting Address',CR,LF
                DC.B        'Starting address must be greater than $00002000 and smaller than $000FFFFF',CR,LF

endAddr         DC.B        'Please enter an Ending Address',CR,LF
                DC.B        'Ending addtess must be less than $000FFFFF and ONE WORD greater than Starting address',CR,LF
                   
startError      DC.B        'Invalid Starting address',CR,LF
                DC.B         'Starting address must be above $00002000',CR,LF
                DC.B         'and below $000FFFFF',CR,LF

endError        DC.B         'Invalid End address',CR,LF
                DC.B         'Ending address must be at least  ONE WORD greater than Starting address',CR,LF
                DC.B         'and smaller than $000FFFFF',CR,LF

stop            STOP     #$2700                               

*-----------------------------------------------------------
*       I/O Variables
*
*-----------------------------------------------------------
decision	   DS.B	 20	            *to hold User's Response

*-----------------------------------------------------------
*      Clear registers
*
*-----------------------------------------------------------
clr             CLR         

    END    START        ; last line of source



