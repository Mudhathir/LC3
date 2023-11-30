;invaders.asm
;Mudhathir Sharif Khaja
; 11/29/2023
;ECE 109 001
;This programming assignment is a simplified Space Invaders game where the player controls a ship (Pack Ship) and shoots at alien invaders. The main goal is to destroy all alien ships, with the game ending with a "GAME OVER" message once all targets are hit.

.ORIG x3000



MAIN	JSR		CLEAR_SCREEN ; Call subroutine to clear the screen
		JSR		SETUP
		JSR		REDRAW
		JSR		GAMELOOP
		LEA		 R0, QUIT1
		PUTS
		HALT
QUIT1	.STRINGZ "Quit\n"



GAMELOOP	ST		R7, GAME7

GAME		JSR		TIMED
			LD		R1, FILLR
			ADD		R1, R0, R1
			BRnp	SKIPR
			LD		R1, RED
			JSR		CHANGECOLOR	; Change the ship's color to red

SKIPR		LD		R1, FILLG ; Check for green color change command
			ADD		R1, R0, R1
			BRnp	SKIPG
			LD		R1, GREEN
			JSR		CHANGECOLOR	

SKIPG		LD		R1, FILLB; Check for blue color change command
			ADD		R1, R0, R1
			BRnp	SKIPB
			LD		R1, BLUE
			JSR		CHANGECOLOR	

SKIPB    	LD		R1, FILLY ; Check for yellow color change command
			ADD		R1, R0, R1
			BRnp	SKIPY
			LD		R1, YELLOW
			JSR		CHANGECOLOR	

SKIPY    	LD		R1, FILLW ; Check for white color change command
			ADD		R1, R0, R1
			BRnp	SKIPW
			LD		R1, WHITE
			JSR		CHANGECOLOR	

SKIPW   	LD		R1, FILLA ; Check for left move command
			ADD		R1, R0, R1
			BRnp	SKIPL
			AND		R0, R0 #0
			ADD		R1, R1 #-4
			JSR		MOVE_SHIP		

SKIPL   	LD		R1, FILLD
			ADD		R1, R0, R1	
			BRnp	SKIPRIGHT
			AND		R0, R0 #0
			ADD		R1, R1 #4	
			JSR		MOVE_SHIP		

SKIPRIGHT	LD		R1, FILLSP
			ADD		R1, R0, R1
			BRnp	SKIPSHOOT	
			JSR		SHOOT			

SKIPSHOOT	LD		R1, FILLQ
			ADD		R1, R0, R1	
			BRnp	SKIP_QUIT
			BRnzp	QUIT			; quit game

			


SKIP_QUIT	JSR MAKE_LASER
			JSR GAMEOVER
			BRnzp	GAME

QUIT		LD		R7, GAME7
			RET


FILLR		.FILL #-114	; r
FILLG		.FILL #-103	; g
FILLB		.FILL #-98	; b
FILLY		.FILL #-121	; y
FILLW		.FILL #-119	; w
FILLA		.FILL #-97	; a
FILLD		.FILL #-100	; d
FILLSP		.FILL #-32	; space
FILLQ		.FILL #-113	; q
GAME7		.BLKW 1
RED			.FILL x7C00
GREEN		.FILL x03E0
BLUE		.FILL x001F
YELLOW		.FILL xFFE0
WHITE	.FILL xFFFF
BLACK	.FILL x0000






SHIPDRAW ;draw ships
			ST R0, DRAWSHIP1
			ST R3, DRAWSHIP2
			ST R4, DRAWSHIP3
			ST R7, DRAWSHIP4
			AND R4, R4 #0 ; clear R4
			ADD R4, R2 #0 ; set R4 to R2
			LD R2, WIDTH
			LD R3, LENGTH
			JSR POSITION 
			LD R0, DRAWSHIP1
			LD R3, DRAWSHIP2
			LD R4, DRAWSHIP3
			LD R7, DRAWSHIP4

RET

;DATA
DRAWSHIP1			.FILL 1
DRAWSHIP2			.FILL 1
DRAWSHIP3			.FILL 1
DRAWSHIP4			.FILL 1
WIDTH		.FILL #24
LENGTH		.FILL #12





