; invaders.asm
; Mudhathir Sharif Khaja
; 11/29/2023
; ECE 109 001
; This programming assignment is a simplified Space Invaders game where the player controls a ship (Pack Ship)
; and shoots at alien invaders. The main goal is to destroy all alien ships, with the game ending with a 
; "GAME OVER" message once all targets are hit.

.ORIG x3000

;-------------------------------
; Main Program Entry
;-------------------------------
MAIN    JSR     CLEAR_SCREEN    ; Call subroutine to clear the screen
        JSR     SETUP           ; Set up game elements (aliens, ship, laser)
        JSR     REDRAW          ; Draw initial game objects on the screen
        JSR     GAMELOOP        ; Enter the main game loop
        LEA     R0, QUIT1       ; Load address of quit prompt message
        PUTS                    ; Print the quit prompt message ("Quit\n")
        HALT                    ; Halt execution when game exits

QUIT1   .STRINGZ "Quit\n"       ; String to display when quitting

;-------------------------------
; Main Game Loop
;-------------------------------
GAMELOOP    
        ST      R7, GAME7       ; Save the return address in R7 to memory location GAME7

GAME    JSR     TIMED           ; Call timed subroutine (handles timer and/or input wait)
        LD      R1, FILLR       ; Load the key code constant for 'r' (red color command)
        ADD     R1, R0, R1      ; Compare input character (in R0) with 'r'
        BRnp    SKIPR           ; If not pressed, branch to SKIPR
        LD      R1, RED         ; Load red color constant into R1
        JSR     CHANGECOLOR     ; Change ship color to red

SKIPR   LD      R1, FILLG       ; Load the key code constant for 'g' (green color command)
        ADD     R1, R0, R1      ; Compare input with 'g'
        BRnp    SKIPG           ; Branch if not 'g'
        LD      R1, GREEN       ; Load green color constant into R1
        JSR     CHANGECOLOR     ; Change ship color to green

SKIPG   LD      R1, FILLB       ; Load key code for 'b' (blue color command)
        ADD     R1, R0, R1      ; Compare input with 'b'
        BRnp    SKIPB           ; Branch if not 'b'
        LD      R1, BLUE        ; Load blue color constant into R1
        JSR     CHANGECOLOR     ; Change ship color to blue

SKIPB   LD      R1, FILLY       ; Load key code for 'y' (yellow color command)
        ADD     R1, R0, R1      ; Compare input with 'y'
        BRnp    SKIPY           ; Branch if not 'y'
        LD      R1, YELLOW      ; Load yellow color constant into R1
        JSR     CHANGECOLOR     ; Change ship color to yellow

SKIPY   LD      R1, FILLW       ; Load key code for 'w' (white color command)
        ADD     R1, R0, R1      ; Compare input with 'w'
        BRnp    SKIPW           ; Branch if not 'w'
        LD      R1, WHITE       ; Load white color constant into R1
        JSR     CHANGECOLOR     ; Change ship color to white

SKIPW   LD      R1, FILLA       ; Load key code for 'a' (move left command)
        ADD     R1, R0, R1      ; Compare input with 'a'
        BRnp    SKIPL           ; Branch if not 'a'
        AND     R0, R0, #0      ; Clear R0 before moving
        ADD     R1, R1, #-4     ; Adjust offset for left movement (subtract 4)
        JSR     MOVE_SHIP       ; Call subroutine to move the ship left

SKIPL   LD      R1, FILLD       ; Load key code for 'd' (move right command)
        ADD     R1, R0, R1      ; Compare input with 'd'
        BRnp    SKIPRIGHT       ; Branch if not 'd'
        AND     R0, R0, #0      ; Clear R0 before moving
        ADD     R1, R1, #4      ; Adjust offset for right movement (add 4)
        JSR     MOVE_SHIP       ; Call subroutine to move the ship right

SKIPRIGHT LD     R1, FILLSP      ; Load key code for space (shoot command)
        ADD     R1, R0, R1      ; Compare input with space
        BRnp    SKIPSHOOT       ; Branch if not space
        JSR     SHOOT           ; Call subroutine to shoot the laser

SKIPSHOOT LD     R1, FILLQ       ; Load key code for 'q' (quit command)
        ADD     R1, R0, R1      ; Compare input with 'q'
        BRnp    SKIP_QUIT       ; Branch if not quit command
        BRnzp   QUIT            ; If 'q', branch to QUIT to exit game

SKIP_QUIT   
        JSR     MAKE_LASER      ; Animate/draw the laser
        JSR     GAMEOVER        ; Check for game-over condition (all aliens hit)
        BRnzp   GAME            ; Loop back to GAME if the game is still on

QUIT    LD      R7, GAME7       ; Restore R7 from memory (return from GAMELOOP)
        RET                     ; Return to caller (exit game loop)

