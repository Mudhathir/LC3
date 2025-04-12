; iworm.asm
; Mudhathir Sharif Khaja 
; 11/14/2023
; This program draws lines by moving a 4x4 pixel box (the "pen")
; on a 128x124 pixel screen. The pen’s color and position change
; via keyboard inputs. The drawing starts from a specified memory 
; address and adheres to given graphical display and color encoding specs.

.ORIG x3000

; --- Register Usage ---
; R0: Current input character (or temporary for calculations)
; R1: Pen's color (or temporary value)
; R2: Temporary usage for comparisons and arithmetic
; R3: Pen's current position in screen memory (address where drawing occurs)
; R4: Used as flag for screen edge checks

; --- Initialize Pen (draw initial pen) and set its color and position ---
JSR DRAWPEN           ; Call DRAWPEN subroutine to draw the pen at its initial location
LD  R1, COLOR_WHITE   ; Load white color constant into R1 (starting color)
LD  R3, PEN_CURRENT   ; Load initial pen position address into R3

; --- Main Input Loop ---
INPUT_LOOP
    JSR DRAWPEN       ; Redraw the pen at the current position and color
    GETC              ; Read one character from the keyboard into R0
    ADD R0, R0, #-10  ; Subtract 10 (ASCII linefeed 'LF') from R0 to check for the "return" key
    BRz CLEARSCREEN   ; If the result is zero, the user pressed 'return' → branch to CLEARSCREEN subroutine
    ADD R0, R0, #10   ; Re-add 10 to restore the original character value in R0
    BR INPUTCHECK     ; Branch to the INPUTCHECK label to process the character

; --- Clear Screen Routine (invoked when return pressed) ---
; (This block immediately follows if CLEARSCREEN is not bypassed)
CLEARSCREEN
    AND R1, R1, #0    ; Clear R1 (here used to begin clearing)
    AND R0, R0, #0    ; Clear R0 (used as loop counter in clear routine)
    LD  R3, TOP_LEFT  ; Load the top-left address of the screen into R3
CLEARLOOP
    LD  R2, CLEAR_SCREEN ; Load the constant representing the number of pixels to clear
    STR R1, R3, #0    ; Write the cleared color (black, since R1 is 0) at the current screen location in R3
    ADD R3, R3, #1    ; Increment the screen pointer (move to the next pixel)
    ADD R0, R0, #1    ; Increment R0 (used as counter for cleared pixels)
    ADD R2, R2, R0   ; Adjust temporary value with R0 (used for branch condition)
    BRn CLEARLOOP     ; Loop until the counter indicates all pixels have been processed
    JSR DRAWPEN       ; Redraw the pen (after clearing the screen)
    ; Fall-through to continue below

