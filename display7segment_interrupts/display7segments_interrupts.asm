
_display:

;display7segments_interrupts.c,10 :: 		void display(unsigned int dispnum){
;display7segments_interrupts.c,11 :: 		D1000=dispnum/1000;
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	MOVF       FARG_display_dispnum+0, 0
	MOVWF      R0+0
	MOVF       FARG_display_dispnum+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _D1000+0
;display7segments_interrupts.c,12 :: 		D100=(dispnum%1000)/100;
	MOVLW      232
	MOVWF      R4+0
	MOVLW      3
	MOVWF      R4+1
	MOVF       FARG_display_dispnum+0, 0
	MOVWF      R0+0
	MOVF       FARG_display_dispnum+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      FLOC__display+0
	MOVF       R0+1, 0
	MOVWF      FLOC__display+1
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__display+0, 0
	MOVWF      R0+0
	MOVF       FLOC__display+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _D100+0
;display7segments_interrupts.c,13 :: 		D10=((dispnum%1000)%100)/10;
	MOVLW      100
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__display+0, 0
	MOVWF      R0+0
	MOVF       FLOC__display+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      FLOC__display+0
	MOVF       R0+1, 0
	MOVWF      FLOC__display+1
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__display+0, 0
	MOVWF      R0+0
	MOVF       FLOC__display+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      _D10+0
;display7segments_interrupts.c,14 :: 		D1=(((dispnum%1000)%100)%10);
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FLOC__display+0, 0
	MOVWF      R0+0
	MOVF       FLOC__display+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _D1+0
;display7segments_interrupts.c,15 :: 		}
L_end_display:
	RETURN