;-------------------------------
; Constants for Input Key Codes
;-------------------------------
FILLR       .FILL #-114      ; Constant for key 'r'
FILLG       .FILL #-103      ; Constant for key 'g'
FILLB       .FILL #-98       ; Constant for key 'b'
FILLY       .FILL #-121      ; Constant for key 'y'
FILLW       .FILL #-119      ; Constant for key 'w'
FILLA       .FILL #-97       ; Constant for key 'a' (move left)
FILLD       .FILL #-100      ; Constant for key 'd' (move right)
FILLSP      .FILL #-32       ; Constant for space (shoot)
FILLQ       .FILL #-113      ; Constant for key 'q' (quit)
GAME7       .BLKW 1         ; Storage for saving R7 (game loop return address)
RED         .FILL x7C00      ; Red color constant
GREEN       .FILL x03E0      ; Green color constant
BLUE        .FILL x001F      ; Blue color constant
YELLOW      .FILL xFFE0      ; Yellow color constant
WHITE       .FILL xFFFF      ; White color constant
BLACK       .FILL x0000      ; Black color constant

;-------------------------------
; Ship Drawing Subroutine
;-------------------------------
SHIPDRAW  ; Draw the player's ship
            ST R0, DRAWSHIP1    ; Save R0 into DRAWSHIP1
            ST R3, DRAWSHIP2    ; Save R3 into DRAWSHIP2
            ST R4, DRAWSHIP3    ; Save R4 into DRAWSHIP3
            ST R7, DRAWSHIP4    ; Save R7 into DRAWSHIP4
            AND R4, R4, #0      ; Clear R4
            ADD R4, R2, #0      ; Set R4 to current ship color from R2
            LD R2, WIDTH        ; Load ship width into R2
            LD R3, LENGTH       ; Load ship length into R3
            JSR POSITION        ; Call POSITION subroutine to position the ship
            LD R0, DRAWSHIP1    ; Restore R0 from DRAWSHIP1
            LD R3, DRAWSHIP2    ; Restore R3 from DRAWSHIP2
            LD R4, DRAWSHIP3    ; Restore R4 from DRAWSHIP3
            LD R7, DRAWSHIP4    ; Restore R7 from DRAWSHIP4
            RET                 ; Return from subroutine

; Data for ship drawing
DRAWSHIP1   .FILL 1
DRAWSHIP2   .FILL 1
DRAWSHIP3   .FILL 1
DRAWSHIP4   .FILL 1
WIDTH       .FILL #24         ; Ship width
LENGTH      .FILL #12         ; Ship length

;-------------------------------
; Laser Drawing Subroutine
;-------------------------------
LASERDR    ; Draw the laser
            ST  R3, LAS1      ; Save R3 to LAS1
            ST  R4, LAS2      ; Save R4 to LAS2
            ST  R7, LAS3      ; Save R7 to LAS3
            AND R4, R4, #0    ; Clear R4
            ADD R4, R2, #0    ; Set R4 to current laser color or position info in R2
            LD  R2, LASERW    ; Load laser width into R2
            LD  R3, LASERL    ; Load laser length into R3
            JSR POSITION      ; Position and draw the laser rectangle
            LD  R3, LAS1      ; Restore R3 from LAS1
            LD  R4, LAS2      ; Restore R4 from LAS2
            LD  R7, LAS3      ; Restore R7 from LAS3
            RET               ; Return from LASERDR

; Data for laser drawing
LASERW      .FILL #3         ; Laser width
LASERL      .FILL #12        ; Laser length
LAS1        .BLKW 1
LAS2        .BLKW 1
LAS3        .BLKW 1

;-------------------------------
; Setup Subroutine
; Initializes aliens, ship, and laser positions and colors.
;-------------------------------
SETUP   
            ST R0, SETUP0     ; Save R0 to SETUP0
            ST R0, SETUP1     ; Save R0 to SETUP1
            ST R0, SETUP2     ; Save R0 to SETUP2
            ST R0, SETUP3     ; Save R0 to SETUP3
            ST R0, SETUP4     ; Save R0 to SETUP4
            ST R7, SETUP5     ; Save R7 to SETUP5
            LEA R0, ALIEN0    ; Load starting address for aliens into R0
            LD R1, START      ; Load starting position for aliens into R1
            LD R2, SETUPBLUE  ; Load blue color (for aliens) into R2
            LD R3, OFFSET     ; Load position offset for aliens into R3
            AND R4, R4, #0    ; Clear R4
            ADD R4, R4, #4    ; Set counter to 4