LASERDR	;draw laser

			ST		R3, LAS1
			ST		R4, LAS2
			ST		R7, LAS3
			AND		R4, R4 #0
			ADD		R4, R2 #0
			LD		R2, LASERW
			LD		R3, LASERL
			JSR		POSITION		
			LD		R3, LAS1
			LD		R4, LAS2
			LD		R7, LAS3
RET

;DATA
LASERW			.FILL #3
LASERL			.FILL #12
LAS1			.BLKW 1
LAS2			.BLKW 1
LAS3			.BLKW 1


; SETUP Subroutine: Initializes game elements like aliens, the ship, and the laser.
SETUP	 
		    ST R0, SETUP0
			ST R0, SETUP1
			ST R0, SETUP2
			ST R0, SETUP3
			ST R0, SETUP4
			ST R7, SETUP5
			LEA R0, ALIEN0			
			LD R1, START
			LD R2, SETUPBLUE
		LD R3, OFFSET; Load position offset value for subsequent aliens into R3
			AND R4, R4 #0
		ADD R4, R4 #4 ; counter

ALIENSIN 
			STR R2, R0 #0 
			ADD R0, R0 #1 
			STR R1, R0 #0 ;Store alien position in current memory location
			ADD R1, R1, R3 
			ADD R0, R0 #1 
			ADD R4, R4 #-1 
			BRp ALIENSIN ; Continue loop until all aliens are initialized

			; Initialize the player's ship
			LEA R0, SHIP
			LD R1, SHIP_START
			LD R2, SETUPRED; Load color value for the ship (red) into R2
			STR R2, R0 #0 
			ADD R0, R0 #1 
			STR R1, R0 #0 

			; Initialize the laser
			LEA R0, LASER
			AND R1, R1 #0
			STR R1, R0 #0   ; Set laser to inactive
			ADD R0, R0 #1
			ADD R1, R1 #1
			STR R1, R0 #0 ; Initialize laser with no position
			LD R0, SETUP0
			LD R0, SETUP1
			LD R0, SETUP2
			LD R0, SETUP3
			LD R0, SETUP4
			LD R7, SETUP5

			RET


;DATA
SETUP0			.BLKW 1
SETUP1			.BLKW 1
SETUP2			.BLKW 1
SETUP3			.BLKW 1
SETUP4			.BLKW 1
SETUP5			.BLKW 1
START           .FILL xC18A   ; Start position for aliens
SHIP_START      .FILL xF3B3   ; Start position for the ship
OFFSET          .FILL #30     ; Position offset for aliens
SETUPBLUE       .FILL x001F   ; Blue color for aliens
SETUPRED        .FILL x7C00   ; Red color for the ship





DRAW_ALIENS		
				
			ST R0, DRAWALIENS1
			ST R1, DRAWALIENS2
			ST R2, DRAWALIENS3
			ST R3, DRAWALIENS4
			ST R4, DRAWALIENS5
			ST R5, DRAWALIENS6
			ST R7, DRAWALIENS7
			AND R0, R0 #0 
			ADD R0, R0 #4 ; R0 to be counter
			LEA R5, ALIEN0 ; get position of first alien

DRAW_ALIEN
			LDR R4, R5 #0 ; load color into R4
			ADD R5, R5 #1 
			LDR R1, R5 #0 
			LD R2, DIMENSIONS 
			LD R3, DIMENSIONS 
			JSR POSITION ; draw first alien
			ADD R5, R5 #1 ; increment pointer
			ADD R0, R0 #-1 ; decrement count
			BRp DRAW_ALIEN
			LD R0, DRAWALIENS1
			LD R1, DRAWALIENS2
			LD R2, DRAWALIENS3
			LD R3, DRAWALIENS4
			LD R4, DRAWALIENS5
			LD R5, DRAWALIENS6
			LD R7, DRAWALIENS7
RET

;DATA
DRAWALIENS1		.BLKW 1
DRAWALIENS2		.BLKW 1
DRAWALIENS3		.BLKW 1
DRAWALIENS4		.BLKW 1
DRAWALIENS5		.BLKW 1
DRAWALIENS6		.BLKW 1
DRAWALIENS7		.BLKW 1
DIMENSIONS		.FILL #14


