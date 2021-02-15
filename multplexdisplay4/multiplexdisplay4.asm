
_display7:

;multiplexdisplay4.c,3 :: 		void display7(int x,int disp){
;multiplexdisplay4.c,4 :: 		unsigned short int tabela[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F}; // tabela dos valores correspondentes aos numeros 1 a 9, na ordem
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
;multiplexdisplay4.c,5 :: 		PORTE.RE0=0; // menos significativo
	BCF         PORTE+0, 0 
;multiplexdisplay4.c,6 :: 		PORTE.RE1=0;
	BCF         PORTE+0, 1 
;multiplexdisplay4.c,7 :: 		PORTE.RE2=0;
	BCF         PORTE+0, 2 
;multiplexdisplay4.c,8 :: 		PORTC.RC7=0; // mais significativo
	BCF         PORTC+0, 7 
;multiplexdisplay4.c,9 :: 		PORTD =  tabela[x];
	MOVLW       display7_tabela_L0+0
	ADDWF       FARG_display7_x+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(display7_tabela_L0+0)
	ADDWFC      FARG_display7_x+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       PORTD+0 
;multiplexdisplay4.c,10 :: 		if (disp==1) PORTE.RE0=1;
	MOVLW       0
	XORWF       FARG_display7_disp+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display712
	MOVLW       1
	XORWF       FARG_display7_disp+0, 0 
L__display712:
	BTFSS       STATUS+0, 2 
	GOTO        L_display70
	BSF         PORTE+0, 0 
L_display70:
;multiplexdisplay4.c,11 :: 		if (disp==2) PORTE.RE1=1;
	MOVLW       0
	XORWF       FARG_display7_disp+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display713
	MOVLW       2
	XORWF       FARG_display7_disp+0, 0 
L__display713:
	BTFSS       STATUS+0, 2 
	GOTO        L_display71
	BSF         PORTE+0, 1 
L_display71:
;multiplexdisplay4.c,12 :: 		if (disp==3) PORTE.RE2=1;
	MOVLW       0
	XORWF       FARG_display7_disp+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display714
	MOVLW       3
	XORWF       FARG_display7_disp+0, 0 
L__display714:
	BTFSS       STATUS+0, 2 
	GOTO        L_display72
	BSF         PORTE+0, 2 
L_display72:
;multiplexdisplay4.c,13 :: 		if (disp==4) PORTC.RC7=1;
	MOVLW       0
	XORWF       FARG_display7_disp+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__display715
	MOVLW       4
	XORWF       FARG_display7_disp+0, 0 
L__display715:
	BTFSS       STATUS+0, 2 
	GOTO        L_display73
	BSF         PORTC+0, 7 
L_display73:
;multiplexdisplay4.c,14 :: 		}
L_end_display7:
	RETURN      0
; end of _display7

_main:

;multiplexdisplay4.c,16 :: 		void main()
;multiplexdisplay4.c,22 :: 		unsigned int  cnt=1234;
	MOVLW       210
	MOVWF       main_cnt_L0+0 
	MOVLW       4
	MOVWF       main_cnt_L0+1 
;multiplexdisplay4.c,24 :: 		ADCON1=0x0F;
	MOVLW       15
	MOVWF       ADCON1+0 
;multiplexdisplay4.c,25 :: 		TRISD =0; // Configure PORTB as output
	CLRF        TRISD+0 
;multiplexdisplay4.c,26 :: 		TRISE.RE0=0;
	BCF         TRISE+0, 0 
;multiplexdisplay4.c,27 :: 		TRISE.RE1=0;
	BCF         TRISE+0, 1 
;multiplexdisplay4.c,28 :: 		TRISE.RE2=0;
	BCF         TRISE+0, 2 
;multiplexdisplay4.c,29 :: 		TRISC.RC7=0;
	BCF         TRISC+0, 7 