ALIENSIN    
            STR R2, R0, #0    ; Store alien color at current address
            ADD R0, R0, #1    ; Increment pointer
            STR R1, R0, #0    ; Store alien position value
            ADD R1, R1, R3   ; Increment position for next alien by offset in R3
            ADD R0, R0, #1    ; Increment pointer for next alien data
            ADD R4, R4, #-1   ; Decrement alien counter
            BRp ALIENSIN      ; Loop until all aliens are set up

            ; Initialize the player's ship
            LEA R0, SHIP      ; Load ship address into R0
            LD R1, SHIP_START ; Load starting position for the ship into R1
            LD R2, SETUPRED   ; Load red color (for the ship) into R2
            STR R2, R0, #0    ; Store ship's color at ship memory location
            ADD R0, R0, #1    ; Increment pointer for ship address
            STR R1, R0, #0    ; Store ship's starting position

            ; Initialize the laser (set inactive)
            LEA R0, LASER     ; Load laser base address into R0
            AND R1, R1, #0    ; Clear R1 for laser status
            STR R1, R0, #0    ; Set laser status to inactive (0)
            ADD R0, R0, #1    ; Increment pointer to next laser field
            ADD R1, R1, #1    ; Set laser position value to 1 (or default)
            STR R1, R0, #0    ; Store this initial laser value
            ; Restore registers that were saved
            LD R0, SETUP0
            LD R0, SETUP1
            LD R0, SETUP2
            LD R0, SETUP3
            LD R0, SETUP4
            LD R7, SETUP5
            RET               ; Return from SETUP

; Data for SETUP
SETUP0      .BLKW 1
SETUP1      .BLKW 1
SETUP2      .BLKW 1
SETUP3      .BLKW 1
SETUP4      .BLKW 1
SETUP5      .BLKW 1
START       .FILL xC18A     ; Start position for aliens
SHIP_START  .FILL xF3B3     ; Start position for the ship
OFFSET      .FILL #30       ; Position offset for aliens
SETUPBLUE   .FILL x001F     ; Blue color for aliens
SETUPRED    .FILL x7C00     ; Red color for the ship

;-------------------------------
; Draw Aliens Subroutine
;-------------------------------
DRAW_ALIENS
            ST R0, DRAWALIENS1    ; Save R0 in DRAWALIENS1
            ST R1, DRAWALIENS2    ; Save R1 in DRAWALIENS2
            ST R2, DRAWALIENS3    ; Save R2 in DRAWALIENS3
            ST R3, DRAWALIENS4    ; Save R3 in DRAWALIENS4
            ST R4, DRAWALIENS5    ; Save R4 in DRAWALIENS5
            ST R5, DRAWALIENS6    ; Save R5 in DRAWALIENS6
            ST R7, DRAWALIENS7    ; Save R7 in DRAWALIENS7
            AND R0, R0, #0        ; Clear R0 and set as counter
            ADD R0, R0, #4        ; Set counter to 4 (number of aliens)
            LEA R5, ALIEN0        ; Load starting address of first alien into R5

DRAW_ALIEN  
            LDR R4, R5, #0        ; Load alien color from memory into R4
            ADD R5, R5, #1        ; Increment pointer to alien position data
            LDR R1, R5, #0        ; Load alien position into R1
            LD R2, DIMENSIONS     ; Load alien width into R2
            LD R3, DIMENSIONS     ; Load alien length into R3
            JSR POSITION          ; Draw the alien (call POSITION subroutine)
            ADD R5, R5, #1        ; Increment pointer for next alien
            ADD R0, R0, #-1       ; Decrement alien counter
            BRp DRAW_ALIEN        ; Loop until all aliens have been drawn
            ; Restore registers saved at the start of subroutine
            LD R0, DRAWALIENS1
            LD R1, DRAWALIENS2
            LD R2, DRAWALIENS3
            LD R3, DRAWALIENS4
            LD R4, DRAWALIENS5
            LD R5, DRAWALIENS6
            LD R7, DRAWALIENS7
            RET                   ; Return from DRAW_ALIENS

; Data for DRAW_ALIENS
DRAWALIENS1 .BLKW 1
DRAWALIENS2 .BLKW 1
DRAWALIENS3 .BLKW 1
DRAWALIENS4 .BLKW 1
DRAWALIENS5 .BLKW 1
DRAWALIENS6 .BLKW 1
DRAWALIENS7 .BLKW 1
DIMENSIONS  .FILL #14       ; Alien dimensions (width and height)