; 		 R1: Start address
;		 R2: Width
;		 R3: Length
;		 R4: Color

; POSITION Subroutine: Draws a rectangle at a specified location with a given size and color.
POSITION    
   
    ST R0, POS0
    ST R5, POS1
    ST R6, POS2
    ST R7, POS3

    
    LD R5, ROWSET     ; Load row offset value
    NOT R2, R2        ; Negate width value
    ADD R2, R2, #1    ; Increment negated width for loop condition
    ST R2, STOREW     ; Store negated width
    NOT R3, R3        ; Negate height value
    ADD R3, R3, #1    ; Increment negated height for loop condition
    ST R3, STOREL     ; Store negated height
    AND R0, R0, #0    ; Clear R0 for loop counters

COL	;Column Loop		
			
			ST R0, A
			LD R3, STOREL
			ADD R0, R0, R3	; check if outer loop complete
			BRzp COL1
			AND R0, R0 #0

ROW		;Row Loop	
			
			ST R0, B
			LD R3, STOREW
			ADD R0, R0, R3	
			BRzp ROW1
			LD R0, B
			AND R6, R6 #0	
			ADD R6, R1, R0	
			STR R4, R6 #0	;Draw pixel
			ADD R0, R0 #1	
			BR ROW ;Repear row loop

ROW1		
			
			ADD R1, R1, R5	; increment offset
			LD R0, A
			ADD R0, R0 #1	; increment i
			BR COL

COL1		

			LD R0, POS0	; end for loop
			LD R5, POS1
			LD R6, POS2
			LD R7, POS3
			RET
;DATA
POS0		.FILL 1
POS1		.FILL 1
POS2		.FILL 1
POS3		.FILL 1
ROWSET		.FILL x0080
A			.BLKW 1
B			.BLKW 1
STOREW		.BLKW 1
STOREL		.BLKW 1



;; CONVERT_TO_XY
; Takes in memory address and outputs x and y coordinates
; INPUTS: R2: Memory address --> OUTPUTS: R3, R4 (x, y)
CONVERTXY		ST	R0, XY0
				ST	R1, XY1
				ST	R2, XY2
				ST	R5, XY3
				ST	R7, XY4
				LD	R3, X_OFFSET
				ADD	R2, R2, R3
				AND	R3, R3 #0
				AND	R4, R4 #0
				LD	R0, OFF
CONVERT_LOOP	ADD	R5, R2, R0
				BRn	END_CONVERT
				ADD	R4, R4 #1		; increment R4 (y) count
				ADD	R2, R2, R0
				BRnzp CONVERT_LOOP
END_CONVERT		ADD	R3, R2 #0		; set R3 (x) to remainder
				LD	R0, XY0
				LD	R1, XY1
				LD R2, XY2
				LD R5, XY3
				LD R7, XY4
				RET
XY0		.BLKW 1
XY1		.BLKW 1
XY2		.BLKW 1
XY3		.BLKW 1
XY4		.BLKW 1
X_OFFSET	.FILL #-49152
OFF		.FILL #-128 ; screen offset


;; SET_SHIP_COLOR
; Changes and sets the default color of the ship. Takes color input from R1. Uses 
; move ship to redraw the ship.
; INPUT: R1: hex color to set ship
CHANGECOLOR    
ST R0, ADJUST
ST R1, ADJUST1
ST R2, ADJUST2
ST R7, ADJUST7
LEA R0, SHIP
STR R1, R0 #0 
AND R2, R2 #0 
ADD R2, R1 #0 
ADD R0, R0 #1 
LDR R1, R0 #0 
JSR SHIPDRAW ; redraw Pack Ship with new color
LD R0, ADJUST
LD R1, ADJUST1
LD R2, ADJUST2
LD R7, ADJUST7

RET

ADJUST          .BLKW 1
ADJUST1          .BLKW 1
ADJUST2          .BLKW 1
ADJUST7          .BLKW 1


