
_main:

;EletronicOrgan.c,4 :: 		void main() {
;EletronicOrgan.c,6 :: 		ADCON1=0x0F;                                                                // Todas IOs são digitais
	MOVLW       15
	MOVWF       ADCON1+0 
;EletronicOrgan.c,7 :: 		Keypad_Init();                                                              // Initialize Keypad
	CALL        _Keypad_Init+0, 0
;EletronicOrgan.c,8 :: 		Sound_Init(&PORTC, 3);
	MOVLW       PORTC+0
	MOVWF       FARG_Sound_Init_snd_port+0 
	MOVLW       hi_addr(PORTC+0)
	MOVWF       FARG_Sound_Init_snd_port+1 
	MOVLW       3
	MOVWF       FARG_Sound_Init_snd_pin+0 
	CALL        _Sound_Init+0, 0
;EletronicOrgan.c,9 :: 		for(;;){                                                                    // Loop Infinito
L_main0:
;EletronicOrgan.c,10 :: 		do
L_main3:
;EletronicOrgan.c,11 :: 		key = Keypad_Key_Press();                                              // Retorna (1:16) dependendo da tecla pressionada, 0 se nenhuma estiver pressionada.
	CALL        _Keypad_Key_Press+0, 0
	MOVF        R0, 0 
	MOVWF       main_key_L0+0 
;EletronicOrgan.c,12 :: 		while(key==0);
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_main3
;EletronicOrgan.c,13 :: 		Sound_play(Notas[Index[key]],500);
	MOVLW       _Index+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_Index+0)
	MOVWF       FSR0H 
	MOVF        main_key_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        R3, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _Notas+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_Notas+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_Sound_Play_freq_in_hz+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_Sound_Play_freq_in_hz+1 
	MOVLW       244
	MOVWF       FARG_Sound_Play_duration_ms+0 
	MOVLW       1
	MOVWF       FARG_Sound_Play_duration_ms+1 
	CALL        _Sound_Play+0, 0
;EletronicOrgan.c,14 :: 		}
	GOTO        L_main0
;EletronicOrgan.c,15 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
