
_ledstrip_write0:

;fitaledtest.c,17 :: 		void ledstrip_write0(void){
;fitaledtest.c,19 :: 		PORTB.RB2=1; //200ns   1 ciclo de maquina
	BSF         PORTB+0, 2 
;fitaledtest.c,20 :: 		asm nop      // desperdiça 200ns
	NOP
;fitaledtest.c,21 :: 		PORTB.RB2=0; //200ns
	BCF         PORTB+0, 2 
;fitaledtest.c,23 :: 		}
L_end_ledstrip_write0:
	RETURN      0
; end of _ledstrip_write0

_ledstrip_write1:

;fitaledtest.c,24 :: 		void ledstrip_write1(void){
;fitaledtest.c,26 :: 		PORTB.RB2=1; //200ns   1 ciclo de maquina
	BSF         PORTB+0, 2 
;fitaledtest.c,27 :: 		asm nop      // desperdiça 200ns
	NOP
;fitaledtest.c,28 :: 		asm nop      // desperdiça 200ns
	NOP
;fitaledtest.c,29 :: 		asm nop      // desperdiça 200ns
	NOP
;fitaledtest.c,30 :: 		PORTB.RB2=0; //200ns
	BCF         PORTB+0, 2 
;fitaledtest.c,32 :: 		}
L_end_ledstrip_write1:
	RETURN      0
; end of _ledstrip_write1

_ledstrip:

;fitaledtest.c,33 :: 		void ledstrip(unsigned char red, unsigned char green, unsigned char blue){
;fitaledtest.c,37 :: 		for (k=7;k>=0;k--){  // enviando bit mais significante primeiro
	MOVLW       7
	MOVWF       ledstrip_k_L0+0 
L_ledstrip0:
	MOVLW       128
	XORWF       ledstrip_k_L0+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_ledstrip1
;fitaledtest.c,39 :: 		if ((green &(0x01<<k))==0){ // green and ( binario 0000 0001 desviado de k unidades para a esquerda). Se o resultado do and for zero, quer dizer que o bit de green na posição k é 0, caso contrário, ele é 1
	MOVF        ledstrip_k_L0+0, 0 
	MOVWF       R2 
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__ledstrip75:
	BZ          L__ledstrip76
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__ledstrip75
L__ledstrip76:
	MOVF        R0, 0 
	ANDWF       FARG_ledstrip_green+0, 0 
	MOVWF       R2 
	MOVLW       0
	ANDWF       R1, 0 
	MOVWF       R3 
	MOVLW       0
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ledstrip77
	MOVLW       0
	XORWF       R2, 0 
L__ledstrip77:
	BTFSS       STATUS+0, 2 
	GOTO        L_ledstrip3
;fitaledtest.c,40 :: 		ledstrip_write0();
	CALL        _ledstrip_write0+0, 0
;fitaledtest.c,41 :: 		}
	GOTO        L_ledstrip4
L_ledstrip3:
;fitaledtest.c,43 :: 		ledstrip_write1();
	CALL        _ledstrip_write1+0, 0
;fitaledtest.c,44 :: 		}
L_ledstrip4:
;fitaledtest.c,37 :: 		for (k=7;k>=0;k--){  // enviando bit mais significante primeiro
	DECF        ledstrip_k_L0+0, 1 
;fitaledtest.c,45 :: 		}
	GOTO        L_ledstrip0
L_ledstrip1:
;fitaledtest.c,47 :: 		for (k=7;k>=0;k--){  // enviando bit mais significante primeiro
	MOVLW       7
	MOVWF       ledstrip_k_L0+0 
L_ledstrip5:
	MOVLW       128
	XORWF       ledstrip_k_L0+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_ledstrip6
;fitaledtest.c,48 :: 		if ((red &(0x01<<k))==0){  // red and ( binario 0000 0001 desviado de k unidades para a esquerda). Se o resultado do and for zero, quer dizer que o bit de red na posição k é 0, caso contrário, ele é 1
	MOVF        ledstrip_k_L0+0, 0 
	MOVWF       R2 
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__ledstrip78:
	BZ          L__ledstrip79
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__ledstrip78
L__ledstrip79:
	MOVF        R0, 0 
	ANDWF       FARG_ledstrip_red+0, 0 
	MOVWF       R2 
	MOVLW       0
	ANDWF       R1, 0 
	MOVWF       R3 
	MOVLW       0
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ledstrip80
	MOVLW       0
	XORWF       R2, 0 
L__ledstrip80:
	BTFSS       STATUS+0, 2 
	GOTO        L_ledstrip8
;fitaledtest.c,49 :: 		ledstrip_write0();
	CALL        _ledstrip_write0+0, 0
;fitaledtest.c,50 :: 		}
	GOTO        L_ledstrip9
L_ledstrip8:
;fitaledtest.c,52 :: 		ledstrip_write1();
	CALL        _ledstrip_write1+0, 0
;fitaledtest.c,53 :: 		}
L_ledstrip9:
;fitaledtest.c,47 :: 		for (k=7;k>=0;k--){  // enviando bit mais significante primeiro
	DECF        ledstrip_k_L0+0, 1 
;fitaledtest.c,54 :: 		}
	GOTO        L_ledstrip5
L_ledstrip6:
;fitaledtest.c,56 :: 		for (k=7;k>=0;k--){   // enviando bit mais significante primeiro
	MOVLW       7
	MOVWF       ledstrip_k_L0+0 
L_ledstrip10:
	MOVLW       128
	XORWF       ledstrip_k_L0+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_ledstrip11
;fitaledtest.c,57 :: 		if ((blue &(0x01<<k))==0){   // blue and ( binario 0000 0001 desviado de k unidades para a esquerda). Se o resultado do and for zero, quer dizer que o bit de blue na posição k é 0, caso contrário, ele é 1
	MOVF        ledstrip_k_L0+0, 0 
	MOVWF       R2 
	MOVLW       1
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        R2, 0 
L__ledstrip81:
	BZ          L__ledstrip82
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__ledstrip81
L__ledstrip82:
	MOVF        R0, 0 
	ANDWF       FARG_ledstrip_blue+0, 0 
	MOVWF       R2 
	MOVLW       0
	ANDWF       R1, 0 
	MOVWF       R3 
	MOVLW       0
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__ledstrip83
	MOVLW       0
	XORWF       R2, 0 
L__ledstrip83:
	BTFSS       STATUS+0, 2 
	GOTO        L_ledstrip13
;fitaledtest.c,58 :: 		ledstrip_write0();
	CALL        _ledstrip_write0+0, 0
;fitaledtest.c,59 :: 		}
	GOTO        L_ledstrip14
L_ledstrip13:
;fitaledtest.c,61 :: 		ledstrip_write1();
	CALL        _ledstrip_write1+0, 0
;fitaledtest.c,62 :: 		}
L_ledstrip14:
;fitaledtest.c,56 :: 		for (k=7;k>=0;k--){   // enviando bit mais significante primeiro
	DECF        ledstrip_k_L0+0, 1 
;fitaledtest.c,63 :: 		}
	GOTO        L_ledstrip10
L_ledstrip11:
;fitaledtest.c,65 :: 		}
L_end_ledstrip:
	RETURN      0