; Changes the position of the ship and redraws the ship in the specified location.
; INPUTS: R1: offset (-4 or +4)
MOVE_SHIP	
			ST		R0, MOVE1
			ST		R2, MOVE2
			ST		R3, MOVE3
			ST		R4, MOVE4
			ST		R5, MOVE5
			ST		R7, MOVE6
			LEA		R0, SHIP
			ADD		R0, R0 #1		
			LDR		R4, R0 #0		
			ADD		R5, R1, R4		
			LD		R3, SHIP_MIN
			ADD		R3, R5, R3		; check if trying to move past screen 
			BRn		CANCEL
			LD		R3, SHIP_MAX
			ADD		R3, R5, R3		; check if trying to move past screen 
			BRp		CANCEL
			STR		R5, R0 #0		
			AND		R1, R1 #0		
			ADD		R1, R4 #0		
			LD		R2, BLACK1	
			JSR		SHIPDRAW
			AND		R1, R1 #0		
			ADD		R1, R5 #0		
			ADD		R0, R0 #-1		
			LDR		R2, R0 #0		; set ship draw color
			JSR		SHIPDRAW


CANCEL  	LD		R0, MOVE1
			LD		R2, MOVE2
			LD		R3, MOVE3
			LD		R4, MOVE4
			LD		R5, MOVE5
			LD		R7, MOVE6
			RET
MOVE1			.BLKW 1
MOVE2			.BLKW 1
MOVE3			.BLKW 1
MOVE4			.BLKW 1
MOVE5			.BLKW 1
MOVE6			.BLKW 1
SHIP_MAX		.FILL x0C19 ; two's complement of xF3E7
SHIP_MIN		.FILL x0C7D ; two's complement of x0C7D
BLACK1			.FILL x0000


REDRAW			
				ST		R0, REDRAW0
				ST		R1, REDRAW1
				ST		R2, REDRAW2
				ST		R3, REDRAW3
				ST		R4, REDRAW4
				ST		R5, REDRAW5
				ST		R7, REDRAW6
				JSR		CLEAR_SCREEN	; clear screen
				JSR		DRAW_ALIENS
				LEA		R5, SHIP
				LDR		R2, R5 #0		; set color to draw for ship
				ADD		R5, R5 #1		; increment ship pointer
				LDR 	R1, R5 #0		; set address of ship to draw
				JSR		SHIPDRAW			; draw initial ship
				LD		R0, REDRAW0
				LD		R1, REDRAW1
				LD		R2, REDRAW2
				LD		R3, REDRAW3
				LD		R4, REDRAW4
				LD		R5, REDRAW5
				LD		R7, REDRAW6
				RET
;DATA
REDRAW0				.BLKW 1
REDRAW1				.BLKW 1
REDRAW2				.BLKW 1
REDRAW3				.BLKW 1
REDRAW4				.BLKW 1
REDRAW5				.BLKW 1
REDRAW6				.BLKW 1


; Game objects
ALIEN0	.BLKW 2	; color, address
ALIEN1	.BLKW 2
ALIEN2	.BLKW 2
ALIEN3	.BLKW 2
SHIP	.BLKW 2 ; color, address
LASER	.BLKW 2 ; visible, address








SHOOT	ST	R0, SHOOT0
		ST	R1, SHOOT1
		ST	R2, SHOOT2
		ST	R3, SHOOT3
		ST	R4, SHOOT4
		ST	R7, SHOOT5
		LEA	R0, LASER
		LDR	R1, R0 #0 ; get status of laser
		BRp	CANCEL_SHOOT
		AND	R1, R1 #0
		ADD	R1, R1 #1
		STR	R1, R0 #0	; set laser to active
		LEA	R2, SHIP
		LDR	R2, R2 #1	; get position of ship
		ADD	R2, R2 #11	
		LD	R3, Y
		ADD	R2, R2, R3	
		AND	R1, R1 #0
		ADD	R1, R2 #0	
		STR	R1, R0 #1	
		LD	R2, GR
		JSR	LASERDR

CANCEL_SHOOT	LD	R0, SHOOT0
				LD	R1, SHOOT1
				LD	R2, SHOOT2
				LD	R3, SHOOT3
				LD	R4, SHOOT4
				LD	R7, SHOOT5
				RET
SHOOT0		.BLKW 1
SHOOT1		.BLKW 1
SHOOT2		.BLKW 1
SHOOT3		.BLKW 1
SHOOT4		.BLKW 1
SHOOT5		.BLKW 1
Y			.FILL xFA00 ; y offset negated for ease of use (-128*12)
GR		.FILL x03E0


