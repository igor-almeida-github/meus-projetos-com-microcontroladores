
_jogardado:

;Leddice.c,5 :: 		unsigned char jogardado(){
;Leddice.c,7 :: 		unsigned char tabela[]={0x08,0x41,0x1C,0x55,0x5D,0x77}; // Tabela para indicar o que escrever no portB
	MOVLW       8
	MOVWF       jogardado_tabela_L0+0 
	MOVLW       65
	MOVWF       jogardado_tabela_L0+1 
	MOVLW       28
	MOVWF       jogardado_tabela_L0+2 
	MOVLW       85
	MOVWF       jogardado_tabela_L0+3 
	MOVLW       93
	MOVWF       jogardado_tabela_L0+4 
	MOVLW       119
	MOVWF       jogardado_tabela_L0+5 
;Leddice.c,9 :: 		p=floor((rand()/5462)); // rand gera numero entre 0 e 32767
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
;Leddice.c,11 :: 		resultado = tabela[p];
	MOVLW       jogardado_tabela_L0+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(jogardado_tabela_L0+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
;Leddice.c,12 :: 		return resultado;
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
;Leddice.c,13 :: 		}
L_end_jogardado:
	RETURN      0
; end of _jogardado

_main:

;Leddice.c,15 :: 		void main()
;Leddice.c,17 :: 		ADCON1=0x0F;
	MOVLW       15
	MOVWF       ADCON1+0 
;Leddice.c,18 :: 		TRISD.RD0=1; //botao é input
	BSF         TRISD+0, 0 
;Leddice.c,19 :: 		TRISB =0; // Configure PORTB as output
	CLRF        TRISB+0 
;Leddice.c,20 :: 		srand(1); // semente do rand
	MOVLW       1
	MOVWF       FARG_srand_x+0 
	MOVLW       0
	MOVWF       FARG_srand_x+1 
	CALL        _srand+0, 0
;Leddice.c,22 :: 		for(;;)          // Endless loop
L_main0:
;Leddice.c,24 :: 		if (botao==pressionado){
	BTFSC       PORTD+0, 0 
	GOTO        L_main3
;Leddice.c,25 :: 		PORTB=jogardado();
	CALL        _jogardado+0, 0
	MOVF        R0, 0 
	MOVWF       PORTB+0 
;Leddice.c,26 :: 		Delay_Ms(3000); // Wait 3 s
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
;Leddice.c,27 :: 		}
L_main3:
;Leddice.c,28 :: 		PORTB=0;
	CLRF        PORTB+0 
;Leddice.c,30 :: 		}
	GOTO        L_main0
;Leddice.c,31 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