; --- Process Input (Check for Commands) ---
INPUTCHECK
; The following instructions compare the key in R0 with expected ASCII codes
; for various commands and branch to corresponding subroutines.

    ; Check for quit command: 'q'
    LD  R2, q         ; Load ASCII value for 'q' into R2
    NOT R2, R2        ; Compute two's complement of 'q' value 
    ADD R2, R2, x1    ; Adjust (R2 now holds -('q'-1))
    ADD R2, R2, R0    ; Add input character to R2: if zero then key was 'q'
    BRz QUIT          ; Branch to QUIT if 'q' detected

    ; Check for change to red: 'r'
    LD  R2, ASCII_R1  ; Load ASCII value for 'r'
    NOT R2, R2        ; Compute two's complement for comparison
    ADD R2, R2, x1    ; Adjust value 
    ADD R2, R2, R0    ; Compare with input in R0
    BRz CHANGE_COLOR_RED  ; Branch if input equals 'r'

    ; Check for change to green: 'g'
    LD  R2, ASCII_G1  ; Load ASCII value for 'g'
    NOT R2, R2        ; Negate for comparison
    ADD R2, R2, x1    ; Adjust value
    ADD R2, R2, R0    ; Compare with input in R0
    BRz CHANGE_COLOR_GREEN ; Branch if input equals 'g'

    ; Check for change to blue: 'b'
    LD  R2, ASCII_B1  ; Load ASCII value for 'b'
    NOT R2, R2        ; Negate for comparison
    ADD R2, R2, x1    ; Adjust value
    ADD R2, R2, R0    ; Compare with input
    BRz CHANGE_COLOR_BLUE ; Branch if input equals 'b'

    ; Check for change to yellow: 'y'
    LD  R2, ASCII_Y1  ; Load ASCII value for 'y'
    NOT R2, R2        ; Negate for comparison
    ADD R2, R2, x1    ; Adjust value
    ADD R2, R2, R0    ; Compare with input
    BRz CHANGE_COLOR_YELLOW ; Branch if input equals 'y'

    ; Check for change to white: ' ' (space)
    LD  R2, ASCII_SPACE ; Load ASCII value for space
    NOT R2, R2        ; Negate for comparison
    ADD R2, R2, x1    ; Adjust value
    ADD R2, R2, R0    ; Compare with input
    BRz CHANGE_COLOR_WHITE ; Branch if input equals space

    ; Check for moving up: 'w'
    LD  R2, ASCII_W1  ; Load ASCII value for 'w'
    NOT R2, R2        ; Negate for comparison
    ADD R2, R2, x1    ; Adjust value
    ADD R2, R2, R0    ; Compare with input
    BRz MOVE_UP       ; Branch if input equals 'w'

    ; Check for moving left: 'a'
    LD  R2, ASCII_A1  ; Load ASCII value for 'a'
    NOT R2, R2        ; Negate for comparison
    ADD R2, R2, x1    ; Adjust value
    ADD R2, R2, R0    ; Compare with input
    BRz MOVE_LEFT     ; Branch if input equals 'a'

    ; Check for moving down: 's'
    LD  R2, ASCII_S1  ; Load ASCII value for 's'
    NOT R2, R2        ; Negate for comparison
    ADD R2, R2, x1    ; Adjust value
    ADD R2, R2, R0    ; Compare with input
    BRz MOVE_DOWN     ; Branch if input equals 's'

    ; Check for moving right: 'd'
    LD  R2, ASCII_D1  ; Load ASCII value for 'd'
    NOT R2, R2        ; Negate for comparison
    ADD R2, R2, x1    ; Adjust value
    ADD R2, R2, R0    ; Compare with input
    BRz MOVE_RIGHT    ; Branch if input equals 'd'

    BR INPUT_LOOP     ; If none of the above, go back to INPUT_LOOP

; --- Subroutines for Changing Pen Color ---
CHANGE_COLOR_RED
    LD  R1, COLOR_RED     ; Load red color constant into R1
    ST  R1, CURRENT_COLOR ; Store the new color as the current color
    BR INPUT_LOOP         ; Return to the input loop

CHANGE_COLOR_GREEN
    LD  R1, COLOR_GREEN   ; Load green color constant into R1
    ST  R1, CURRENT_COLOR ; Update current color to green
    BR INPUT_LOOP

CHANGE_COLOR_BLUE
    LD  R1, COLOR_BLUE    ; Load blue color constant into R1
    ST  R1, CURRENT_COLOR ; Update current color to blue
    BR INPUT_LOOP

CHANGE_COLOR_YELLOW
    LD  R1, COLOR_YELLOW  ; Load yellow color constant into R1
    ST  R1, CURRENT_COLOR ; Update current color to yellow
    BR INPUT_LOOP

CHANGE_COLOR_WHITE
    LD  R1, COLOR_WHITE   ; Load white color constant into R1
    ST  R1, CURRENT_COLOR ; Update current color to white
    BR INPUT_LOOP

CHANGE_COLOR_BLACK 
    LD  R1, COLOR_BLACK   ; Load black color constant into R1
    ST  R1, CURRENT_COLOR ; Update current color to black
    BR INPUT_LOOP

; --- Subroutines for Moving the Pen ---
MOVE_UP 
    JSR CHECKBORDER_UP    ; Check if moving up would cross the top border
    ADD R4, R4, #0       ; (R4 is used as a flag for border; if positive, movement is blocked)
    BRp INPUT_LOOP       ; If at top border, do not move: return to input loop
    LD  R3, PEN_CURRENT  ; Load current pen position
    LD  R5, W            ; Load the vertical increment value (W for upward movement)
    ADD R3, R3, R5       ; Adjust pen position upward (address arithmetic)
    ST  R3, PEN_CURRENT  ; Store updated pen position
    LD  R2, PEN_Y        ; Load current Y coordinate of pen
    ADD R2, R2, #-4      ; Subtract 4 from Y to move up
    ST  R2, PEN_Y        ; Save new Y coordinate
    JSR DRAWPEN          ; Redraw the pen at the new position
    BR INPUT_LOOP        ; Go back to input loop