; end of _display

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;display7segments_interrupts.c,17 :: 		void interrupt(void){
;display7segments_interrupts.c,18 :: 		if(INTCON.TMR0IF){                                                        // Ocorreu overflow do timer 0
	BTFSS      INTCON+0, 2
	GOTO       L_interrupt0
;display7segments_interrupts.c,19 :: 		INTCON.TMR0IF=0;                                                      // Limpa a flag de overflow
	BCF        INTCON+0, 2
;display7segments_interrupts.c,20 :: 		switch (disp){
	GOTO       L_interrupt1
;display7segments_interrupts.c,21 :: 		case 1:
L_interrupt3:
;display7segments_interrupts.c,22 :: 		disp1=1;
	BSF        PORTA+0, 5
;display7segments_interrupts.c,23 :: 		disp2=0;
	BCF        PORTA+0, 2
;display7segments_interrupts.c,24 :: 		disp3=0;
	BCF        PORTE+0, 0
;display7segments_interrupts.c,25 :: 		disp4=0;
	BCF        PORTE+0, 2
;display7segments_interrupts.c,26 :: 		PORTD=sevenSegTable[D1];
	MOVF       _D1+0, 0
	ADDLW      _sevenSegTable+0
	MOVWF      R0+0
	MOVLW      hi_addr(_sevenSegTable+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      PORTD+0
;display7segments_interrupts.c,27 :: 		break;
	GOTO       L_interrupt2
;display7segments_interrupts.c,28 :: 		case 2:
L_interrupt4:
;display7segments_interrupts.c,29 :: 		disp1=0;
	BCF        PORTA+0, 5
;display7segments_interrupts.c,30 :: 		disp2=1;
	BSF        PORTA+0, 2
;display7segments_interrupts.c,31 :: 		disp3=0;
	BCF        PORTE+0, 0
;display7segments_interrupts.c,32 :: 		disp4=0;
	BCF        PORTE+0, 2
;display7segments_interrupts.c,33 :: 		PORTD=sevenSegTable[D10];
	MOVF       _D10+0, 0
	ADDLW      _sevenSegTable+0
	MOVWF      R0+0
	MOVLW      hi_addr(_sevenSegTable+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      PORTD+0
;display7segments_interrupts.c,34 :: 		break;
	GOTO       L_interrupt2
;display7segments_interrupts.c,35 :: 		case 3:
L_interrupt5:
;display7segments_interrupts.c,36 :: 		disp1=0;
	BCF        PORTA+0, 5
;display7segments_interrupts.c,37 :: 		disp2=0;
	BCF        PORTA+0, 2
;display7segments_interrupts.c,38 :: 		disp3=1;
	BSF        PORTE+0, 0
;display7segments_interrupts.c,39 :: 		disp4=0;
	BCF        PORTE+0, 2
;display7segments_interrupts.c,40 :: 		PORTD=sevenSegTable[D100];
	MOVF       _D100+0, 0
	ADDLW      _sevenSegTable+0
	MOVWF      R0+0
	MOVLW      hi_addr(_sevenSegTable+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      PORTD+0
;display7segments_interrupts.c,41 :: 		break;
	GOTO       L_interrupt2
;display7segments_interrupts.c,42 :: 		case 4:
L_interrupt6:
;display7segments_interrupts.c,43 :: 		disp1=0;
	BCF        PORTA+0, 5
;display7segments_interrupts.c,44 :: 		disp2=0;
	BCF        PORTA+0, 2
;display7segments_interrupts.c,45 :: 		disp3=0;
	BCF        PORTE+0, 0
;display7segments_interrupts.c,46 :: 		disp4=1;
	BSF        PORTE+0, 2
;display7segments_interrupts.c,47 :: 		PORTD=sevenSegTable[D1000];
	MOVF       _D1000+0, 0
	ADDLW      _sevenSegTable+0
	MOVWF      R0+0
	MOVLW      hi_addr(_sevenSegTable+0)
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      ___DoICPAddr+0
	MOVF       R0+1, 0
	MOVWF      ___DoICPAddr+1
	CALL       _____DoICP+0
	MOVWF      PORTD+0
;display7segments_interrupts.c,48 :: 		break;
	GOTO       L_interrupt2
;display7segments_interrupts.c,49 :: 		}
L_interrupt1:
	MOVF       _disp+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt3
	MOVF       _disp+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt4
	MOVF       _disp+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt5
	MOVF       _disp+0, 0
	XORLW      4
	BTFSC      STATUS+0, 2
	GOTO       L_interrupt6
L_interrupt2:
;display7segments_interrupts.c,50 :: 		disp++;
	INCF       _disp+0, 1
;display7segments_interrupts.c,51 :: 		if (disp==5) disp=1;
	MOVF       _disp+0, 0
	XORLW      5
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt7
	MOVLW      1
	MOVWF      _disp+0
L_interrupt7:
;display7segments_interrupts.c,52 :: 		if ((disp==4)&&(D1000==0)) disp=1;
	MOVF       _disp+0, 0
	XORLW      4
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt10
	MOVF       _D1000+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt10
L__interrupt24:
	MOVLW      1
	MOVWF      _disp+0
L_interrupt10:
;display7segments_interrupts.c,53 :: 		if ((disp==3)&&(D1000==0)&&(D100==0)) disp=1;
	MOVF       _disp+0, 0
	XORLW      3
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt13
	MOVF       _D1000+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt13
	MOVF       _D100+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt13
L__interrupt23:
	MOVLW      1
	MOVWF      _disp+0
L_interrupt13:
;display7segments_interrupts.c,54 :: 		if ((disp==2)&&(D1000==0)&&(D100==0)&&(D10==0)) disp=1;
	MOVF       _disp+0, 0
	XORLW      2
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt16
	MOVF       _D1000+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt16
	MOVF       _D100+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt16
	MOVF       _D10+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt16
L__interrupt22:
	MOVLW      1
	MOVWF      _disp+0
L_interrupt16:
;display7segments_interrupts.c,55 :: 		}
L_interrupt0:
;display7segments_interrupts.c,56 :: 		}
L_end_interrupt:
L__interrupt27:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;display7segments_interrupts.c,59 :: 		void main() {
;display7segments_interrupts.c,61 :: 		unsigned int rpm=0;
	CLRF       main_rpm_L0+0
	CLRF       main_rpm_L0+1
;display7segments_interrupts.c,63 :: 		ADCON1=0x07;                                                               // Todas ass portas são digitais
	MOVLW      7
	MOVWF      ADCON1+0
;display7segments_interrupts.c,64 :: 		TRISD=0x00;                                                                // Todas as portas são OUTPUT exceto RD7
	CLRF       TRISD+0
;display7segments_interrupts.c,65 :: 		TRISA.RA5=0;
	BCF        TRISA+0, 5
;display7segments_interrupts.c,66 :: 		TRISA.RA2=0;
	BCF        TRISA+0, 2
;display7segments_interrupts.c,67 :: 		TRISE.RE0=0;
	BCF        TRISE+0, 0
;display7segments_interrupts.c,68 :: 		TRISE.RE2=0;
	BCF        TRISE+0, 2
;display7segments_interrupts.c,70 :: 		INTCON=0xA0;                                                               // Interrupções globais habilitadas, interrupção do timer 0 habilitada
	MOVLW      160
	MOVWF      INTCON+0
;display7segments_interrupts.c,72 :: 		OPTION_REG=0xC2;                                                           // Timer 0 com prescale de 8, clock interno, incremento na borda de subida. overflow a cada 1024ms
	MOVLW      194
	MOVWF      OPTION_REG+0
;display7segments_interrupts.c,73 :: 		PORTD=sevenSegTable[0];
	MOVLW      63
	MOVWF      PORTD+0
;display7segments_interrupts.c,74 :: 		for(;;){
L_main17:
;display7segments_interrupts.c,75 :: 		rpm++;
	INCF       main_rpm_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       main_rpm_L0+1, 1
;display7segments_interrupts.c,76 :: 		display(rpm);
	MOVF       main_rpm_L0+0, 0
	MOVWF      FARG_display_dispnum+0
	MOVF       main_rpm_L0+1, 0
	MOVWF      FARG_display_dispnum+1
	CALL       _display+0
;display7segments_interrupts.c,77 :: 		delay_ms(10);
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_main20:
	DECFSZ     R13+0, 1
	GOTO       L_main20
	DECFSZ     R12+0, 1
	GOTO       L_main20
	NOP
;display7segments_interrupts.c,78 :: 		if (rpm==9999) rpm=0;
	MOVF       main_rpm_L0+1, 0
	XORLW      39
	BTFSS      STATUS+0, 2
	GOTO       L__main29
	MOVLW      15
	XORWF      main_rpm_L0+0, 0
L__main29:
	BTFSS      STATUS+0, 2
	GOTO       L_main21
	CLRF       main_rpm_L0+0
	CLRF       main_rpm_L0+1
L_main21:
;display7segments_interrupts.c,80 :: 		}
	GOTO       L_main17
;display7segments_interrupts.c,82 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
