;;;;;;; P4(5) for EE425 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Use this template for PART 1 OF THE FIR FILTERING SEQUENCE FOR EE425
; This file was created by AC on 3/31/2020
;
;;;;;;; Assembler directives ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

         list  P=PIC18F4520, F=INHX32, C=160, N=0, ST=OFF, MM=OFF, R=DEC, X=ON
        #include <P18F4520.inc>
        __CONFIG  _CONFIG1H, _OSC_HS_1H  ;HS oscillator
        __CONFIG  _CONFIG2L, _PWRT_ON_2L & _BOREN_ON_2L & _BORV_2_2L  ;Reset
        __CONFIG  _CONFIG2H, _WDT_OFF_2H  ;Watchdog timer disabled
        __CONFIG  _CONFIG3H, _CCP2MX_PORTC_3H  ;CCP2 to RC1 (rather than to RB3)
        __CONFIG  _CONFIG4L, _LVP_OFF_4L & _XINST_OFF_4L  ;RB5 enabled for I/O
        errorlevel -314, -315          ;Ignore lfsr messages


;;;;;;; Variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        cblock  0x000           ;Beginning of Access RAM
		; --- BEGIN variables for TABLAT POINTER
		; DO NOT MODIFY (created by AC) 
		value
		counter
		; --- END variables for TABLAT POINTER

		; Create your variables starting from here
		value_1
		value_2
		value_3
		value_4
		value_5
		value_c
        endc

;;;;;;; Macro definitions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

MOVLF   macro  literal,dest
        movlw  literal
        movwf  dest
        endm


;;;;;;; Vectors ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

        org  0x0000             ;Reset vector
        nop
        goto  Mainline

        org  0x0008             ;High priority interrupt vector
        goto  $  ;Trap

        org  0x0018             ;Low priority interrupt vector
        goto  $                  ;Trap

;;;;;;; Mainline program ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Mainline
        rcall  Initial          ;Initialize everything
Loop
	
		MOVLF  10,counter
		MOVLF upper SimpleTable,TBLPTRU 
		MOVLF high  SimpleTable,TBLPTRH 
		MOVLF low   SimpleTable,TBLPTRL
	label_A
		TBLRD*+
		movf TABLAT, W
		movwf value ; value = x[n] = W 

		;;;;;;; NOTE FOR STUDENTS:
		; 
		; Write the code for your moving average filter in 
		; the empty spaces below. Please create subroutines 
		; to make code your code transparent and easier to debug
		;
		; DO NOT MODIFY ANY OTHER PART OF THE THIS LOOP IN THE MAINLINE
		;
		; --------------------------------------------------------------
		; BEGIN WRTING CODE HERE 
		
			; ---------------------------------
			; (1) WRITE CODE FOR MEMORY BUFFER HERE
			;       you may write the full code 
			;		here or call a subroutine
	memory_buffer
		movff value_5, value_c ; save x[n-5] into c[n]
		movff value_4, value_5 ; save x[n-4] into x[n-5]
		movff value_3, value_4 ; save x[n-3] into x[n-4]
		movff value_2,value_3 ; save x[n-2] into x[n-3]
		movff value_1, value_2 ; save x[n-1] into x[n-2]
		movff value, value_1 ; save x[n] into x[n-1]
			; ---------------------------------
			; (2) WRITE CODE FOR ADDER AND "DIVIDER" HERE 
			;       you may write the full code 
			;		here or call a subroutine
	adder_divider
		addwf value_c ; add x[n] (from current contents of W) into value_c (AKA x[n-5])
		rrcf value_c, 1 ; divide by 2 for final c[n] value

		; FINISH WRTING CODE HERE 
		; --------------------------------------------------------------

		decf  counter,F        
	    bz  label_B
		bra label_A
	label_B

        bra	Loop
	



;;;;;;; Initial subroutine ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; This subroutine performs all initializations of variables and registers.

Initial
        MOVLF  B'10001110',ADCON1  ;Enable PORTA & PORTE digital I/O pins
        MOVLF  B'11100001',TRISA  ;Set I/O for PORTA 0 = output, 1 = input
        MOVLF  B'11011100',TRISB  ;Set I/O for PORTB
        MOVLF  B'11010000',TRISC  ;Set I/0 for PORTC
        MOVLF  B'00001111',TRISD  ;Set I/O for PORTD
        MOVLF  B'00000000',TRISE  ;Set I/O for PORTE
        MOVLF  B'10001000',T0CON  ;Set up Timer0 for a looptime of 10 ms;  bit7=1 enables timer; bit3=1 bypass prescaler
        MOVLF  B'00010000',PORTA  ;Turn off all four LEDs driven from PORTA ; See pin diagrams of Page 5 in DataSheet
        return



;;;;;;; TIME SERIES DATA
;
; 	The following bytes are stored in program memory.
;   Created by AC 
;	DO NOT MODIFY
;
SimpleTable 
db 0,50,100,150,200,250,200,150,100,50
; --------------------------------------------------------------

        end