; end of _ledstrip

_acende_rpm_leds:

;fitaledtest.c,67 :: 		void acende_rpm_leds(unsigned char n){ // tempo total de execução dessa função é 5.45ms
;fitaledtest.c,70 :: 		aux=3*n;  // variavel auxiliar necessária criada pois calcular 3*n dentro do for demora e portanto a fita reseta
	MOVLW       3
	MULWF       FARG_acende_rpm_leds_n+0 
	MOVF        PRODL+0, 0 
	MOVWF       acende_rpm_leds_aux_L0+0 
;fitaledtest.c,71 :: 		for(w=0;w<n;w++){ // faça ... para o numero n de leds a serem acendidos
	CLRF        acende_rpm_leds_w_L0+0 
	CLRF        acende_rpm_leds_w_L0+1 
L_acende_rpm_leds15:
	MOVLW       128
	XORWF       acende_rpm_leds_w_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__acende_rpm_leds85
	MOVF        FARG_acende_rpm_leds_n+0, 0 
	SUBWF       acende_rpm_leds_w_L0+0, 0 
L__acende_rpm_leds85:
	BTFSC       STATUS+0, 0 
	GOTO        L_acende_rpm_leds16
;fitaledtest.c,72 :: 		ledstrip(rgbrot[aux-3],rgbrot[aux-2],rgbrot[aux-1]);
	MOVLW       3
	SUBWF       acende_rpm_leds_aux_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
	MOVLW       _rgbrot+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_rgbrot+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ledstrip_red+0 
	MOVLW       2
	SUBWF       acende_rpm_leds_aux_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
	MOVLW       _rgbrot+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_rgbrot+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ledstrip_green+0 
	DECF        acende_rpm_leds_aux_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
	MOVLW       _rgbrot+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_rgbrot+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ledstrip_blue+0 
	CALL        _ledstrip+0, 0
;fitaledtest.c,71 :: 		for(w=0;w<n;w++){ // faça ... para o numero n de leds a serem acendidos
	INFSNZ      acende_rpm_leds_w_L0+0, 1 
	INCF        acende_rpm_leds_w_L0+1, 1 
;fitaledtest.c,73 :: 		}
	GOTO        L_acende_rpm_leds15
L_acende_rpm_leds16:
;fitaledtest.c,74 :: 		n=16-n;
	MOVF        FARG_acende_rpm_leds_n+0, 0 
	SUBLW       16
	MOVWF       FARG_acende_rpm_leds_n+0 
;fitaledtest.c,75 :: 		for(w=0;w<n;w++){    // escreve 0 nos leds restantes
	CLRF        acende_rpm_leds_w_L0+0 
	CLRF        acende_rpm_leds_w_L0+1 
L_acende_rpm_leds18:
	MOVLW       128
	XORWF       acende_rpm_leds_w_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__acende_rpm_leds86
	MOVF        FARG_acende_rpm_leds_n+0, 0 
	SUBWF       acende_rpm_leds_w_L0+0, 0 
L__acende_rpm_leds86:
	BTFSC       STATUS+0, 0 
	GOTO        L_acende_rpm_leds19
;fitaledtest.c,76 :: 		ledstrip(0,0,0);
	CLRF        FARG_ledstrip_red+0 
	CLRF        FARG_ledstrip_green+0 
	CLRF        FARG_ledstrip_blue+0 
	CALL        _ledstrip+0, 0
;fitaledtest.c,75 :: 		for(w=0;w<n;w++){    // escreve 0 nos leds restantes
	INFSNZ      acende_rpm_leds_w_L0+0, 1 
	INCF        acende_rpm_leds_w_L0+1, 1 
;fitaledtest.c,77 :: 		}
	GOTO        L_acende_rpm_leds18
L_acende_rpm_leds19:
;fitaledtest.c,78 :: 		}
L_end_acende_rpm_leds:
	RETURN      0
; end of _acende_rpm_leds

_animacaoInicial:

;fitaledtest.c,80 :: 		void animacaoInicial(){
;fitaledtest.c,82 :: 		for(i=0;i<147;i++){  // for para o inicio da animação, cores girando
	CLRF        _i+0 
	CLRF        _i+1 
L_animacaoInicial21:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__animacaoInicial88
	MOVLW       147
	SUBWF       _i+0, 0 
L__animacaoInicial88:
	BTFSC       STATUS+0, 0 
	GOTO        L_animacaoInicial22
;fitaledtest.c,84 :: 		lastrow[0]=matriz[45];
	MOVF        _matriz+45, 0 
	MOVWF       animacaoInicial_lastrow_L0+0 
;fitaledtest.c,85 :: 		lastrow[1]=matriz[46];
	MOVF        _matriz+46, 0 
	MOVWF       animacaoInicial_lastrow_L0+1 
;fitaledtest.c,86 :: 		lastrow[2]=matriz[47];
	MOVF        _matriz+47, 0 
	MOVWF       animacaoInicial_lastrow_L0+2 
;fitaledtest.c,88 :: 		for(j=0;j<45;j++){
	CLRF        _j+0 
	CLRF        _j+1 
L_animacaoInicial24:
	MOVLW       128
	XORWF       _j+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__animacaoInicial89
	MOVLW       45
	SUBWF       _j+0, 0 
L__animacaoInicial89:
	BTFSC       STATUS+0, 0 
	GOTO        L_animacaoInicial25
;fitaledtest.c,89 :: 		matriz[47-j]=matriz[44-j];
	MOVF        _j+0, 0 
	SUBLW       47
	MOVWF       R0 
	MOVF        _j+1, 0 
	MOVWF       R1 
	MOVLW       0
	SUBFWB      R1, 1 
	MOVLW       _matriz+0
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_matriz+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVF        _j+0, 0 
	SUBLW       44
	MOVWF       R0 
	MOVF        _j+1, 0 
	MOVWF       R1 
	MOVLW       0
	SUBFWB      R1, 1 
	MOVLW       _matriz+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_matriz+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;fitaledtest.c,88 :: 		for(j=0;j<45;j++){
	INFSNZ      _j+0, 1 
	INCF        _j+1, 1 
;fitaledtest.c,90 :: 		}
	GOTO        L_animacaoInicial24
L_animacaoInicial25:
;fitaledtest.c,91 :: 		matriz[0]=lastrow[0];
	MOVF        animacaoInicial_lastrow_L0+0, 0 
	MOVWF       _matriz+0 
;fitaledtest.c,92 :: 		matriz[1]=lastrow[1];
	MOVF        animacaoInicial_lastrow_L0+1, 0 
	MOVWF       _matriz+1 
;fitaledtest.c,93 :: 		matriz[2]=lastrow[2];
	MOVF        animacaoInicial_lastrow_L0+2, 0 
	MOVWF       _matriz+2 
;fitaledtest.c,95 :: 		for(j=0;j<48;j=j+3){
	CLRF        _j+0 
	CLRF        _j+1 
L_animacaoInicial27:
	MOVLW       128
	XORWF       _j+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__animacaoInicial90
	MOVLW       48
	SUBWF       _j+0, 0 
L__animacaoInicial90:
	BTFSC       STATUS+0, 0 
	GOTO        L_animacaoInicial28
;fitaledtest.c,96 :: 		ledstrip(matriz[j],matriz[j+1],matriz[j+2]);
	MOVLW       _matriz+0
	ADDWF       _j+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_matriz+0)
	ADDWFC      _j+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ledstrip_red+0 
	MOVLW       1
	ADDWF       _j+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _j+1, 0 
	MOVWF       R1 
	MOVLW       _matriz+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_matriz+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ledstrip_green+0 
	MOVLW       2
	ADDWF       _j+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _j+1, 0 
	MOVWF       R1 
	MOVLW       _matriz+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_matriz+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_ledstrip_blue+0 
	CALL        _ledstrip+0, 0
;fitaledtest.c,95 :: 		for(j=0;j<48;j=j+3){
	MOVLW       3
	ADDWF       _j+0, 1 
	MOVLW       0
	ADDWFC      _j+1, 1 
;fitaledtest.c,97 :: 		}
	GOTO        L_animacaoInicial27
L_animacaoInicial28:
;fitaledtest.c,98 :: 		Delay_ms(40); //CONTROLE DA VELOCIDADE DE ROTAÇÃO DA ANIMAÇÃO
	MOVLW       2
	MOVWF       R11, 0
	MOVLW       4
	MOVWF       R12, 0
	MOVLW       186
	MOVWF       R13, 0
L_animacaoInicial30:
	DECFSZ      R13, 1, 1
	BRA         L_animacaoInicial30
	DECFSZ      R12, 1, 1
	BRA         L_animacaoInicial30
	DECFSZ      R11, 1, 1
	BRA         L_animacaoInicial30
	NOP
;fitaledtest.c,82 :: 		for(i=0;i<147;i++){  // for para o inicio da animação, cores girando
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;fitaledtest.c,100 :: 		}
	GOTO        L_animacaoInicial21
L_animacaoInicial22:
;fitaledtest.c,101 :: 		for(i=1;i<17;i++){  // for para o final da animação, desligando os leds progressivamente
	MOVLW       1
	MOVWF       _i+0 
	MOVLW       0
	MOVWF       _i+1 
L_animacaoInicial31:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__animacaoInicial91
	MOVLW       17
	SUBWF       _i+0, 0 
L__animacaoInicial91:
	BTFSC       STATUS+0, 0 
	GOTO        L_animacaoInicial32
;fitaledtest.c,102 :: 		for(j=0;j<3*i;j=j+3){
	CLRF        _j+0 
	CLRF        _j+1 
L_animacaoInicial34:
	MOVLW       3
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        _i+0, 0 
	MOVWF       R4 
	MOVF        _i+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVLW       128
	XORWF       _j+1, 0 
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__animacaoInicial92
	MOVF        R0, 0 
	SUBWF       _j+0, 0 
L__animacaoInicial92:
	BTFSC       STATUS+0, 0 
	GOTO        L_animacaoInicial35
;fitaledtest.c,103 :: 		ledstrip(0,0,0);
	CLRF        FARG_ledstrip_red+0 
	CLRF        FARG_ledstrip_green+0 
	CLRF        FARG_ledstrip_blue+0 
	CALL        _ledstrip+0, 0
;fitaledtest.c,102 :: 		for(j=0;j<3*i;j=j+3){
	MOVLW       3
	ADDWF       _j+0, 1 
	MOVLW       0
	ADDWFC      _j+1, 1 
;fitaledtest.c,104 :: 		}
	GOTO        L_animacaoInicial34
L_animacaoInicial35:
;fitaledtest.c,105 :: 		Delay_ms(20); //CONTROLE DA VELOCIDADE DE ROTAÇÃO DA ANIMAÇÃO
	MOVLW       130
	MOVWF       R12, 0
	MOVLW       221
	MOVWF       R13, 0
L_animacaoInicial37:
	DECFSZ      R13, 1, 1
	BRA         L_animacaoInicial37
	DECFSZ      R12, 1, 1
	BRA         L_animacaoInicial37
	NOP
	NOP
;fitaledtest.c,101 :: 		for(i=1;i<17;i++){  // for para o final da animação, desligando os leds progressivamente
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;fitaledtest.c,106 :: 		}
	GOTO        L_animacaoInicial31
L_animacaoInicial32:
;fitaledtest.c,107 :: 		Delay_ms(350);
	MOVLW       9
	MOVWF       R11, 0
	MOVLW       225
	MOVWF       R12, 0
	MOVLW       178
	MOVWF       R13, 0
L_animacaoInicial38:
	DECFSZ      R13, 1, 1
	BRA         L_animacaoInicial38
	DECFSZ      R12, 1, 1
	BRA         L_animacaoInicial38
	DECFSZ      R11, 1, 1
	BRA         L_animacaoInicial38
	NOP
;fitaledtest.c,109 :: 		for(i=1;i<17;i++){
	MOVLW       1
	MOVWF       _i+0 
	MOVLW       0
	MOVWF       _i+1 
L_animacaoInicial39:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__animacaoInicial93
	MOVLW       17
	SUBWF       _i+0, 0 
L__animacaoInicial93:
	BTFSC       STATUS+0, 0 
	GOTO        L_animacaoInicial40
;fitaledtest.c,110 :: 		acende_rpm_leds(i);
	MOVF        _i+0, 0 
	MOVWF       FARG_acende_rpm_leds_n+0 
	CALL        _acende_rpm_leds+0, 0
;fitaledtest.c,111 :: 		Delay_ms(90);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       73
	MOVWF       R12, 0
	MOVLW       102
	MOVWF       R13, 0
L_animacaoInicial42:
	DECFSZ      R13, 1, 1
	BRA         L_animacaoInicial42
	DECFSZ      R12, 1, 1
	BRA         L_animacaoInicial42
	DECFSZ      R11, 1, 1
	BRA         L_animacaoInicial42
	NOP
;fitaledtest.c,109 :: 		for(i=1;i<17;i++){
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;fitaledtest.c,112 :: 		}
	GOTO        L_animacaoInicial39
L_animacaoInicial40:
;fitaledtest.c,113 :: 		Delay_ms(1000);
	MOVLW       26
	MOVWF       R11, 0
	MOVLW       94
	MOVWF       R12, 0
	MOVLW       110
	MOVWF       R13, 0
L_animacaoInicial43:
	DECFSZ      R13, 1, 1
	BRA         L_animacaoInicial43
	DECFSZ      R12, 1, 1
	BRA         L_animacaoInicial43
	DECFSZ      R11, 1, 1
	BRA         L_animacaoInicial43
	NOP
;fitaledtest.c,115 :: 		for(i=15;i>-1;i--){
	MOVLW       15
	MOVWF       _i+0 
	MOVLW       0
	MOVWF       _i+1 
L_animacaoInicial44:
	MOVLW       127
	MOVWF       R0 
	MOVLW       128
	XORWF       _i+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__animacaoInicial94
	MOVF        _i+0, 0 
	SUBLW       255
L__animacaoInicial94:
	BTFSC       STATUS+0, 0 
	GOTO        L_animacaoInicial45
;fitaledtest.c,116 :: 		acende_rpm_leds(i);
	MOVF        _i+0, 0 
	MOVWF       FARG_acende_rpm_leds_n+0 
	CALL        _acende_rpm_leds+0, 0
;fitaledtest.c,117 :: 		Delay_ms(90);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       73
	MOVWF       R12, 0
	MOVLW       102
	MOVWF       R13, 0
L_animacaoInicial47:
	DECFSZ      R13, 1, 1
	BRA         L_animacaoInicial47
	DECFSZ      R12, 1, 1
	BRA         L_animacaoInicial47
	DECFSZ      R11, 1, 1
	BRA         L_animacaoInicial47
	NOP
;fitaledtest.c,115 :: 		for(i=15;i>-1;i--){
	MOVLW       1
	SUBWF       _i+0, 1 
	MOVLW       0
	SUBWFB      _i+1, 1 
;fitaledtest.c,118 :: 		}
	GOTO        L_animacaoInicial44
L_animacaoInicial45:
;fitaledtest.c,120 :: 		}
L_end_animacaoInicial:
	RETURN      0
; end of _animacaoInicial

_interrupt:

;fitaledtest.c,122 :: 		void interrupt(void){
;fitaledtest.c,124 :: 		if ( INTCON.TMR0IF){ // ocorreu overflow do timer 0
	BTFSS       INTCON+0, 2 
	GOTO        L_interrupt48
;fitaledtest.c,125 :: 		elapsedTime=0;
	CLRF        _elapsedTime+0 
	CLRF        _elapsedTime+1 
;fitaledtest.c,126 :: 		T0CON.TMR0ON=0;
	BCF         T0CON+0, 7 
;fitaledtest.c,127 :: 		}
L_interrupt48:
;fitaledtest.c,128 :: 		if( INTCON.INT0IF){ // borda de subida no pino INT0
	BTFSS       INTCON+0, 1 
	GOTO        L_interrupt49
;fitaledtest.c,129 :: 		T0CON.TMR0ON=1;
	BSF         T0CON+0, 7 
;fitaledtest.c,130 :: 		elapsedTime=TMR0L;
	MOVF        TMR0L+0, 0 
	MOVWF       _elapsedTime+0 
	MOVLW       0
	MOVWF       _elapsedTime+1 
;fitaledtest.c,131 :: 		elapsedTime+=(TMR0H<<8);
	MOVF        TMR0H+0, 0 
	MOVWF       R1 
	CLRF        R0 
	MOVF        R0, 0 
	ADDWF       _elapsedTime+0, 1 
	MOVF        R1, 0 
	ADDWFC      _elapsedTime+1, 1 
;fitaledtest.c,132 :: 		}
L_interrupt49:
;fitaledtest.c,134 :: 		CLRF 0xFD7        //TMR0H=0; //reseta high byte do timer 0 //   assembly para evitar demorar na interrupção
	CLRF        4055, 1
;fitaledtest.c,135 :: 		CLRF 0xFD6        //TMR0L=0;//reseta low byte do timer 0  //   assembly para evitar demorar na interrupção
	CLRF        4054, 1
;fitaledtest.c,136 :: 		BCF  0xFF2,1      //INTCON.INT0IF=0;
	BCF         4082, 1, 1
;fitaledtest.c,137 :: 		BCF  0xFF2,2      //INTCON.TMR0IF=0;
	BCF         4082, 2, 1
;fitaledtest.c,139 :: 		}
L_end_interrupt:
L__interrupt96:
	RETFIE      1
; end of _interrupt

_main:

;fitaledtest.c,140 :: 		void main() {
;fitaledtest.c,141 :: 		ADCON1=0x0E;  // porta RA0 é analógica, todas as outras são digitais
	MOVLW       14
	MOVWF       ADCON1+0 
;fitaledtest.c,142 :: 		TRISA.RA0=1; //AN0 é input para medir luminosidade
	BSF         TRISA+0, 0 
;fitaledtest.c,143 :: 		TRISB.RB2=0; //RB0 é output
	BCF         TRISB+0, 2 
;fitaledtest.c,144 :: 		PORTB.RB2=0; //RB0 inicia em 0
	BCF         PORTB+0, 2 
;fitaledtest.c,145 :: 		TRISB.RB0=1; // Int 0 é INPUT
	BSF         TRISB+0, 0 
;fitaledtest.c,146 :: 		Delay_ms(1);  // reset da fita
	MOVLW       7
	MOVWF       R12, 0
	MOVLW       125
	MOVWF       R13, 0
L_main50:
	DECFSZ      R13, 1, 1
	BRA         L_main50
	DECFSZ      R12, 1, 1
	BRA         L_main50
;fitaledtest.c,147 :: 		for(i=1;i<17;i++) ledstrip(0,0,0); // Apaga todos os leds
	MOVLW       1
	MOVWF       _i+0 
	MOVLW       0
	MOVWF       _i+1 
L_main51:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main98
	MOVLW       17
	SUBWF       _i+0, 0 
L__main98:
	BTFSC       STATUS+0, 0 
	GOTO        L_main52
	CLRF        FARG_ledstrip_red+0 
	CLRF        FARG_ledstrip_green+0 
	CLRF        FARG_ledstrip_blue+0 
	CALL        _ledstrip+0, 0
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
	GOTO        L_main51
L_main52:
;fitaledtest.c,148 :: 		Delay_ms(1); // reset da fita
	MOVLW       7
	MOVWF       R12, 0
	MOVLW       125
	MOVWF       R13, 0
L_main54:
	DECFSZ      R13, 1, 1
	BRA         L_main54
	DECFSZ      R12, 1, 1
	BRA         L_main54
;fitaledtest.c,151 :: 		brilho=(1.0*Adc_Read(0))/1023.0;
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	CALL        _word2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       192
	MOVWF       R5 
	MOVLW       127
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _brilho+0 
	MOVF        R1, 0 
	MOVWF       _brilho+1 
	MOVF        R2, 0 
	MOVWF       _brilho+2 
	MOVF        R3, 0 
	MOVWF       _brilho+3 
;fitaledtest.c,152 :: 		for(i=0;i<48;i++){  // CONTROLE DA INTENSIDADE DE TODOS OS LEDS DO RPM
	CLRF        _i+0 
	CLRF        _i+1 
L_main55:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main99
	MOVLW       48
	SUBWF       _i+0, 0 
L__main99:
	BTFSC       STATUS+0, 0 
	GOTO        L_main56
;fitaledtest.c,153 :: 		rgbrot[i]=brilho*rgbrot_full_bright[i];
	MOVLW       _rgbrot+0
	ADDWF       _i+0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_rgbrot+0)
	ADDWFC      _i+1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       _rgbrot_full_bright+0
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       hi_addr(_rgbrot_full_bright+0)
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVFF       R0, FSR0
	MOVFF       R1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	CALL        _byte2double+0, 0
	MOVF        _brilho+0, 0 
	MOVWF       R4 
	MOVF        _brilho+1, 0 
	MOVWF       R5 
	MOVF        _brilho+2, 0 
	MOVWF       R6 
	MOVF        _brilho+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2byte+0, 0
	MOVFF       FLOC__main+0, FSR1
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;fitaledtest.c,152 :: 		for(i=0;i<48;i++){  // CONTROLE DA INTENSIDADE DE TODOS OS LEDS DO RPM
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;fitaledtest.c,154 :: 		}
	GOTO        L_main55
L_main56:
;fitaledtest.c,156 :: 		animacaoInicial(); // vai para a animação inicial, pode ser removida sem alterar o funcionamento do código principal
	CALL        _animacaoInicial+0, 0
;fitaledtest.c,159 :: 		TRISC.RC7=1;//**************************
	BSF         TRISC+0, 7 
;fitaledtest.c,160 :: 		TRISC.RC6=1;//**************************
	BSF         TRISC+0, 6 
;fitaledtest.c,161 :: 		UART1_Init(9600);//**************************
	BSF         BAUDCON+0, 3, 0
	MOVLW       2
	MOVWF       SPBRGH+0 
	MOVLW       8
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;fitaledtest.c,162 :: 		Delay_ms(100); //**************************
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_main58:
	DECFSZ      R13, 1, 1
	BRA         L_main58
	DECFSZ      R12, 1, 1
	BRA         L_main58
	DECFSZ      R11, 1, 1
	BRA         L_main58
	NOP
	NOP
;fitaledtest.c,168 :: 		INTCON=0xF0; // habilita a interrupção do pino INT0 e a interrupção pelo overflow do timer 0
	MOVLW       240
	MOVWF       INTCON+0 
;fitaledtest.c,169 :: 		INTCON2.INTEDG0=1;//Interrupção na borda de subida do pino INT0
	BSF         INTCON2+0, 6 
;fitaledtest.c,170 :: 		T0CON=0x06; //timer0 no modo de 16 bits, prescale 128  //fazer T0CON.TMR0ON=1 para disparar o timer
	MOVLW       6
	MOVWF       T0CON+0 
;fitaledtest.c,171 :: 		T0CON.TMR0ON=1; //dispara o timer0
	BSF         T0CON+0, 7 
;fitaledtest.c,175 :: 		for(;;){
L_main59:
;fitaledtest.c,177 :: 		if ( elapsedTime!=0){
	MOVLW       0
	XORWF       _elapsedTime+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main100
	MOVLW       0
	XORWF       _elapsedTime+0, 0 
L__main100:
	BTFSC       STATUS+0, 2 
	GOTO        L_main62
;fitaledtest.c,178 :: 		rpm=(1000000/(25.6*elapsedTime))*60;
	MOVF        _elapsedTime+0, 0 
	MOVWF       R0 
	MOVF        _elapsedTime+1, 0 
	MOVWF       R1 
	CALL        _word2double+0, 0
	MOVLW       205
	MOVWF       R4 
	MOVLW       204
	MOVWF       R5 
	MOVLW       76
	MOVWF       R6 
	MOVLW       131
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       36
	MOVWF       R1 
	MOVLW       116
	MOVWF       R2 
	MOVLW       146
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       112
	MOVWF       R6 
	MOVLW       132
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _rpm+0 
	MOVF        R1, 0 
	MOVWF       _rpm+1 
	MOVF        R2, 0 
	MOVWF       _rpm+2 
	MOVF        R3, 0 
	MOVWF       _rpm+3 
;fitaledtest.c,179 :: 		}
	GOTO        L_main63
L_main62:
;fitaledtest.c,180 :: 		else rpm=0;
	CLRF        _rpm+0 
	CLRF        _rpm+1 
	CLRF        _rpm+2 
	CLRF        _rpm+3 
L_main63:
;fitaledtest.c,183 :: 		brilho=(1.0*Adc_Read(0))/1023.0;
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	CALL        _word2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       192
	MOVWF       R5 
	MOVLW       127
	MOVWF       R6 
	MOVLW       136
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       _brilho+0 
	MOVF        R1, 0 
	MOVWF       _brilho+1 
	MOVF        R2, 0 
	MOVWF       _brilho+2 
	MOVF        R3, 0 
	MOVWF       _brilho+3 
;fitaledtest.c,184 :: 		for(i=0;i<48;i++){  // CONTROLE DA INTENSIDADE DE TODOS OS LEDS DO RPM
	CLRF        _i+0 
	CLRF        _i+1 
L_main64:
	MOVLW       128
	XORWF       _i+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main101
	MOVLW       48
	SUBWF       _i+0, 0 
L__main101:
	BTFSC       STATUS+0, 0 
	GOTO        L_main65
;fitaledtest.c,185 :: 		rgbrot[i]=brilho*rgbrot_full_bright[i];
	MOVLW       _rgbrot+0
	ADDWF       _i+0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_rgbrot+0)
	ADDWFC      _i+1, 0 
	MOVWF       FLOC__main+1 
	MOVLW       _rgbrot_full_bright+0
	ADDWF       _i+0, 0 
	MOVWF       R0 
	MOVLW       hi_addr(_rgbrot_full_bright+0)
	ADDWFC      _i+1, 0 
	MOVWF       R1 
	MOVFF       R0, FSR0
	MOVFF       R1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	CALL        _byte2double+0, 0
	MOVF        _brilho+0, 0 
	MOVWF       R4 
	MOVF        _brilho+1, 0 
	MOVWF       R5 
	MOVF        _brilho+2, 0 
	MOVWF       R6 
	MOVF        _brilho+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2byte+0, 0
	MOVFF       FLOC__main+0, FSR1
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;fitaledtest.c,184 :: 		for(i=0;i<48;i++){  // CONTROLE DA INTENSIDADE DE TODOS OS LEDS DO RPM
	INFSNZ      _i+0, 1 
	INCF        _i+1, 1 
;fitaledtest.c,186 :: 		}
	GOTO        L_main64
L_main65:
;fitaledtest.c,189 :: 		nleds = rpm/250;
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       122
	MOVWF       R6 
	MOVLW       134
	MOVWF       R7 
	MOVF        _rpm+0, 0 
	MOVWF       R0 
	MOVF        _rpm+1, 0 
	MOVWF       R1 
	MOVF        _rpm+2, 0 
	MOVWF       R2 
	MOVF        _rpm+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	CALL        _double2int+0, 0
	MOVF        R0, 0 
	MOVWF       _nleds+0 
	MOVF        R1, 0 
	MOVWF       _nleds+1 
;fitaledtest.c,190 :: 		if (nleds>16) nleds=16; // maximo de 4000 rpm para 16 leds, se passar disso, o numero de leds acesos é 16
	MOVLW       128
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main102
	MOVF        R0, 0 
	SUBLW       16
L__main102:
	BTFSC       STATUS+0, 0 
	GOTO        L_main67
	MOVLW       16
	MOVWF       _nleds+0 
	MOVLW       0
	MOVWF       _nleds+1 
L_main67:
;fitaledtest.c,191 :: 		if ((nleds!=nleds_anterior)||(brilho-brilho_anterior>0.1)||(brilho_anterior-brilho>0.1)) {// só atualiza a fita quando o numero de leds a serem acesos mudar em relação ao que já está aceso na fita ou então se o brilho tiver que mudar
	MOVF        _nleds+1, 0 
	XORWF       _nleds_anterior+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__main103
	MOVF        _nleds_anterior+0, 0 
	XORWF       _nleds+0, 0 
L__main103:
	BTFSS       STATUS+0, 2 
	GOTO        L__main71
	MOVF        _brilho_anterior+0, 0 
	MOVWF       R4 
	MOVF        _brilho_anterior+1, 0 
	MOVWF       R5 
	MOVF        _brilho_anterior+2, 0 
	MOVWF       R6 
	MOVF        _brilho_anterior+3, 0 
	MOVWF       R7 
	MOVF        _brilho+0, 0 
	MOVWF       R0 
	MOVF        _brilho+1, 0 
	MOVWF       R1 
	MOVF        _brilho+2, 0 
	MOVWF       R2 
	MOVF        _brilho+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVLW       205
	MOVWF       R0 
	MOVLW       204
	MOVWF       R1 
	MOVLW       76
	MOVWF       R2 
	MOVLW       123
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__main71
	MOVF        _brilho+0, 0 
	MOVWF       R4 
	MOVF        _brilho+1, 0 
	MOVWF       R5 
	MOVF        _brilho+2, 0 
	MOVWF       R6 
	MOVF        _brilho+3, 0 
	MOVWF       R7 
	MOVF        _brilho_anterior+0, 0 
	MOVWF       R0 
	MOVF        _brilho_anterior+1, 0 
	MOVWF       R1 
	MOVF        _brilho_anterior+2, 0 
	MOVWF       R2 
	MOVF        _brilho_anterior+3, 0 
	MOVWF       R3 
	CALL        _Sub_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVLW       205
	MOVWF       R0 
	MOVLW       204
	MOVWF       R1 
	MOVLW       76
	MOVWF       R2 
	MOVLW       123
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__main71
	GOTO        L_main70
L__main71:
;fitaledtest.c,192 :: 		acende_rpm_leds(nleds);// 1 led a cada 250 rpm, variando de 250 até 4000 rpm
	MOVF        _nleds+0, 0 
	MOVWF       FARG_acende_rpm_leds_n+0 
	CALL        _acende_rpm_leds+0, 0
;fitaledtest.c,193 :: 		nleds_anterior= nleds;
	MOVF        _nleds+0, 0 
	MOVWF       _nleds_anterior+0 
	MOVF        _nleds+1, 0 
	MOVWF       _nleds_anterior+1 
;fitaledtest.c,194 :: 		brilho_anterior=brilho;
	MOVF        _brilho+0, 0 
	MOVWF       _brilho_anterior+0 
	MOVF        _brilho+1, 0 
	MOVWF       _brilho_anterior+1 
	MOVF        _brilho+2, 0 
	MOVWF       _brilho_anterior+2 
	MOVF        _brilho+3, 0 
	MOVWF       _brilho_anterior+3 
;fitaledtest.c,195 :: 		}
L_main70:
;fitaledtest.c,197 :: 		}
	GOTO        L_main59
;fitaledtest.c,198 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
