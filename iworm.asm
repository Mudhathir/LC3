;iworm.asm
;Mudhathir Sharif Khaja 
;11/14/2023
;This program draws lines by moving a 4x4 pixel box on a 128x124 pixel screen, changing its color and position using keyboard inputs, starting from a specific memory address and adhering to graphical display and color encoding specifications.

.ORIG x3000

; Register usage:
; R0: Current input character
; R1: Pen's color
; R2: Temp usage
; R3: Pen's position on screen memory
; R4: Screen edge check

; Initialize Pen position and color
JSR DRAWPEN   ; Call the subroutine to draw pen at initial 
LD R1, COLOR_WHITE
LD R3, PEN_CURRENT

; Input loop
INPUT_LOOP
    JSR DRAWPEN
    GETC           ; Read character from keyboard
    ADD R0, R0, #-10 ; Subtract ASCII value of 'LF' to check for 'return' key
    BRz CLEARSCREEN ; If 'return' key, clear screen
    ADD R0, R0, #10  ; Re-add ASCII value of 'LF'
    BR INPUTCHECK
    CLEARSCREEN
    AND R1, R1, #0 
    AND R0, R0, #0
    LD R3, TOP_LEFT
    CLEARLOOP
    LD R2, CLEAR_SCREEN
    STR R1, R3, #0
    ADD R3, R3, #1
    ADD R0, R0, #1
    ADD R2, R2, R0
    BRn CLEARLOOP
    JSR DRAWPEN



    



 INPUTCHECK
;p3os
    ; Check for color change ; for check color look at how we look at q for the previous code, reconfigure rgbyw
    LD R2, q ; Subtract ASCII value of 'q'
    NOT R2, R2
    ADD R2, R2, x1
    ADD R2, R2, R0
    BRz QUIT
    LD R2, ASCII_R1 ; Subtract ASCII value of 'r'
    NOT R2, R2
    ADD R2, R2, x1
    ADD R2, R2, R0
    BRz CHANGE_COLOR_RED
    Ld R2, ASCII_G1  ; Adjust for next color check
    NOT R2, R2
    ADD R2, R2, x1
    ADD R2, R2, R0
    BRz CHANGE_COLOR_GREEN
    LD R2, ASCII_B1 ; Adjust for next color check
    NOT R2, R2
    ADD R2, R2, x1
    ADD R2, R2, R0
    BRz CHANGE_COLOR_BLUE
    LD R2, ASCII_Y1  ; Adjust for next color check
    NOT R2, R2
    ADD R2, R2, x1
    ADD R2, R2, R0
    BRz CHANGE_COLOR_YELLOW
    LD R2, ASCII_SPACE ; Adjust for next color check
    NOT R2, R2
    ADD R2, R2, x1
    ADD R2, R2, R0
    BRz CHANGE_COLOR_WHITE

    
   
    LD R2, ASCII_W1
    NOT R2, R2 ; subtract check for up
    ADD R2, R2, x1
    ADD R2, R2, R0
    BRz MOVE_UP
    LD R2, ASCII_A1
    NOT R2, R2 ; subtract check for left
    ADD R2, R2, x1
    ADD R2, R2, R0
    BRz MOVE_LEFT
    LD R2, ASCII_S1
    NOT R2, R2 ; subtract check for down
    ADD R2, R2, x1
    ADD R2, R2, R0
    BRz MOVE_DOWN
    LD R2, ASCII_D1
    NOT R2, R2 ;subtract check for right
    ADD R2, R2, x1
    ADD R2, R2, R0
    BRz MOVE_RIGHT
    Br INPUT_LOOP

    CHANGE_COLOR_GREEN
    LD R1, COLOR_GREEN ; Load the green color code into register R1.
    ST R1, CURRENT_COLOR
    Br INPUT_LOOP 


    CHANGE_COLOR_RED
    LD R1, COLOR_RED ; Load the red color code into register R1.
    ST R1, CURRENT_COLOR
    Br INPUT_LOOP


    CHANGE_COLOR_BLUE
    LD R1, COLOR_BLUE  ; Load the blue color code into register R1.
    ST R1, CURRENT_COLOR
    Br INPUT_LOOP

    CHANGE_COLOR_YELLOW
    LD R1, COLOR_YELLOW   ; Load the yellow color code into register R1.
    ST R1, CURRENT_COLOR
    Br INPUT_LOOP


   CHANGE_COLOR_WHITE
   LD R1, COLOR_WHITE   ; Load the white color code into register R1.
   ST R1, CURRENT_COLOR
   Br INPUT_LOOP

   CHANGE_COLOR_BLACK 
   LD R1, COLOR_BLACK ; Load the black color code into register R1.
   ST R1, CURRENT_COLOR
   Br INPUT_LOOP






  

    MOVE_UP 
    JSR CHECKBORDER_UP   ;check border going up
    ADD R4, R4, #0
    BRp INPUT_LOOP  ;If Pen is at the top border , return to input loop, no move
   LD R3, PEN_CURRENT
   LD R5, W
   ADD R3, R3, R5
   ST R3, PEN_CURRENT
   LD R2, PEN_Y
   ADD R2, R2, #-4    ; Update the Y coordinate to reflect the move up
   ST R2, PEN_Y
   JSR DRAWPEN
   BR INPUT_LOOP
	
    MOVE_LEFT 
    JSR CHECKBORDER_LEFT ;check border going left
    ADD R4, R4, #0
    BRp INPUT_LOOP
    LD R3, PEN_CURRENT
    LD R5, A
    ADD R3, R3, R5
    ST R3, PEN_CURRENT
    LD R2, PEN_X
    ADD R2, R2, #-4 ; Update the X coordinate to reflect the move left
    ST R2, PEN_X
    JSR DRAWPEN
    BR INPUT_LOOP

    MOVE_DOWN
    JSR CHECKBORDER_DOWN   ;check border going down
    ADD R4, R4, #0
    BRp INPUT_LOOP
    LD R3, PEN_CURRENT
    LD R5, S
    ADD R3, R3, R5
    ST R3, PEN_CURRENT
    LD R2, PEN_Y
    ADD R2, R2, #4
    ST R2, PEN_Y
    JSR DRAWPEN
    Br INPUT_LOOP

    MOVE_RIGHT
    JSR CHECKBORDER_RIGHT   ; check border going right
    ADD R4, R4, #0
    BRp INPUT_LOOP
    LD R3, PEN_CURRENT
    LD R5, D
    ADD R3, R3, R5
    ST R3, PEN_CURRENT
    LD R2, PEN_X
    ADD R2, R2, #4
    ST R2, PEN_X
    JSR DRAWPEN
    Br INPUT_LOOP