;-------------------------------
; POSITION Subroutine
; Draws a rectangle (used for aliens, ship, or laser) at a given location with a given color.
; Inputs expected in:
;   R1: starting address (position)
;   R2: width (or horizontal dimension)
;   R3: length (or vertical dimension)
;   R4: color value
;-------------------------------
POSITION    
    ST R0, POS0           ; Save R0 in POS0
    ST R5, POS1           ; Save R5 in POS1
    ST R6, POS2           ; Save R6 in POS2
    ST R7, POS3           ; Save R7 in POS3

    LD R5, ROWSET         ; Load row offset value into R5
    NOT R2, R2            ; Negate width value (for looping)
    ADD R2, R2, #1        ; Adjust negated width value by adding 1
    ST R2, STOREW         ; Store adjusted width in STOREW
    NOT R3, R3            ; Negate length value (for looping)
    ADD R3, R3, #1        ; Adjust negated length value by adding 1
    ST R3, STOREL         ; Store adjusted length in STOREL
    AND R0, R0, #0        ; Clear R0 – will be used as column counter

COL ; Column Loop
    ST R0, A              ; Save current column count into A
    LD R3, STOREL         ; Load stored length into R3
    ADD R0, R0, R3        ; Check if outer loop (columns) is complete
    BRzp COL1             ; If finished, branch to COL1
    AND R0, R0, #0        ; Otherwise, reset R0

ROW ; Row Loop
    ST R0, B              ; Save current row count into B
    LD R3, STOREW         ; Load stored width into R3
    ADD R0, R0, R3        ; Check if row loop is complete
    BRzp ROW1             ; If finished, branch to ROW1
    LD R0, B              ; Reload the row count from B
    AND R6, R6, #0        ; Clear R6
    ADD R6, R1, R0        ; Set R6 to current pixel address (R1 + offset)
    STR R4, R6, #0        ; Draw pixel: store color (R4) at current position
    ADD R0, R0, #1        ; Increment row counter
    BR ROW                ; Repeat row loop

ROW1    
    ADD R1, R1, R5        ; Increment starting address by the row offset (advance to next column)
    LD R0, A              ; Restore column counter from A
    ADD R0, R0, #1        ; Increment column counter
    BR COL                ; Repeat column loop

COL1    
    LD R0, POS0           ; Restore R0 from POS0
    LD R5, POS1           ; Restore R5 from POS1
    LD R6, POS2           ; Restore R6 from POS2
    LD R7, POS3           ; Restore R7 from POS3
    RET                   ; Return from POSITION

; Data for POSITION subroutine
POS0    .FILL 1
POS1    .FILL 1
POS2    .FILL 1
POS3    .FILL 1
ROWSET  .FILL x0080        ; Row offset value for drawing (depends on screen dimensions)
A       .BLKW 1            ; Temporary storage for column counter
B       .BLKW 1            ; Temporary storage for row counter
STOREW  .BLKW 1            ; Storage for adjusted width (STOREW)
STOREL  .BLKW 1            ; Storage for adjusted length (STOREL)

;; CONVERT_TO_XY Subroutine
; Takes a memory address and converts it to x and y coordinates.
; Input: R2 = memory address; Outputs: R3 (x), R4 (y)
CONVERTXY   ST  R0, XY0     ; Save R0 to XY0
            ST  R1, XY1     ; Save R1 to XY1
            ST  R2, XY2     ; Save R2 to XY2
            ST  R5, XY3     ; Save R5 to XY3
            ST  R7, XY4     ; Save R7 to XY4
            LD  R3, X_OFFSET; Load X offset constant into R3
            ADD R2, R2, R3  ; Adjust R2 by X offset
            AND R3, R3, #0  ; Clear R3 for x coordinate result
            AND R4, R4, #0  ; Clear R4 for y coordinate result
            LD  R0, OFF     ; Load screen offset constant into R0
CONVERT_LOOP
            ADD R5, R2, R0  ; Add offset to R2 (temporary calculation)
            BRn END_CONVERT ; If negative, conversion is complete
            ADD R4, R4, #1  ; Increment y coordinate counter
            ADD R2, R2, R0  ; Continue adjusting R2
            BRnzp CONVERT_LOOP
END_CONVERT ADD R3, R2, #0  ; Set x coordinate (remainder) in R3
            LD  R0, XY0     ; Restore registers from XY0..XY4
            LD  R1, XY1
            LD  R2, XY2
            LD  R5, XY3
            LD  R7, XY4
            RET           ; Return from CONVERTXY
XY0     .BLKW 1
XY1     .BLKW 1
XY2     .BLKW 1
XY3     .BLKW 1
XY4     .BLKW 1
X_OFFSET .FILL #-49152       ; X offset constant
OFF     .FILL #-128         ; Screen offset constant

