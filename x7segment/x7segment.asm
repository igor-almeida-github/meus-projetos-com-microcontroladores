
_display7:

;x7segment.c,3 :: 		unsigned short int display7(int x){
;x7segment.c,4 :: 		unsigned short int tabela[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
	MOVLW       63
	MOVWF       display7_tabela_L0+0 
	MOVLW       6
	MOVWF       display7_tabela_L0+1 
	MOVLW       91
	MOVWF       display7_tabela_L0+2 
	MOVLW       79
	MOVWF       display7_tabela_L0+3 
	MOVLW       102
	MOVWF       display7_tabela_L0+4 
	MOVLW       109
	MOVWF       display7_tabela_L0+5 
	MOVLW       125
	MOVWF       display7_tabela_L0+6 
	MOVLW       7
	MOVWF       display7_tabela_L0+7 
	MOVLW       127
	MOVWF       display7_tabela_L0+8 
	MOVLW       111
	MOVWF       display7_tabela_L0+9 
;x7segment.c,5 :: 		return tabela[x];
	MOVLW       display7_tabela_L0+0
	ADDWF       FARG_display7_x+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(display7_tabela_L0+0)
	ADDWFC      FARG_display7_x+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
;x7segment.c,6 :: 		}
L_end_display7:
	RETURN      0
; end of _display7

_main:

;x7segment.c,8 :: 		void main()
;x7segment.c,11 :: 		ADCON1=0x0F;
	MOVLW       15
	MOVWF       ADCON1+0 
;x7segment.c,12 :: 		TRISD =0; // Configure PORTB as output
	CLRF        TRISD+0 
;x7segment.c,14 :: 		for(;;){    // Endless loop
L_main0:
;x7segment.c,15 :: 		for (i=0;i<10;i++){
	CLRF        _i+0 
	CLRF        _i+1 
L_main3:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main9
	MOVLW       10
	SUBWF       _i+0, 0 
L__main9:
	BTFSC       STATUS+0, 0 
	GOTO        L_main4
;x7segment.c,16 :: 		PORTD = display7(i);
	MOVF        _i+0, 0 
	MOVWF       FARG_display7_x+0 
	MOVF        _i+1, 0 
	MOVWF       FARG_display7_x+1 
	CALL        _display7+0, 0
	MOVF        R0, 0 
	MOVWF       PORTD+0 
;x7segment.c,17 :: 		Delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       8
	MOVWF       R12, 0
	MOVLW       119
	MOVWF       R13, 0
L_main6:
	DECFSZ      R13, 1, 1
	BRA         L_main6
	DECFSZ      R12, 1, 1
	BRA         L_main6
	DECFSZ      R11, 1, 1
	BRA         L_main6
;x7segment.c,15 :: 		for (i=0;i<10;i++){
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;x7segment.c,18 :: 		}
	GOTO        L_main3
L_main4:
;x7segment.c,20 :: 		} // End of loop
	GOTO        L_main0
;x7segment.c,23 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