;multiplexdisplay4.c,31 :: 		for(;;){    // Endless loop
L_main4:
;multiplexdisplay4.c,32 :: 		D1000=cnt/1000;
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVF        main_cnt_L0+0, 0 
	MOVWF       R0 
	MOVF        main_cnt_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       main_D1000_L0+0 
;multiplexdisplay4.c,33 :: 		D100=(cnt%1000)/100;
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVF        main_cnt_L0+0, 0 
	MOVWF       R0 
	MOVF        main_cnt_L0+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       main_D100_L0+0 
;multiplexdisplay4.c,34 :: 		D10=((cnt%1000)%100)/10;
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       FLOC__main+0 
	MOVF        R1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       main_D10_L0+0 
;multiplexdisplay4.c,35 :: 		D1=(((cnt%1000)%100)%10);
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__main+0, 0 
	MOVWF       R0 
	MOVF        FLOC__main+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
;multiplexdisplay4.c,36 :: 		display7(D1,1);
	MOVF        R0, 0 
	MOVWF       FARG_display7_x+0 
	MOVLW       0
	MOVWF       FARG_display7_x+1 
	MOVLW       1
	MOVWF       FARG_display7_disp+0 
	MOVLW       0
	MOVWF       FARG_display7_disp+1 
	CALL        _display7+0, 0
;multiplexdisplay4.c,37 :: 		Delay_ms(40);
	MOVLW       208
	MOVWF       R12, 0
	MOVLW       201
	MOVWF       R13, 0
L_main7:
	DECFSZ      R13, 1, 1
	BRA         L_main7
	DECFSZ      R12, 1, 1
	BRA         L_main7
	NOP
	NOP
;multiplexdisplay4.c,38 :: 		display7(D10,2);
	MOVF        main_D10_L0+0, 0 
	MOVWF       FARG_display7_x+0 
	MOVLW       0
	MOVWF       FARG_display7_x+1 
	MOVLW       2
	MOVWF       FARG_display7_disp+0 
	MOVLW       0
	MOVWF       FARG_display7_disp+1 
	CALL        _display7+0, 0
;multiplexdisplay4.c,39 :: 		Delay_ms(40);
	MOVLW       208
	MOVWF       R12, 0
	MOVLW       201
	MOVWF       R13, 0
L_main8:
	DECFSZ      R13, 1, 1
	BRA         L_main8
	DECFSZ      R12, 1, 1
	BRA         L_main8
	NOP
	NOP
;multiplexdisplay4.c,40 :: 		display7(D100,3);
	MOVF        main_D100_L0+0, 0 
	MOVWF       FARG_display7_x+0 
	MOVLW       0
	MOVWF       FARG_display7_x+1 
	MOVLW       3
	MOVWF       FARG_display7_disp+0 
	MOVLW       0
	MOVWF       FARG_display7_disp+1 
	CALL        _display7+0, 0
;multiplexdisplay4.c,41 :: 		Delay_ms(40);
	MOVLW       208
	MOVWF       R12, 0
	MOVLW       201
	MOVWF       R13, 0
L_main9:
	DECFSZ      R13, 1, 1
	BRA         L_main9
	DECFSZ      R12, 1, 1
	BRA         L_main9
	NOP
	NOP
;multiplexdisplay4.c,42 :: 		display7(D1000,4);
	MOVF        main_D1000_L0+0, 0 
	MOVWF       FARG_display7_x+0 
	MOVLW       0
	MOVWF       FARG_display7_x+1 
	MOVLW       4
	MOVWF       FARG_display7_disp+0 
	MOVLW       0
	MOVWF       FARG_display7_disp+1 
	CALL        _display7+0, 0
;multiplexdisplay4.c,43 :: 		Delay_ms(40);
	MOVLW       208
	MOVWF       R12, 0
	MOVLW       201
	MOVWF       R13, 0
L_main10:
	DECFSZ      R13, 1, 1
	BRA         L_main10
	DECFSZ      R12, 1, 1
	BRA         L_main10
	NOP
	NOP
;multiplexdisplay4.c,44 :: 		} // End of loop
	GOTO        L_main4
;multiplexdisplay4.c,47 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