;; SET_SHIP_COLOR Subroutine
; Changes and sets the color of the ship. Input: R1 = new ship color.
CHANGECOLOR    
            ST  R0, ADJUST    ; Save R0 in ADJUST
            ST  R1, ADJUST1   ; Save new color (R1) in ADJUST1
            ST  R2, ADJUST2   ; Save R2 in ADJUST2
            ST  R7, ADJUST7   ; Save R7 in ADJUST7
            LEA R0, SHIP      ; Load ship address into R0
            STR R1, R0, #0    ; Set ship color by storing R1 at ship address
            AND R2, R2, #0    ; Clear R2 (not used further)
            ADD R2, R1, #0    ; Copy new color from R1 into R2
            ADD R0, R0, #1    ; Increment R0 to point to ship position
            LDR R1, R0, #0    ; Load ship position (for redraw)
            JSR SHIPDRAW      ; Redraw the ship with the new color
            LD  R0, ADJUST    ; Restore registers from ADJUST storage
            LD  R1, ADJUST1
            LD  R2, ADJUST2
            LD  R7, ADJUST7
            RET             ; Return from CHANGECOLOR

ADJUST      .BLKW 1
ADJUST1     .BLKW 1
ADJUST2     .BLKW 1
ADJUST7     .BLKW 1