MOVE_LEFT 
    JSR CHECKBORDER_LEFT  ; Check left border conditions
    ADD R4, R4, #0        ; If flagged, no move occurs
    BRp INPUT_LOOP
    LD  R3, PEN_CURRENT   ; Load current pen position
    LD  R5, A             ; Load the left movement offset (A)
    ADD R3, R3, R5        ; Subtract offset for left movement
    ST  R3, PEN_CURRENT   ; Save new pen position
    LD  R2, PEN_X         ; Load current X coordinate of pen
    ADD R2, R2, #-4       ; Subtract 4 to move left
    ST  R2, PEN_X         ; Save new X coordinate
    JSR DRAWPEN           ; Redraw the pen in the new position
    BR INPUT_LOOP         ; Return to input loop

MOVE_DOWN
    JSR CHECKBORDER_DOWN   ; Check lower border condition
    ADD R4, R4, #0         ; If border flag is set, do not move
    BRp INPUT_LOOP
    LD  R3, PEN_CURRENT    ; Load current pen position
    LD  R5, S              ; Load downward movement offset (S)
    ADD R3, R3, R5         ; Adjust pen position downward
    ST  R3, PEN_CURRENT    ; Save updated position
    LD  R2, PEN_Y          ; Load current Y coordinate
    ADD R2, R2, #4         ; Add 4 to move down
    ST  R2, PEN_Y          ; Save new Y value
    JSR DRAWPEN            ; Redraw the pen
    BR INPUT_LOOP          ; Go back to the input loop

MOVE_RIGHT
    JSR CHECKBORDER_RIGHT  ; Check right border condition
    ADD R4, R4, #0         ; If at border, no move occurs
    BRp INPUT_LOOP
    LD  R3, PEN_CURRENT    ; Load current pen position
    LD  R5, D              ; Load right movement offset (D)
    ADD R3, R3, R5         ; Adjust pen position to move right
    ST  R3, PEN_CURRENT    ; Update pen position in memory
    LD  R2, PEN_X          ; Load current X coordinate of pen
    ADD R2, R2, #4         ; Add 4 to move right
    ST  R2, PEN_X          ; Save new X coordinate
    JSR DRAWPEN            ; Redraw the pen
    BR INPUT_LOOP          ; Return to input loop

; --- Subroutine: DRAWPEN ---
; Draws a 4x4 pixel box at the current pen position (PEN_CURRENT)
DRAWPEN
    LD  R1, CURRENT_COLOR  ; Load the current pen color from memory
    LD  R5, DOWN           ; Load the row offset value (DOWN) for moving one screen row
    LD  R6, PEN_CURRENT    ; Load current pen position into R6

    ; Draw the first row (4 pixels in a row)
    STR R1, R6, #0         ; Draw pixel at current position
    STR R1, R6, #1         ; Draw pixel one column to the right
    STR R1, R6, #2         ; Draw pixel two columns to the right
    STR R1, R6, #3         ; Draw pixel three columns to the right

    ; Move to the second row: add row offset
    ADD R6, R6, R5         ; Move pointer down to the next row
    STR R1, R6, #0         ; Draw entire row similarly
    STR R1, R6, #1
    STR R1, R6, #2
    STR R1, R6, #3

    ; Third row
    ADD R6, R6, R5         ; Advance to next row
    STR R1, R6, #0
    STR R1, R6, #1
    STR R1, R6, #2
    STR R1, R6, #3

    ; Fourth row
    ADD R6, R6, R5         ; Advance to final row of the box
    STR R1, R6, #0
    STR R1, R6, #1
    STR R1, R6, #2
    STR R1, R6, #3

    RET                    ; Return from DRAWPEN subroutine

; --- Border Check Subroutines ---
; These subroutines check if the pen (box) is about to cross a screen border.
; They set R4 to 1 if movement is disallowed (i.e. border reached).

; Check for top border (moving up)
CHECKBORDER_UP
    LD  R2, PEN_Y        ; Load current Y coordinate of the pen
    ADD R2, R2, #-4      ; Calculate new Y if moving up 4 pixels
    BRnz UP_BORDER       ; If nonzero, then movement would cross border → branch to UP_BORDER
    AND R4, R4, #0       ; Otherwise, clear R4 (no border hit)
    BR SKIP_UP           ; Skip further action
UP_BORDER
    AND R4, R4, #0       ; Clear R4 then...
    ADD R4, R4, #1       ; ...set R4 = 1 (indicating top border reached)
SKIP_UP
    RET