;		  R3: x pos of laser
;		  R4; y pos of laser 
;         R5: HIT or NO HIT


HIT				ST	R0, HIT0
				ST	R1, HIT1
				ST	R2, HIT2
				ST	R3, HIT3
				ST	R4, HIT4
				ST	R6, HIT5
				ST	R7, HIT6
				LD	R6, POSALIEN
				AND	R5, R5 #0
				ADD	R6, R4, R6
				BRzp END_CHECK
				AND	R5, R5 #0
				LEA	R0, ALIEN0
				LEA	R1, SHIP_0	; load the first check value
				AND	R2, R2 #0
				ADD	R2, R2 #4

CHECK_SHIP		LDR	R6, R1 #0		; load the value of min
				ADD	R6, R3, R6		; check if x is greater than min
				BRn	NO_HIT
				LDR	R6, R1 #1		; load the value of max
				ADD	R6, R3, R6		; check if x is less than max
				BRp	NO_HIT
				LD	R6, HITRED
				STR	R6, R0 #0		; store hit color into ship
				ADD	R1, R1 #1		
				ADD	R5, R5 #1		; set return value to true
				BRnzp UPDATE

NO_HIT			ADD	R0, R0 #2		; increment ship memory pointer
				ADD	R1, R1 #2		; increment value pointer
				ADD	R2, R2 #-1		; decrement counter
				BRp	CHECK_SHIP
				BRnzp END_CHECK

UPDATE	        JSR	DRAW_ALIENS

END_CHECK		LD	R0, HIT0
				LD	R1, HIT1
				LD	R2, HIT2
				LD	R3, HIT3
				LD	R4, HIT4
				LD	R6, HIT5
				LD	R7, HIT6
				RET
HIT0			.BLKW 1
HIT1			.BLKW 1
HIT2			.BLKW 1
HIT3			.BLKW 1
HIT4			.BLKW 1
HIT5			.BLKW 1
HIT6			.BLKW 1
POSALIEN			.FILL #-17	; position of ship
SHIP_0		.FILL #-9	; compsensated x pos for laser (same below)
SHIP_1		.FILL #-24	; uncompensated x pos for laser (same below)
SHIP1_0		.FILL #-39	
SHIP1_1		.FILL #-54	
SHIP2_0		.FILL #-69	
SHIP2_1		.FILL #-84	
SHIP3_0		.FILL #-99	
SHIP3_1		.FILL #-114
HITRED			.FILL x7C00


;; ANIMATE_LASER
; Animates the laser until it hits the edge of screen or a ship
; Takes no input.
MAKE_LASER	ST	R0, 	MAKE0
				ST		R1, MAKE1
				ST		R2, MAKE2
				ST		R3, MAKE3
				ST		R4, MAKE4
				ST		R5, MAKE5
				ST		R7, MAKE6
				LEA		R0, LASER
				LDR		R1, R0 #0
				BRnz	END_ANIMATE			; check if laser is active
				LDR		R1, R0 #1			
				LD		R2, OFFSETY
				ADD		R2, R1, R2			
				JSR		CONVERTXY		
				ADD		R4, R4 #0
				BRnz	CLEAR_LASER			
				JSR		HIT
				ADD		R5, R5 #0			
				BRnz	ANIMATE
CLEAR_LASER		LD		R2, MAKE_BLACK
				JSR		LASERDR
				AND		R1, R1 #0			
				STR		R1, R0 #0			; set laser to inactive (Laser[0])
				BRnzp	END_ANIMATE
ANIMATE			AND		R6, R6 #0
				ADD		R6, R2 #0			; temp store R2 in R6
				LD		R2, MAKE_BLACK
				JSR		LASERDR			; draw over the previous laser
				AND		R1, R1 #0			; clear R1
				ADD		R1, R6 #0			; load new pos into R1
				STR		R1, R0 #1			
				LD		R2, MAKE_GREEN
				JSR		LASERDR			; draw new laser position
END_ANIMATE		LD		R0, MAKE0
				LD		R1, MAKE1
				LD		R2, MAKE2
				LD		R3, MAKE3
				LD		R4, MAKE4
				LD		R5, MAKE5
				LD		R7, MAKE6
				RET
