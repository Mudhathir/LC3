.ORIG x3000                       ; Program starts at address x3000; Mudhathir Sharif Khaja

;-------------------------------
; Prompt and Input for First Binary Number
;-------------------------------
BEGINNING                         ; Entry point for the program – start by prompting for the first number
    LEA R0, PROMPT1               ; Load the effective address of PROMPT1 into R0 (the first prompt string)
    PUTS                        ; Print the prompt string stored at PROMPT1
    BRnzp INPUT_FIRST_NUMBER    ; Unconditionally branch to the label INPUT_FIRST_NUMBER

INPUT_FIRST_NUMBER                ; Label: Begin input routine for the first binary number
    LD R4, FOUR                 ; Load the constant FOUR (i.e., 4) into R4 – counter for 4 digits
LOOP_FIRST                        ; Label: Start of loop to receive each digit for the first number
    GETC                        ; Read a single character from input into R0
    OUT                         ; Echo the character back to the console
    LD R2, negq                 ; Load the constant negq into R2 (used for subtracting to check for 'q')
    ADD R1, R0, R2              ; Subtract negq from the input character; if result is zero, user entered 'q'
    BRz QUITGAME                ; If the result is zero, branch to QUITGAME to exit the program
    LD R6, ASCII_ZERO           ; Load ASCII value for '0' into R6
    NOT R6, R6                  ; Compute the one's complement of ASCII '0' in R6
    ADD R6, R6, #1              ; Complete two's complement conversion (R6 now equals -ASCII '0')
    ADD R1, R0, R6              ; Subtract ASCII '0' from the input character (digit conversion: char - '0')
    BRzp CHECK_FIRST_DIGIT      ; If the result is non-negative, branch to check if the digit is valid (0 or 1)
    BRnzp LOOP_FIRST            ; Otherwise, loop back to get a valid character

CHECK_FIRST_DIGIT               ; Label: Check whether the first digit is valid (i.e., less than 2)
    LD R7, ASCII_TWO            ; Load ASCII value for '2' into R7
    NOT R7, R7                  ; Compute one's complement of '2' (to prepare for subtraction)
    ADD R7, R7, x1              ; Complete two's complement (R7 now equals -ASCII '2')
    ADD R2, R0, R7              ; Subtract ASCII '2' from the input; negative result indicates digit < 2
    BRn VALID_FIRST_DIGIT       ; If result is negative, the digit is valid (either 0 or 1); branch accordingly
    BRzp INVALID_FIRST_DIGIT    ; If result is zero or positive, the digit is invalid; branch to INVALID_FIRST_DIGIT

INVALID_FIRST_DIGIT             ; Label: Handle invalid digit for first number (digit is not 0 or 1)
    BRnzp LOOP_FIRST            ; Loop back to get another character

VALID_FIRST_DIGIT               ; Label: Valid first digit has been entered
    ADD R3, R3, R3              ; Shift the existing value in R3 left by 1 (prepare to add a new bit)
    ADD R3, R3, R1              ; Add the current valid digit (0 or 1) to R3
    ADD R4, R4, #-1             ; Decrement the digit counter in R4 by 1
    BRz FIRST_NUMBER_DONE       ; If R4 equals zero (all 4 digits entered), branch to FIRST_NUMBER_DONE
    BRnzp LOOP_FIRST            ; Otherwise, loop back to read the next digit

FIRST_NUMBER_DONE               ; Label: Completed input for the first number
    LEA R0, PROMPT2             ; Load effective address of the prompt for the second number into R0
    PUTS                        ; Print the second prompt string
    BRnzp INPUT_SECOND_NUMBER   ; Branch to INPUT_SECOND_NUMBER to begin input for the second number

;-------------------------------
; Input for Second Binary Number
;-------------------------------
INPUT_SECOND_NUMBER             ; Label: Begin input routine for the second binary number
    LD R4, FOUR                 ; Reload the counter (4) into R4 for the second number digits
LOOP_SECOND                     ; Label: Start of loop to receive each digit for the second number
    GETC                        ; Read a character from input into R0
    OUT                         ; Echo the character to the console
    LD R2, negq                 ; Load the negative constant to check for 'q'
    ADD R1, R0, R2              ; Subtract to see if the character equals 'q'
    BRz QUITGAME                ; If zero, branch to QUITGAME
    LD R6, ASCII_ZERO           ; Load ASCII code for '0' into R6
    NOT R6, R6                  ; Compute one's complement of ASCII '0'
    ADD R6, R6, #1              ; Complete two's complement conversion of '0'
    ADD R1, R0, R6              ; Subtract ASCII '0' from the input character
    BRzp CHECK_SECOND_DIGIT     ; If result non-negative, branch to check if digit is valid
    BRnzp LOOP_SECOND           ; Otherwise, loop back for input

CHECK_SECOND_DIGIT              ; Label: Check digit validity for the second number
    LD R7, ASCII_TWO            ; Load ASCII value for '2' into R7
    NOT R7, R7                  ; Compute one's complement of '2'
    ADD R7, R7, x1              ; Complete conversion so R7 equals -ASCII '2'
    ADD R2, R0, R7              ; Subtract ASCII '2' from input to verify digit is less than 2
    BRn VALID_SECOND_DIGIT      ; If negative, the digit is valid (0 or 1); branch accordingly
    BRzp INVALID_SECOND_DIGIT   ; Otherwise, digit is invalid; branch to INVALID_SECOND_DIGIT

