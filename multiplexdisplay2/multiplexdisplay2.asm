
_display7:

;multiplexdisplay2.c,3 :: 		void display7(int x,int disp){
;multiplexdisplay2.c,4 :: 		unsigned short int tabela[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F}; // tabela dos valores correspondentes aos numeros 1 a 9, na ordem
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
;multiplexdisplay2.c,5 :: 		PORTE.RE0=0; //  display MSD
	BCF         PORTE+0, 0 
;multiplexdisplay2.c,6 :: 		PORTE.RE1=0;  //  display LSD
	BCF         PORTE+0, 1 
;multiplexdisplay2.c,7 :: 		PORTD =  tabela[x];
	MOVLW       display7_tabela_L0+0
	ADDWF       FARG_display7_x+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(display7_tabela_L0+0)
	ADDWFC      FARG_display7_x+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       PORTD+0 
;multiplexdisplay2.c,8 :: 		if (disp==2) PORTE.RE0=1;
	MOVLW       0
	XORWF       FARG_display7_disp+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display78
	MOVLW       2
	XORWF       FARG_display7_disp+0, 0 
L__display78:
	BTFSS       STATUS+0, 2 
	GOTO        L_display70
	BSF         PORTE+0, 0 
L_display70:
;multiplexdisplay2.c,9 :: 		if (disp==1) PORTE.RE1=1;
	MOVLW       0
	XORWF       FARG_display7_disp+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display79
	MOVLW       1
	XORWF       FARG_display7_disp+0, 0 
L__display79:
	BTFSS       STATUS+0, 2 
	GOTO        L_display71
	BSF         PORTE+0, 1 
L_display71:
;multiplexdisplay2.c,11 :: 		}
L_end_display7:
	RETURN      0
; end of _display7

_main:

;multiplexdisplay2.c,13 :: 		void main()
;multiplexdisplay2.c,18 :: 		unsigned short int  cnt=28;
	MOVLW       28
	MOVWF       main_cnt_L0+0 
;multiplexdisplay2.c,20 :: 		ADCON1=0x0F;
	MOVLW       15
	MOVWF       ADCON1+0 
;multiplexdisplay2.c,21 :: 		TRISD =0; // Configure PORTB as output
	CLRF        TRISD+0 
;multiplexdisplay2.c,22 :: 		TRISE.RE0=0;
	BCF         TRISE+0, 0 
;multiplexdisplay2.c,23 :: 		TRISE.RE1=0;
	BCF         TRISE+0, 1 
;multiplexdisplay2.c,25 :: 		for(;;){    // Endless loop
L_main2:
;multiplexdisplay2.c,26 :: 		LSD=cnt%10;
	MOVLW       10
	MOVWF       R4 
	MOVF        main_cnt_L0+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       10
	MOVWF       R4 
	MOVF        main_cnt_L0+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
;multiplexdisplay2.c,27 :: 		MSD=cnt/10;
	MOVF        R0, 0 
	MOVWF       main_MSD_L0+0 
;multiplexdisplay2.c,28 :: 		display7(LSD,1);
	MOVF        FLOC__main+0, 0 
	MOVWF       FARG_display7_x+0 
	MOVLW       0
	MOVWF       FARG_display7_x+1 
	MOVLW       1
	MOVWF       FARG_display7_disp+0 
	MOVLW       0
	MOVWF       FARG_display7_disp+1 
	CALL        _display7+0, 0
;multiplexdisplay2.c,29 :: 		Delay_ms(10);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main5:
	DECFSZ      R13, 1, 1
	BRA         L_main5
	DECFSZ      R12, 1, 1
	BRA         L_main5
	NOP
	NOP
;multiplexdisplay2.c,30 :: 		display7(MSD,2);
	MOVF        main_MSD_L0+0, 0 
	MOVWF       FARG_display7_x+0 
	MOVLW       0
	MOVWF       FARG_display7_x+1 
	MOVLW       2
	MOVWF       FARG_display7_disp+0 
	MOVLW       0
	MOVWF       FARG_display7_disp+1 
	CALL        _display7+0, 0
;multiplexdisplay2.c,31 :: 		Delay_ms(10);
	MOVLW       52
	MOVWF       R12, 0
	MOVLW       241
	MOVWF       R13, 0
L_main6:
	DECFSZ      R13, 1, 1
	BRA         L_main6
	DECFSZ      R12, 1, 1
	BRA         L_main6
	NOP
	NOP
;multiplexdisplay2.c,33 :: 		} // End of loop
	GOTO        L_main2
;multiplexdisplay2.c,36 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