MAKE0			.BLKW 1
MAKE1			.BLKW 1
MAKE2			.BLKW 1
MAKE3			.BLKW 1
MAKE4			.BLKW 1
MAKE5			.BLKW 1
MAKE6			.BLKW 1
OFFSETY	        .FILL #-768 
MAKE_BLACK		.FILL x0000
MAKE_GREEN		.FILL x03E0




GAMEOVER		ST	R0, GAMEOVER0
				ST	R1, GAMEOVER1
				ST	R2, GAMEOVER2
				ST	R3, GAMEOVER3
				ST	R4, GAMEOVER4
				ST	R7, GAMEOVER7
				
    ; Prepare for checking alien status
    LD R2, COLOR_CHECK ; Load the value to check if an alien ship is destroyed
    AND R4, R4, #0     ; Clear R4 for counter
    ADD R4, R4, #4     ; Initialize counter for number of aliens
    LEA R0, ALIEN0     ; Load the starting address of alien data into R0
CHECKALIEN		
				LDR	R1, R0 #0
				ADD	R3, R1, R2
				BRnp CONTINUE
				ADD	R0, R0 #2
				ADD	R4, R4 #-1 ;Decrement the alien counter
				BRp	CHECKALIEN;Continue checking next alien
				LEA	R0, GAMEOVER_STR
				PUTS
				HALT

CONTINUE		LD	R0, GAMEOVER0
				LD	R1, GAMEOVER1
				LD	R2, GAMEOVER2
				LD	R3, GAMEOVER3
				LD	R4, GAMEOVER4
				LD	R7, GAMEOVER7
				RET
GAMEOVER0			.BLKW 1
GAMEOVER1			.BLKW 1
GAMEOVER2			.BLKW 1
GAMEOVER3			.BLKW 1
GAMEOVER4			.BLKW 1
GAMEOVER7			.BLKW 1
COLOR_CHECK		.FILL #-31744 ; Value to check if an alien is destroyed
GAMEOVER_STR	.STRINGZ "GAMEOVER"




CLEAR_SCREEN	
				 ST R7, CS_R7         ; Store return address
    			 LD R0, PIXELS        ; Load the total number of pixels on the screen
    			 LD R1, SCREEN_START  ; Load the starting address of the screen
   				 LD R2, CS_BLACK      ; Load the black color code
CLEAR_LOOP		STR	R2, R1 #0
				ADD	R1, R1 #1
				ADD	R0, R0 #-1
				BRp	CLEAR_LOOP
				LD	R7, CS_R7
				RET
CS_BLACK		.FILL x0000
SCREEN_START	.FILL xC000
PIXELS			.FILL #15872
CS_R7			.BLKW 1






TIMED		
   			 ST R1, TIME0        ; Store R1's original value
   			 ST R2, TIME1        ; Store R2's original value
   			 ST R3, TIME2        ; Store R3's original value
    		 ST R7, TIME3        ; Store return address
   			 AND R0, R0, #0      ; Clear R0 to prepare for input
   			 LD R2, T            ; Load the time value for the timer
   			 STI R2, MILLI       ; Set the timer with the loaded time value
POLL		
			
    		 LDI R3, TIMER       ; Load the timer status
   			 BRn EXITIN          ; Exit if the timer expires
    		 LDI R1, KBSR       ; Load the keyboard status
    		 BRzp POLL           ; Continue polling if no key is pressed
   			 LDI R0, KBDR        ; Load the pressed key value into R0

			LD		R1, TIME0
			LD		R2, TIME1
			LD		R3, TIME2
			LD		R7, TIME3
EXITIN		RET

;DATA
TIME0	.BLKW 1
TIME1	.BLKW 1
TIME2	.BLKW 1
TIME3	.BLKW 1
KBSR	.FILL xFE00 ; keyboard status register
KBDR	.FILL xFE02 ; value of recieved keypress
TIMER		.FILL xFE08	; timer register
MILLI		.FILL xFE0A ; sets number milliseconds between ticks, 0 for timer off
T	.FILL x0064 ; 200 milliseconds between ticks




.END