; Check for bottom border (moving down)
CHECKBORDER_DOWN
    LD  R2, PEN_Y        ; Load current Y coordinate of pen
    ADD R2, R2, #4       ; Calculate new Y if moving down 4 pixels
    LD  R3, BOTTOM_BORDER; Load bottom border constant
    NOT R3, R3           ; Compute two’s complement of border constant
    ADD R3, R3, #1       ; Adjust R3 to compare properly
    ADD R3, R3, R2       ; Add new Y to adjusted border value
    BRzp DOWN_BORDER     ; If result is non-negative, border is reached → branch
    AND R4, R4, #0       ; Otherwise, clear R4 (no border violation)
    BR SKIP_DOWN
DOWN_BORDER
    AND R4, R4, #0       ; Clear R4 and then...
    ADD R4, R4, #1       ; ...set flag to 1 indicating bottom border reached
SKIP_DOWN
    RET

; Check for left border (moving left)
CHECKBORDER_LEFT
    LD  R2, PEN_X        ; Load current X coordinate of pen
    ADD R2, R2, #-4      ; Calculate new X if moving left
    BRnz LEFT_BORDER     ; If result is nonzero (movement beyond left edge), branch
    AND R4, R4, #0       ; Otherwise, clear R4 (movement allowed)
    BR SKIP_LEFT
LEFT_BORDER
    AND R4, R4, #0       ; Clear R4 and then...
    ADD R4, R4, #1       ; ...set flag to 1 indicating left border reached
SKIP_LEFT
    RET

; Check for right border (moving right)
CHECKBORDER_RIGHT
    LD  R2, PEN_X        ; Load current X coordinate of pen
    ADD R2, R2, #4       ; Calculate new X if moving right
    LD  R3, RIGHT_BORDER ; Load right border constant
    NOT R3, R3           ; Compute two’s complement of the constant
    ADD R3, R3, #1       ; Adjust for proper comparison
    ADD R3, R3, R2       ; Compare new X with right border limit
    BRzp RIGHT1_BORDER   ; If non-negative, border would be crossed → branch
    AND R4, R4, #0       ; Otherwise, clear border flag in R4
    BR SKIP_RIGHT
RIGHT1_BORDER
    AND R4, R4, #0       ; Clear R4, then...
    ADD R4, R4, #1       ; ...set flag to 1 (right border reached)
SKIP_RIGHT
    RET

; --- QUIT and Halt Subroutine ---
QUIT
    HALT                ; Terminate the program

; --- Constants and Data Definitions ---
PEN_CURRENT    .FILL xDF40    ; Initial pen position (address); e.g., (64, 62) on screen
COLOR_WHITE    .FILL x7FFF    ; White color code
COLOR_RED      .FILL x7C00    ; Red color code
COLOR_BLUE     .FILL x001F    ; Blue color code
COLOR_YELLOW   .FILL x7FED    ; Yellow color code
COLOR_GREEN    .FILL x03E0    ; Green color code
COLOR_BLACK    .FILL x0000    ; Black color code

ASCII_W1       .FILL #119     ; ASCII value for 'w' (up)
ASCII_A1       .FILL #97      ; ASCII value for 'a' (left)
ASCII_S1       .FILL #115     ; ASCII value for 's' (down)
ASCII_D1       .FILL #100     ; ASCII value for 'd' (right)
ASCII_SPACE    .FILL #32      ; ASCII value for space (color change to white in this case)
ASCII_R1       .FILL x0072    ; ASCII value for 'r' (change color to red)
ASCII_G1       .FILL x0067    ; ASCII value for 'g' (change color to green)
ASCII_B1       .FILL x0062    ; ASCII value for 'b' (change color to blue)
ASCII_Y1       .FILL #121     ; ASCII value for 'y' (change color to yellow)

; Screen memory boundaries and constants
SCREEN_START   .FILL xF000    ; Start address of video memory
SCREEN_END     .FILL xF3FF    ; End address of video memory
q              .FILL x0071    ; ASCII value for 'q' (quit command)
CURRENT_COLOR  .FILL x7FFF    ; Initial current color (white)

; Movement constants for coordinate arithmetic
W              .FILL #-512    ; Vertical offset for moving up (example value)
A              .FILL #-4      ; Left movement offset
S              .FILL #512     ; Vertical offset for moving down
D              .FILL #4       ; Right movement offset
PEN_X          .FILL #64      ; Initial X coordinate of pen
PEN_Y          .FILL #62      ; Initial Y coordinate of pen

BOTTOM_BORDER  .FILL #120     ; Y coordinate for bottom border
RIGHT_BORDER   .FILL #124     ; X coordinate for right border
CLEAR_SCREEN   .FILL #-15872  ; Total number of screen pixels to clear (for clear routine)
TOP_LEFT       .FILL xC000    ; Memory address of top-left corner of the screen

.END
