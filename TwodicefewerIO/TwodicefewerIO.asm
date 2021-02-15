
_jogardado:

;TwodicefewerIO.c,5 :: 		unsigned char jogardado(){
;TwodicefewerIO.c,7 :: 		unsigned char tabela[]={0x08,0x01,0x09,0x06,0x0E,0x07}; // Tabela para indicar o que escrever no portB
	MOVLW       8
	MOVWF       jogardado_tabela_L0+0 
	MOVLW       1
	MOVWF       jogardado_tabela_L0+1 
	MOVLW       9
	MOVWF       jogardado_tabela_L0+2 
	MOVLW       6
	MOVWF       jogardado_tabela_L0+3 
	MOVLW       14
	MOVWF       jogardado_tabela_L0+4 
	MOVLW       7
	MOVWF       jogardado_tabela_L0+5 
;TwodicefewerIO.c,9 :: 		p=floor((rand()/5462)); // rand gera numero entre 0 e 32767
	CALL        _rand+0, 0
	MOVLW       86
	MOVWF       R4 
	MOVLW       21
	MOVWF       R5 
	CALL        _Div_16x16_S+0, 0
	CALL        _int2double+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_floor_x+0 
	MOVF        R1, 0 
	MOVWF       FARG_floor_x+1 
	MOVF        R2, 0 
	MOVWF       FARG_floor_x+2 
	MOVF        R3, 0 
	MOVWF       FARG_floor_x+3 
	CALL        _floor+0, 0
	CALL        _double2int+0, 0
;TwodicefewerIO.c,11 :: 		resultado = tabela[p];
	MOVLW       jogardado_tabela_L0+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(jogardado_tabela_L0+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
;TwodicefewerIO.c,12 :: 		return resultado;
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
;TwodicefewerIO.c,13 :: 		}
L_end_jogardado:
	RETURN      0
; end of _jogardado

_main:

;TwodicefewerIO.c,17 :: 		void main()
;TwodicefewerIO.c,19 :: 		ADCON1=0x0F;
	MOVLW       15
	MOVWF       ADCON1+0 
;TwodicefewerIO.c,20 :: 		TRISD.RD0=1; //botao � input
	BSF         TRISD+0, 0 
;TwodicefewerIO.c,21 :: 		TRISB =0; // Configure PORTB as output
	CLRF        TRISB+0 
;TwodicefewerIO.c,22 :: 		srand(1); // semente do rand
	MOVLW       1
	MOVWF       FARG_srand_x+0 
	MOVLW       0
	MOVWF       FARG_srand_x+1 
	CALL        _srand+0, 0
;TwodicefewerIO.c,24 :: 		for(;;)          // Endless loop
L_main0:
;TwodicefewerIO.c,26 :: 		if (botao==pressionado){
	BTFSC       PORTD+0, 0 
	GOTO        L_main3
;TwodicefewerIO.c,27 :: 		L=jogardado();
	CALL        _jogardado+0, 0
	MOVF        R0, 0 
	MOVWF       _L+0 
	MOVLW       0
	MOVWF       _L+1 
;TwodicefewerIO.c,28 :: 		H=jogardado();
	CALL        _jogardado+0, 0
	MOVF        R0, 0 
	MOVWF       _H+0 
	MOVLW       0
	MOVWF       _H+1 
;TwodicefewerIO.c,29 :: 		PORTB=(H*16+L);
	MOVLW       4
	MOVWF       R1 
	MOVF        _H+0, 0 
	MOVWF       R0 
	MOVF        R1, 0 
L__main7:
	BZ          L__main8
	RLCF        R0, 1 
	BCF         R0, 0 
	ADDLW       255
	GOTO        L__main7
L__main8:
	MOVF        _L+0, 0 
	ADDWF       R0, 0 
	MOVWF       PORTB+0 
;TwodicefewerIO.c,30 :: 		Delay_Ms(3000); // Wait 3 s
	MOVLW       61
	MOVWF       R11, 0
	MOVLW       225
	MOVWF       R12, 0
	MOVLW       63
	MOVWF       R13, 0
L_main4:
	DECFSZ      R13, 1, 1
	BRA         L_main4
	DECFSZ      R12, 1, 1
	BRA         L_main4
	DECFSZ      R11, 1, 1
	BRA         L_main4
	NOP
	NOP
;TwodicefewerIO.c,31 :: 		}
L_main3:
;TwodicefewerIO.c,32 :: 		PORTB=0;
	CLRF        PORTB+0 
;TwodicefewerIO.c,33 :: 		}
	GOTO        L_main0
;TwodicefewerIO.c,34 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