INVALID_SECOND_DIGIT            ; Label: Handle invalid digit for second number
    BRnzp LOOP_SECOND           ; Loop back to get a valid input character

VALID_SECOND_DIGIT              ; Label: A valid digit for the second number has been entered
    ADD R5, R5, R5              ; Shift the existing value in R5 left by 1 (to make room for the new digit)
    ADD R5, R5, R1              ; Add the valid digit to R5
    ADD R4, R4, #-1             ; Decrement the digit counter (R4)
    BRz COMPUTE_AND             ; If counter reaches zero (4 digits collected), branch to COMPUTE_AND
    BRnzp LOOP_SECOND           ; Otherwise, loop back for the next digit

;-------------------------------
; Compute Bitwise AND of the Two Numbers
;-------------------------------
COMPUTE_AND                     ; Label: Ready to compute the AND operation between the two binary numbers
    AND R3, R3, R5            ; Perform bitwise AND between the first number (R3) and the second number (R5); result stored in R3
    ST R3, RESULT             ; Store the result from R3 into memory location RESULT

;-------------------------------
; Display the Result
;-------------------------------
    LEA R0, RESULT_MSG         ; Load address of RESULT_MSG into R0 (result message prompt)
    PUTS                      ; Print the result message to the console

PRINT_RESULT                    ; Label: Begin printing the resulting binary number bit-by-bit

;--- Process Bit 1 (Most Significant Bit) ---
BIT_1                           ; Label: Process first (MSB) bit
    AND R2, R3, b1000         ; Isolate bit 1 by ANDing with binary 1000 (8)
    BRz print01              ; If bit 1 is zero, branch to print '0'
    LD R0, ASCII_ONE         ; Otherwise, load ASCII for '1' into R0
    OUT                      ; Output '1'

;--- Process Bit 2 ---
BIT_2                           ; Label: Process second bit
    AND R2, R3, b0100         ; Isolate bit 2 using binary 0100 (4)
    BRz print02              ; If zero, branch to print '0'
    LD R0, ASCII_ONE         ; Otherwise, load ASCII for '1'
    OUT                      ; Output '1'

;--- Process Bit 3 ---
BIT_3                           ; Label: Process third bit
    AND R2, R3, b0010         ; Isolate bit 3 using binary 0010 (2)
    BRz print03              ; If zero, branch to print '0'
    LD R0, ASCII_ONE         ; Otherwise, load ASCII for '1'
    OUT                      ; Output '1'

;--- Process Bit 4 (Least Significant Bit) ---
BIT_4                           ; Label: Process fourth bit
    AND R2, R3, b0001         ; Isolate bit 4 using binary 0001 (1)
    BRz print04              ; If zero, branch to print '0'
    LD R0, ASCII_ONE         ; Otherwise, load ASCII for '1'
    OUT                      ; Output '1'
    BR BEGINNING             ; After printing all bits, branch back to BEGINNING for a new round

;--- Print Zero for Bits that are Zero ---
print01                         ; Label: Print '0' for bit 1 when zero detected
    LD R0, ASCII_ZERO        ; Load ASCII for '0'
    OUT                      ; Output '0'
    BR BIT_2                ; Continue to print bit 2

print02                         ; Label: Print '0' for bit 2
    LD R0, ASCII_ZERO        ; Load ASCII for '0'
    OUT                      ; Output '0'
    BR BIT_3                ; Continue to print bit 3

print03                         ; Label: Print '0' for bit 3
    LD R0, ASCII_ZERO        ; Load ASCII for '0'
    OUT                      ; Output '0'
    BR BIT_4                ; Continue to print bit 4

print04                         ; Label: Print '0' for bit 4
    LD R0, ASCII_ZERO        ; Load ASCII for '0'
    OUT                      ; Output '0'
    BR BEGINNING             ; Branch back to BEGINNING (restart the process)

;-------------------------------
; Quit Option Handling
;-------------------------------
QUITGAME                        ; Label: User chose to quit the game
    LEA R0, QUITMSG          ; Load effective address of QUITMSG (goodbye message) into R0
    PUTS                     ; Print the quit message
    HALT                     ; Halt program execution

;-------------------------------
; Data Section
;-------------------------------
PROMPT1    .STRINGZ "\n Enter First Number (4 binary digits): "   ; Prompt string for first number input
PROMPT2    .STRINGZ "\n Enter Second Number (4 binary digits): "  ; Prompt string for second number input
RESULT_MSG .STRINGZ "\n The AND function of the two numbers is: "  ; Message displayed before printing the result
QUITMSG    .STRINGZ "\n Thank you for playing!"                   ; Exit message when user quits
FIRSTNUM   .FILL x0000             ; Memory space for first number (initialized to 0)
SECONDNUM  .FILL x0000             ; Memory space for second number (initialized to 0)
RESULT     .FILL x0000             ; Memory location to store the AND result (initialized to 0)
FOUR       .FILL #4                ; Constant (4) used as counter for digit input
ASCII_ZERO .FILL x0030             ; ASCII code for '0'
ASCII_TWO  .FILL x0032             ; ASCII code for '2'
ASCII_ZEROS .STRINGZ "0"           ; String "0" for reference (if needed)
ASCII_ONE  .FILL x0031             ; ASCII code for '1' (ensure leading zero is included)
ASCII_ONES .STRINGZ "1"            ; String "1" for reference (if needed)
negq       .FILL xFF8F             ; Constant to check for negative 'q' input (tuned for character checking)

.END                            ; End of program