;; MOVE_SHIP Subroutine
; Changes the position of the ship and redraws it.
; Input: R1 contains offset value (-4 for left or +4 for right)
MOVE_SHIP   
            ST  R0, MOVE1    ; Save R0
            ST  R2, MOVE2    ; Save R2
            ST  R3, MOVE3    ; Save R3
            ST  R4, MOVE4    ; Save R4
            ST  R5, MOVE5    ; Save R5
            ST  R7, MOVE6    ; Save R7
            LEA R0, SHIP     ; Load address of the ship into R0
            ADD R0, R0, #1   ; Move pointer to ship's position field
            LDR R4, R0, #0   ; Load current ship position into R4
            ADD R5, R1, R4   ; Calculate new position: current position + offset
            LD  R3, SHIP_MIN ; Load minimum allowed ship position
            ADD R3, R5, R3   ; Check if new position is left of screen (using two's complement)
            BRn CANCEL       ; If out-of-bounds, cancel movement
            LD  R3, SHIP_MAX ; Load maximum allowed ship position
            ADD R3, R5, R3   ; Check if new position is right of screen
            BRp CANCEL       ; If out-of-bounds, cancel movement
            STR R5, R0, #0   ; Store new ship position back to memory
            AND R1, R1, #0   ; Clear R1 for redraw
            ADD R1, R4, #0   ; Copy old position to R1
            LD  R2, BLACK1   ; Load black color to erase previous ship (simulate erase)
            JSR SHIPDRAW     ; Redraw ship to erase old position
            AND R1, R1, #0   ; Clear R1
            ADD R1, R5, #0   ; Set R1 to new ship position
            ADD R0, R0, #-1  ; Adjust pointer back to ship color field
            LDR R2, R0, #0   ; Load ship color (for redraw)
            JSR SHIPDRAW     ; Redraw the ship at the new position
CANCEL      LD  R0, MOVE1    ; Restore registers if movement is canceled
            LD  R2, MOVE2
            LD  R3, MOVE3
            LD  R4, MOVE4
            LD  R5, MOVE5
            LD  R7, MOVE6
            RET             ; Return from MOVE_SHIP

MOVE1       .BLKW 1
MOVE2       .BLKW 1
MOVE3       .BLKW 1
MOVE4       .BLKW 1
MOVE5       .BLKW 1
MOVE6       .BLKW 1
SHIP_MAX    .FILL x0C19    ; Maximum position limit for ship (two's complement value)
SHIP_MIN    .FILL x0C7D    ; Minimum position limit for ship (two's complement value)
BLACK1      .FILL x0000    ; Black color constant for erasing

;; REDRAW Subroutine
; Clears the screen and redraws aliens and the ship.
REDRAW  
            ST  R0, REDRAW0      ; Save R0 to REDRAW0
            ST  R1, REDRAW1      ; Save R1 to REDRAW1
            ST  R2, REDRAW2      ; Save R2 to REDRAW2
            ST  R3, REDRAW3      ; Save R3 to REDRAW3
            ST  R4, REDRAW4      ; Save R4 to REDRAW4
            ST  R5, REDRAW5      ; Save R5 to REDRAW5
            ST  R7, REDRAW6      ; Save R7 to REDRAW6
            JSR CLEAR_SCREEN     ; Clear the screen before drawing
            JSR DRAW_ALIENS      ; Draw all aliens
            LEA R5, SHIP         ; Load address of the ship into R5
            LDR R2, R5, #0       ; Get ship color into R2 (for drawing ship)
            ADD R5, R5, #1       ; Increment pointer to get ship position
            LDR R1, R5, #0       ; Load ship position into R1
            JSR SHIPDRAW         ; Draw the ship at the designated position
            ; Restore registers saved at the beginning of REDRAW
            LD  R0, REDRAW0
            LD  R1, REDRAW1
            LD  R2, REDRAW2
            LD  R3, REDRAW3
            LD  R4, REDRAW4
            LD  R5, REDRAW5
            LD  R7, REDRAW6
            RET                 ; Return from REDRAW

; Data for REDRAW subroutine
REDRAW0     .BLKW 1
REDRAW1     .BLKW 1
REDRAW2     .BLKW 1
REDRAW3     .BLKW 1
REDRAW4     .BLKW 1
REDRAW5     .BLKW 1
REDRAW6     .BLKW 1

;-------------------------------
; Game Objects Data
;-------------------------------
ALIEN0      .BLKW 2         ; Alien 0 data (color, position)
ALIEN1      .BLKW 2         ; Alien 1 data (if needed)
ALIEN2      .BLKW 2         ; Alien 2 data
ALIEN3      .BLKW 2         ; Alien 3 data
SHIP        .BLKW 2         ; Ship data (color, position)
LASER       .BLKW 2         ; Laser data (status, position)

;; SHOOT Subroutine
; Handles the shooting action.
SHOOT   ST  R0, SHOOT0        ; Save registers R0-R7 for later restoration
        ST  R1, SHOOT1
        ST  R2, SHOOT2
        ST  R3, SHOOT3
        ST  R4, SHOOT4
        ST  R7, SHOOT5
        LEA R0, LASER        ; Load laser address into R0
        LDR R1, R0, #0       ; Get laser status from LASER[0]
        BRp CANCEL_SHOOT     ; If laser active (positive), cancel shooting
        AND R1, R1, #0       ; Clear R1
        ADD R1, R1, #1       ; Activate laser (set to 1)
        STR R1, R0, #0       ; Store updated laser status
        LEA R2, SHIP         ; Load ship address into R2
        LDR R2, R2, #1       ; Get ship position from SHIP[1]
        ADD R2, R2, #11      ; Adjust ship position (offset for laser start)
        LD R3, Y             ; Load Y offset for laser from Y constant
        ADD R2, R2, R3       ; Calculate laser starting position
        AND R1, R1, #0       ; Clear R1
        ADD R1, R2, #0       ; Set new laser position in R1
        STR R1, R0, #1       ; Store laser position in LASER[1]
        LD R2, GR            ; Load laser color (green) constant into R2
        JSR LASERDR          ; Draw the laser on screen

CANCEL_SHOOT  
        LD  R0, SHOOT0       ; Restore registers R0-R7 from SHOOT0 - SHOOT5
        LD  R1, SHOOT1
        LD  R2, SHOOT2
        LD  R3, SHOOT3
        LD  R4, SHOOT4
        LD  R7, SHOOT5
        RET                 ; Return from SHOOT

; Data for SHOOT subroutine
SHOOT0      .BLKW 1
SHOOT1      .BLKW 1
SHOOT2      .BLKW 1
SHOOT3      .BLKW 1
SHOOT4      .BLKW 1
SHOOT5      .BLKW 1
Y           .FILL xFA00     ; Y offset constant (negated for ease; -128*12)
GR          .FILL x03E0     ; Green color for laser

;-------------------------------
; HIT Subroutine
; Checks if the laser hit an alien.
;-------------------------------
HIT         ST  R0, HIT0       ; Save registers to HIT storage
            ST  R1, HIT1
            ST  R2, HIT2
            ST  R3, HIT3
            ST  R4, HIT4
            ST  R6, HIT5
            ST  R7, HIT6
            LD  R6, POSALIEN    ; Load alien position offset value
            AND R5, R5, #0      ; Clear R5 (will record hit status)
            ADD R6, R4, R6      ; Adjust R6 by laser's y position (R4)
            BRzp END_CHECK      ; If result is positive, no hit detected yet
            AND R5, R5, #0      ; Clear R5 again
            LEA R0, ALIEN0      ; Load starting address for alien data
            LEA R1, SHIP_0      ; Load first check value (x range) for ship relative to laser
            AND R2, R2, #0      ; Clear R2 for counter
            ADD R2, R2, #4      ; Set counter to 4 (number of aliens to check)
CHECK_SHIP  LDR R6, R1, #0      ; Load min x-value for an alien hit detection
            ADD R6, R3, R6      ; Check if laser x (R3) exceeds minimum boundary
            BRn  NO_HIT        ; If not, branch to NO_HIT
            LDR R6, R1, #1      ; Load max x-value for hit detection
            ADD R6, R3, R6      ; Check if laser x is below maximum boundary
            BRp  NO_HIT        ; If exceeded, branch to NO_HIT
            LD  R6, HITRED      ; Load hit color constant (red) into R6
            STR R6, R0, #0      ; Store hit color into the corresponding alien data location
            ADD R1, R1, #1      ; Move to next alien check value
            ADD R5, R5, #1      ; Mark that a hit occurred (increment R5)
            BRnzp UPDATE        ; Branch to update aliens

NO_HIT      ADD R0, R0, #2      ; Increment alien data pointer to next alien
            ADD R1, R1, #2      ; Increment check value pointer
            ADD R2, R2, #-1     ; Decrement counter by 1
            BRp CHECK_SHIP      ; Continue checking if counter > 0
            BRnzp END_CHECK     ; No hit detected; exit hit subroutine

UPDATE      JSR DRAW_ALIENS     ; If hit, redraw aliens to reflect changes

END_CHECK   LD  R0, HIT0        ; Restore registers from HIT storage
            LD  R1, HIT1
            LD  R2, HIT2
            LD  R3, HIT3
            LD  R4, HIT4
            LD  R6, HIT5
            LD  R7, HIT6
            RET                 ; Return from HIT subroutine

; Data for HIT subroutine
HIT0    .BLKW 1
HIT1    .BLKW 1
HIT2    .BLKW 1
HIT3    .BLKW 1
HIT4    .BLKW 1
HIT5    .BLKW 1
HIT6    .BLKW 1
POSALIEN .FILL #-17        ; Offset value for alien position (for hit detection)
SHIP_0   .FILL #-9         ; Compensated x position for laser check (for first alien)
SHIP_1   .FILL #-24        ; Uncompensated x position for laser (if needed)
SHIP1_0  .FILL #-39	
SHIP1_1  .FILL #-54	
SHIP2_0  .FILL #-69	
SHIP2_1  .FILL #-84	
SHIP3_0  .FILL #-99	
SHIP3_1  .FILL #-114
HITRED   .FILL x7C00       ; Red color constant for alien hit indication

;; ANIMATE_LASER Subroutine
; Animates the laser until it either reaches the screen edge or hits an alien.
MAKE_LASER  ST  R0, MAKE0    ; Save registers R0-R7 for later restoration
            ST  R1, MAKE1
            ST  R2, MAKE2
            ST  R3, MAKE3
            ST  R4, MAKE4
            ST  R5, MAKE5
            ST  R7, MAKE6
            LEA R0, LASER      ; Load laser address into R0
            LDR R1, R0, #0     ; Get laser active status from LASER[0]
            BRnz END_ANIMATE   ; If laser is inactive (non-zero), skip animation
            LDR R1, R0, #1     ; Load current laser position from LASER[1]
            LD  R2, OFFSETY    ; Load vertical offset for laser movement
            ADD R2, R1, R2     ; Compute new laser position
            JSR CONVERTXY      ; Convert memory address to (x,y) coordinates
            ADD R4, R4, #0     ; (Optional adjustment; code placeholder)
            BRnz CLEAR_LASER   ; If condition met, clear the laser
            JSR HIT            ; Check for hit detection
            ADD R5, R5, #0     ; (Optional placeholder for hit status)
            BRnz ANIMATE       ; If necessary, animate laser movement
CLEAR_LASER LD  R2, MAKE_BLACK  ; Load black color to erase laser
            JSR LASERDR        ; Redraw laser with black to clear it
            AND R1, R1, #0     ; Clear R1
            STR R1, R0, #0     ; Set laser inactive in LASER[0]
            BRnzp END_ANIMATE  ; Branch to end of animation
ANIMATE     AND R6, R6, #0     ; Clear R6 for temporary storage
            ADD R6, R2, #0     ; Store new position in R6
            LD  R2, MAKE_BLACK ; Load black color to clear previous laser position
            JSR LASERDR        ; Clear previous laser drawing
            AND R1, R1, #0     ; Clear R1
            ADD R1, R6, #0     ; Update R1 with new laser position
            STR R1, R0, #1     ; Store new position in LASER[1]
            LD  R2, MAKE_GREEN ; Load green color for drawing the laser
            JSR LASERDR        ; Draw laser at new position
END_ANIMATE LD  R0, MAKE0     ; Restore registers from MAKE storage
            LD  R1, MAKE1
            LD  R2, MAKE2
            LD  R3, MAKE3
            LD  R4, MAKE4
            LD  R5, MAKE5
            LD  R7, MAKE6
            RET                ; Return from MAKE_LASER

MAKE0       .BLKW 1
MAKE1       .BLKW 1
MAKE2       .BLKW 1
MAKE3       .BLKW 1
MAKE4       .BLKW 1
MAKE5       .BLKW 1
MAKE6       .BLKW 1
OFFSETY     .FILL #-768     ; Vertical offset for laser movement
MAKE_BLACK  .FILL x0000     ; Black color constant (for erasing)
MAKE_GREEN  .FILL x03E0     ; Green color constant (for laser)

;; GAMEOVER Subroutine
; Checks the status of aliens and displays "GAMEOVER" if all aliens are destroyed.
GAMEOVER    ST  R0, GAMEOVER0   ; Save registers R0-R7 for game over check
            ST  R1, GAMEOVER1
            ST  R2, GAMEOVER2
            ST  R3, GAMEOVER3
            ST  R4, GAMEOVER4
            ST  R7, GAMEOVER7

            LD  R2, COLOR_CHECK ; Load the color-check value (indicates destroyed alien)
            AND R4, R4, #0      ; Clear R4 for alien counter
            ADD R4, R4, #4      ; Set counter to 4 (number of aliens)
            LEA R0, ALIEN0      ; Load starting address of alien data into R0
CHECKALIEN  LDR R1, R0, #0    ; Load alien color from memory
            ADD R3, R1, R2      ; Check if alien color matches the destroyed condition
            BRnp CONTINUE       ; If not matching, continue checking
            ADD R0, R0, #2      ; Move to next alien data entry
            ADD R4, R4, #-1     ; Decrement alien counter
            BRp CHECKALIEN      ; If aliens remain, check next alien
            LEA R0, GAMEOVER_STR; All aliens destroyed, load GAMEOVER string
            PUTS                ; Print "GAMEOVER"
            HALT                ; Halt the game

CONTINUE    LD  R0, GAMEOVER0   ; Restore registers if game not over
            LD  R1, GAMEOVER1
            LD  R2, GAMEOVER2
            LD  R3, GAMEOVER3
            LD  R4, GAMEOVER4
            LD  R7, GAMEOVER7
            RET                 ; Return from GAMEOVER subroutine

; Data for GAMEOVER subroutine
GAMEOVER0   .BLKW 1
GAMEOVER1   .BLKW 1
GAMEOVER2   .BLKW 1
GAMEOVER3   .BLKW 1
GAMEOVER4   .BLKW 1
GAMEOVER7   .BLKW 1
COLOR_CHECK .FILL #-31744   ; Value used to check if an alien is destroyed
GAMEOVER_STR.STRINGZ "GAMEOVER"  ; GAMEOVER message string

;; CLEAR_SCREEN Subroutine
; Clears the screen by writing the black color to every pixel.
CLEAR_SCREEN
            ST R7, CS_R7      ; Save R7
            LD R0, PIXELS     ; Load total number of pixels on the screen into R0
            LD R1, SCREEN_START ; Load starting address of the screen into R1
            LD R2, CS_BLACK   ; Load black color code into R2
CLEAR_LOOP  STR R2, R1, #0    ; Write black color (R2) to current screen location
            ADD R1, R1, #1    ; Increment screen pointer
            ADD R0, R0, #-1   ; Decrement pixel counter
            BRp CLEAR_LOOP    ; Repeat until all pixels are cleared
            LD R7, CS_R7      ; Restore R7
            RET               ; Return from CLEAR_SCREEN

CS_BLACK    .FILL x0000       ; Black color constant
SCREEN_START.FILL xC000       ; Starting address of the screen in memory
PIXELS      .FILL #15872      ; Total number of pixels on the screen
CS_R7       .BLKW 1         ; Storage for saved R7 in CLEAR_SCREEN

;; TIMED Subroutine
; Implements a timed delay or waits for a key press.
TIMED       
            ST R1, TIME0      ; Save R1
            ST R2, TIME1      ; Save R2
            ST R3, TIME2      ; Save R3
            ST R7, TIME3      ; Save R7 (return address)
            AND R0, R0, #0    ; Clear R0 (prepare timer count)
            LD R2, T         ; Load time value (delay duration)
            STI R2, MILLI     ; Set timer with loaded time value
POLL        
            LDI R3, TIMER     ; Load timer status from timer register
            BRn EXITIN        ; Exit polling if timer expires
            LDI R1, KBSR      ; Load keyboard status register
            BRzp POLL         ; If no key pressed, continue polling
            LDI R0, KBDR      ; Load key value into R0

            LD R1, TIME0      ; Restore saved registers R1-R3 and R7
            LD R2, TIME1
            LD R3, TIME2
            LD R7, TIME3
EXITIN      RET               ; Return from TIMED subroutine

; Data for TIMED subroutine
TIME0       .BLKW 1
TIME1       .BLKW 1
TIME2       .BLKW 1
TIME3       .BLKW 1
KBSR        .FILL xFE00     ; Keyboard status register
KBDR        .FILL xFE02     ; Keyboard data register (last key pressed)
TIMER       .FILL xFE08     ; Timer register
MILLI       .FILL xFE0A     ; Milliseconds setting register
T           .FILL x0064     ; Time constant (200 milliseconds between ticks)

.END
