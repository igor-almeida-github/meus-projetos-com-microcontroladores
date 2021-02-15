
_display7:

;sevensegmentinterrupt.c,11 :: 		void display7(int x,unsigned short int disp){
;sevensegmentinterrupt.c,12 :: 		unsigned short int tabela[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F}; // tabela dos valores correspondentes aos numeros 1 a 9, na ordem
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
;sevensegmentinterrupt.c,13 :: 		PORTD =  tabela[x];
	MOVLW       display7_tabela_L0+0
	ADDWF       FARG_display7_x+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(display7_tabela_L0+0)
	ADDWFC      FARG_display7_x+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       PORTD+0 
;sevensegmentinterrupt.c,14 :: 		if (disp==1) PORTE.RE0=1;// menos significativo
	MOVF        FARG_display7_disp+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_display70
	BSF         PORTE+0, 0 
L_display70:
;sevensegmentinterrupt.c,15 :: 		if (disp==2) PORTE.RE1=1;
	MOVF        FARG_display7_disp+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_display71
	BSF         PORTE+0, 1 
L_display71:
;sevensegmentinterrupt.c,16 :: 		if (disp==3) PORTE.RE2=1;
	MOVF        FARG_display7_disp+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_display72
	BSF         PORTE+0, 2 
L_display72:
;sevensegmentinterrupt.c,17 :: 		if (disp==4) PORTC.RC7=1;// mais significativo
	MOVF        FARG_display7_disp+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_display73
	BSF         PORTC+0, 7 
L_display73:
;sevensegmentinterrupt.c,18 :: 		}
L_end_display7:
	RETURN      0
; end of _display7

_interrupt:

