.ORIG x3000  ; Mudhathir Sharif Khaja

; Prompt for the first binary number
BEGINNING
LEA R0, PROMPT1
PUTS
BRnzp INPUT_FIRST_NUMBER

INPUT_FIRST_NUMBER
LD R4, FOUR   ; Counter to ensure only four valid digits are entered
LOOP_FIRST
GETC
OUT          
LD R2, negq ; loads negative ASCII
ADD R1, R0, R2 ; subtracts to check if q 
BRz QUITGAME ; Check if the user entered 'q'
LD R6, ASCII_ZERO    
NOT R6, R6           
ADD R6, R6, #1       
ADD R1, R0, R6      
BRzp CHECK_FIRST_DIGIT ; If it's positive, it might be 0 or 1
BRnzp LOOP_FIRST   

CHECK_FIRST_DIGIT
LD R7, ASCII_TWO     ; Load ASCII value of '2'
NOT R7, R7
ADD R7, R7, x1
ADD R2, R0, R7       
BRn VALID_FIRST_DIGIT ; If negative, it's either 0 or 1, which is valid
BRzp INVALID_FIRST_DIGIT ; If zero, it's '2' which is invalid


INVALID_FIRST_DIGIT
BRnzp LOOP_FIRST   ; Loop back for the next character

VALID_FIRST_DIGIT
ADD R3, R3, R3 ; Shift left to make space for the new digit
ADD R3, R3, R1 
ADD R4, R4, #-1 
BRz FIRST_NUMBER_DONE ; If counter is zero, we have our number
BRnzp LOOP_FIRST

FIRST_NUMBER_DONE
LEA R0, PROMPT2
PUTS
BRnzp INPUT_SECOND_NUMBER

INPUT_SECOND_NUMBER
LD R4, FOUR
LOOP_SECOND

GETC
OUT
LD R2, negq ; loads negative ASCII
ADD R1, R0, R2 ; subtracts to check if q 
BRz QUITGAME
LD R6, ASCII_ZERO   ; Load ASCII value of '0'
NOT R6, R6          
ADD R6, R6, #1      
ADD R1, R0, R6      
BRzp CHECK_SECOND_DIGIT
BRnzp LOOP_SECOND

CHECK_SECOND_DIGIT
LD R7, ASCII_TWO     
NOT R7, R7
ADD R7, R7, x1
ADD R2, R0, R7       
BRn VALID_SECOND_DIGIT ; If negative, it's either 0 or 1, which is valid
BRzp INVALID_SECOND_DIGIT ; If zero, it's '2' which is invalid

INVALID_SECOND_DIGIT
BRnzp LOOP_SECOND

VALID_SECOND_DIGIT
ADD R5, R5, R5
ADD R5, R5, R1
ADD R4, R4, #-1 ; Decrease our counter
BRz COMPUTE_AND ; If counter is zero, we have our number
BRnzp LOOP_SECOND

;good


COMPUTE_AND
AND R3, R3, R5 ; AND the two numbers together
ST R3, RESULT



; Print the result
LEA R0, RESULT_MSG
PUTS


PRINT_RESULT    ; go through each bit, print 1 or 0


BIT_1
AND R2, R3, b1000
BRz print01
LD R0, ASCII_ONE
OUT

BIT_2
AND R2, R3, b0100
BRz print02
LD R0, ASCII_ONE
OUT

BIT_3
AND R2, R3, b0010
BRz print03
LD R0, ASCII_ONE
OUT

BIT_4
AND R2, R3, b0001
BRz print04
LD R0, ASCII_ONE
OUT
BR BEGINNING   ; go back to the top

print01
LD R0, ASCII_ZERO
OUT
BR BIT_2
print02
LD R0, ASCII_ZERO
OUT
BR BIT_3
print03
LD R0, ASCII_ZERO
OUT
BR BIT_4
print04
LD R0, ASCII_ZERO
OUT
BR BEGINNING   ; go back to the top








QUITGAME
LEA R0, QUITMSG
PUTS
HALT

; Data section
PROMPT1 .STRINGZ "\n Enter First Number (4 binary digits): "
PROMPT2 .STRINGZ "\n Enter Second Number (4 binary digits): "
RESULT_MSG .STRINGZ "\n The AND function of the two numbers is: "
QUITMSG .STRINGZ "\n Thank you for playing!"
FIRSTNUM .FILL x0000
SECONDNUM .FILL x0000
RESULT .FILL x0000
FOUR .FILL #4
ASCII_ZERO .FILL x0030   ; ASCII for '0'
ASCII_TWO .FILL x0032   ; ASCII for '2'
ASCII_ZEROS .STRINGZ "0"
ASCII_ONE .FILL x31
ASCII_ONES .STRINGZ "1"
negq	.fill xFF8F
.END