;subroutine for the pen
    DRAWPEN
    LD R1, CURRENT_COLOR
    LD R5, DOWN
    LD R6, PEN_CURRENT
    ; Draw the first row of the 4 x 4 Box
    STR R1, R6, #0 ; Store the color in R1 to the current position 
    STR R1, R6, #1  ;store the color in R1 to one pixel right of the current
    STR R1, R6, #2 ;Store the color in R1 to two pixels right of the current 
    STR R1, R6, #3 ; Store the color in R1 to three pixels right of the current

    ;Move down one row to draw second row
    ADD R6, R6, R5
    STR R1, R6, #0
    STR R1, R6, #1
    STR R1, R6, #2
    STR R1, R6, #3

    ADD R6, R6, R5
    STR R1, R6, #0
    STR R1, R6, #1
    STR R1, R6, #2
    STR R1, R6, #3

    ADD R6, R6, R5
    STR R1, R6, #0
    STR R1, R6, #1
    STR R1, R6, #2
    STR R1, R6, #3

    RET 


    ; check border
    CHECKBORDER_UP

    LD R2, PEN_Y
    ADD R2, R2, #-4
    BRnz UP_BORDER
    AND R4, R4, #0
    Br SKIP_UP
    UP_BORDER
    AND R4, R4, #0
    ADD R4, R4, #1
    SKIP_UP
    RET

     CHECKBORDER_DOWN

    LD R2, PEN_Y  ; load current y coordinate of pen into R2
    ADD R2, R2, #4
    LD R3, BOTTOM_BORDER
    NOT R3, R3
    ADD R3, R3, #1
    ADD R3, R3, R2
    BRzp DOWN_BORDER  ;branch to SKIP_DOWN
    AND R4, R4, #0 ;Clear R4
    Br SKIP_DOWN
    DOWN_BORDER
    AND R4, R4, #0
    ADD R4, R4, #1
    SKIP_DOWN ;Label to skip bottom border check
    RET ;return from subroutine

    CHECKBORDER_LEFT

    LD R2, PEN_X
    ADD R2, R2, #-4
    BRnz LEFT_BORDER
    AND R4, R4, #0
    Br SKIP_LEFT
    LEFT_BORDER
    AND R4, R4, #0
    ADD R4, R4, #1
    SKIP_LEFT
    RET


  CHECKBORDER_RIGHT

    LD R2, PEN_X
    ADD R2, R2, #4
    LD R3, RIGHT_BORDER
    NOT R3, R3
    ADD R3, R3, #1
    ADD R3, R3, R2
    BRzp RIGHT1_BORDER
    AND R4, R4, #0
    Br SKIP_RIGHT
    RIGHT1_BORDER
    AND R4, R4, #0
    ADD R4, R4, #1
    SKIP_RIGHT
    RET





; Subroutines for movement and color change
; ...

QUIT
HALT

; Constants and data
  
PEN_CURRENT    .FILL xDF40  ; Initial pen position (64, 62) address in memory
COLOR_WHITE:   .FILL x7FFF   ; White color code
COLOR_RED:     .FILL x7C00   ; Red color code
COLOR_BLUE     .FILL x001F    
COLOR_YELLOW   .FILL x7FED
COLOR_GREEN    .FILL x03E0 
COLOR_BLACK    .FILL x0000
ASCII_W1:       .FILL #119    ; ASCII value for 'w'
ASCII_A1:       .FILL #97     ; ASCII value for 'a'
ASCII_S1:       .FILL #115    ; ASCII value for 's'
ASCII_D1:       .FILL #100    ; ASCII value for 'd'
ASCII_SPACE:   .FILL #32     ; ASCII value for space
UP             .FILL #-128
LEFT           .FILL #-1
DOWN           .FILL #128
RIGHT          .FILL #1
ASCII_R1        .FILL x0072
ASCII_G1        .FILL x0067
ASCII_B1        .FILL x0062
ASCII_Y1        .FILL #121
SCREEN_START   .FILL xF000 ; Start of the video memory
SCREEN_END     .FILL xF3FF ; End of the video memory
q              .FILL x0071
CURRENT_COLOR  .FILL x7FFF
W              .FILL #-512
A              .FILL #-4
S              .FILL #512
D              .FILL #4
PEN_X          .FILL #64
PEN_Y          .FILL #62 
BOTTOM_BORDER  .FILL #120
RIGHT_BORDER   .FILL #124
CLEAR_SCREEN   .FILL #-15872
TOP_LEFT       .FILL xC000


.END


















