;sevensegmentinterrupt.c,19 :: 		void interrupt (void){
;sevensegmentinterrupt.c,20 :: 		if (INTCON.TMR0IF==1){  // flag que indica overflow do timer 0
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt4
;sevensegmentinterrupt.c,21 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;sevensegmentinterrupt.c,22 :: 		TMR0L= 158; // reinicia o valor do reg timer 0
	MOVLW       158
	MOVWF       TMR0L+0 
;sevensegmentinterrupt.c,24 :: 		D1=(((cnt%1000)%100)%10);
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVF        _cnt+0, 0 
	MOVWF       R0 
	MOVF        _cnt+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       FLOC__interrupt+2 
	MOVF        R1, 0 
	MOVWF       FLOC__interrupt+3 
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__interrupt+2, 0 
	MOVWF       R0 
	MOVF        FLOC__interrupt+3, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       FLOC__interrupt+0 
	MOVF        R1, 0 
	MOVWF       FLOC__interrupt+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__interrupt+0, 0 
	MOVWF       R0 
	MOVF        FLOC__interrupt+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _D1+0 
;sevensegmentinterrupt.c,25 :: 		D10=((cnt%1000)%100)/10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__interrupt+0, 0 
	MOVWF       R0 
	MOVF        FLOC__interrupt+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _D10+0 
;sevensegmentinterrupt.c,26 :: 		D100=(cnt%1000)/100;
	MOVLW       100
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FLOC__interrupt+2, 0 
	MOVWF       R0 
	MOVF        FLOC__interrupt+3, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _D100+0 
;sevensegmentinterrupt.c,27 :: 		D1000=cnt/1000;
	MOVLW       232
	MOVWF       R4 
	MOVLW       3
	MOVWF       R5 
	MOVF        _cnt+0, 0 
	MOVWF       R0 
	MOVF        _cnt+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       _D1000+0 
;sevensegmentinterrupt.c,28 :: 		PORTE.RE0=0; // menos significativo
	BCF         PORTE+0, 0 
;sevensegmentinterrupt.c,29 :: 		PORTE.RE1=0;
	BCF         PORTE+0, 1 
;sevensegmentinterrupt.c,30 :: 		PORTE.RE2=0;
	BCF         PORTE+0, 2 
;sevensegmentinterrupt.c,31 :: 		PORTC.RC7=0; // mais significativo
	BCF         PORTC+0, 7 
;sevensegmentinterrupt.c,32 :: 		switch (display){
	GOTO        L_interrupt5
;sevensegmentinterrupt.c,33 :: 		case 1:{
L_interrupt7:
;sevensegmentinterrupt.c,34 :: 		display7(D1,1);
	MOVF        _D1+0, 0 
	MOVWF       FARG_display7_x+0 
	MOVLW       0
	MOVWF       FARG_display7_x+1 
	MOVLW       1
	MOVWF       FARG_display7_disp+0 
	CALL        _display7+0, 0
;sevensegmentinterrupt.c,35 :: 		break;
	GOTO        L_interrupt6
;sevensegmentinterrupt.c,37 :: 		case 2:{
L_interrupt8:
;sevensegmentinterrupt.c,38 :: 		if(D10!=0||D100!=0||D1000!=0) display7(D10,2);
	MOVF        _D10+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt25
	MOVF        _D100+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt25
	MOVF        _D1000+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt25
	GOTO        L_interrupt11
L__interrupt25:
	MOVF        _D10+0, 0 
	MOVWF       FARG_display7_x+0 
	MOVLW       0
	MOVWF       FARG_display7_x+1 
	MOVLW       2
	MOVWF       FARG_display7_disp+0 
	CALL        _display7+0, 0
L_interrupt11:
;sevensegmentinterrupt.c,39 :: 		break;
	GOTO        L_interrupt6
;sevensegmentinterrupt.c,41 :: 		case 3:{
L_interrupt12:
;sevensegmentinterrupt.c,42 :: 		if(D100!=0||D1000!=0) display7(D100,3);
	MOVF        _D100+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt24
	MOVF        _D1000+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__interrupt24
	GOTO        L_interrupt15
L__interrupt24:
	MOVF        _D100+0, 0 
	MOVWF       FARG_display7_x+0 
	MOVLW       0
	MOVWF       FARG_display7_x+1 
	MOVLW       3
	MOVWF       FARG_display7_disp+0 
	CALL        _display7+0, 0
L_interrupt15:
;sevensegmentinterrupt.c,43 :: 		break;
	GOTO        L_interrupt6
;sevensegmentinterrupt.c,45 :: 		case 4:{
L_interrupt16:
;sevensegmentinterrupt.c,46 :: 		if(D1000!=0) display7(D1000,4);
	MOVF        _D1000+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt17
	MOVF        _D1000+0, 0 
	MOVWF       FARG_display7_x+0 
	MOVLW       0
	MOVWF       FARG_display7_x+1 
	MOVLW       4
	MOVWF       FARG_display7_disp+0 
	CALL        _display7+0, 0
L_interrupt17:
;sevensegmentinterrupt.c,47 :: 		break;
	GOTO        L_interrupt6
;sevensegmentinterrupt.c,49 :: 		}
L_interrupt5:
	MOVF        _display+0, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt7
	MOVF        _display+0, 0 
	XORLW       2
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt8
	MOVF        _display+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt12
	MOVF        _display+0, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt16
L_interrupt6:
;sevensegmentinterrupt.c,50 :: 		display++;
	INCF        _display+0, 1 
;sevensegmentinterrupt.c,51 :: 		if (display == 5) display =1;
	MOVF        _display+0, 0 
	XORLW       5
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt18
	MOVLW       1
	MOVWF       _display+0 
L_interrupt18:
;sevensegmentinterrupt.c,54 :: 		}
	GOTO        L_interrupt19
L_interrupt4:
;sevensegmentinterrupt.c,56 :: 		else if (INTCON.INT0IF==1){
	BTFSS       INTCON+0, 1 
	GOTO        L_interrupt20
;sevensegmentinterrupt.c,57 :: 		cnt++;
	INFSNZ      _cnt+0, 1 
	INCF        _cnt+1, 1 
;sevensegmentinterrupt.c,58 :: 		INTCON.INT0IF=0;
	BCF         INTCON+0, 1 
;sevensegmentinterrupt.c,59 :: 		}
L_interrupt20:
L_interrupt19:
;sevensegmentinterrupt.c,61 :: 		}
L_end_interrupt:
L__interrupt28:
	RETFIE      1
; end of _interrupt

_main:

;sevensegmentinterrupt.c,64 :: 		void main()
;sevensegmentinterrupt.c,67 :: 		INTCON.TMR0IE=1;
	BSF         INTCON+0, 5 
;sevensegmentinterrupt.c,68 :: 		ADCON1=0x0F;
	MOVLW       15
	MOVWF       ADCON1+0 
;sevensegmentinterrupt.c,69 :: 		TRISD =0; // Configure PORTD as output
	CLRF        TRISD+0 
;sevensegmentinterrupt.c,70 :: 		TRISE.RE0=0; //disp 1
	BCF         TRISE+0, 0 
;sevensegmentinterrupt.c,71 :: 		TRISE.RE1=0;  //disp 2
	BCF         TRISE+0, 1 
;sevensegmentinterrupt.c,72 :: 		TRISE.RE2=0;  //disp 3
	BCF         TRISE+0, 2 
;sevensegmentinterrupt.c,73 :: 		TRISC.RC7=0;  //disp 4
	BCF         TRISC+0, 7 
;sevensegmentinterrupt.c,74 :: 		TRISB.RB0=1;  // INT0 é output
	BSF         TRISB+0, 0 
;sevensegmentinterrupt.c,76 :: 		T0CON = 0xC7;
	MOVLW       199
	MOVWF       T0CON+0 
;sevensegmentinterrupt.c,77 :: 		TMR0L= 158; // Modifica o valor do registrador  low do timer 0  com 158 para contar aprox 50ms
	MOVLW       158
	MOVWF       TMR0L+0 
;sevensegmentinterrupt.c,78 :: 		INTCON=0xB0; // configuração das interrupções
	MOVLW       176
	MOVWF       INTCON+0 
;sevensegmentinterrupt.c,80 :: 		for(;;){    // Endless loop
L_main21:
;sevensegmentinterrupt.c,82 :: 		} // End of loop
	GOTO        L_main21
;sevensegmentinterrupt.c,85 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
