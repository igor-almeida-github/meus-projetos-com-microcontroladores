
_main:

;sound.c,2 :: 		void main() {
;sound.c,9 :: 		};
	MOVLW      6
	MOVWF      main_notes_L0+0
	MOVLW      1
	MOVWF      main_notes_L0+1
	MOVLW      6
	MOVWF      main_notes_L0+2
	MOVLW      1
	MOVWF      main_notes_L0+3
	MOVLW      38
	MOVWF      main_notes_L0+4
	MOVLW      1
	MOVWF      main_notes_L0+5
	MOVLW      6
	MOVWF      main_notes_L0+6
	MOVLW      1
	MOVWF      main_notes_L0+7
	MOVLW      93
	MOVWF      main_notes_L0+8
	MOVLW      1
	MOVWF      main_notes_L0+9
	MOVLW      74
	MOVWF      main_notes_L0+10
	MOVLW      1
	MOVWF      main_notes_L0+11
	MOVLW      6
	MOVWF      main_notes_L0+12
	MOVLW      1
	MOVWF      main_notes_L0+13
	MOVLW      6
	MOVWF      main_notes_L0+14
	MOVLW      1
	MOVWF      main_notes_L0+15
	MOVLW      38
	MOVWF      main_notes_L0+16
	MOVLW      1
	MOVWF      main_notes_L0+17
	MOVLW      6
	MOVWF      main_notes_L0+18
	MOVLW      1
	MOVWF      main_notes_L0+19
	MOVLW      136
	MOVWF      main_notes_L0+20
	MOVLW      1
	MOVWF      main_notes_L0+21
	MOVLW      93
	MOVWF      main_notes_L0+22
	MOVLW      1
	MOVWF      main_notes_L0+23
	MOVLW      6
	MOVWF      main_notes_L0+24
	MOVLW      1
	MOVWF      main_notes_L0+25
	MOVLW      6
	MOVWF      main_notes_L0+26
	MOVLW      1
	MOVWF      main_notes_L0+27
	MOVLW      12
	MOVWF      main_notes_L0+28
	MOVLW      2
	MOVWF      main_notes_L0+29
	MOVLW      184
	MOVWF      main_notes_L0+30
	MOVLW      1
	MOVWF      main_notes_L0+31
	MOVLW      93
	MOVWF      main_notes_L0+32
	MOVLW      1
	MOVWF      main_notes_L0+33
	MOVLW      74
	MOVWF      main_notes_L0+34
	MOVLW      1
	MOVWF      main_notes_L0+35
	MOVLW      38
	MOVWF      main_notes_L0+36
	MOVLW      1
	MOVWF      main_notes_L0+37
	MOVLW      210
	MOVWF      main_notes_L0+38
	MOVLW      1
	MOVWF      main_notes_L0+39
	MOVLW      210
	MOVWF      main_notes_L0+40
	MOVLW      1
	MOVWF      main_notes_L0+41
	MOVLW      184
	MOVWF      main_notes_L0+42
	MOVLW      1
	MOVWF      main_notes_L0+43
	MOVLW      93
	MOVWF      main_notes_L0+44
	MOVLW      1
	MOVWF      main_notes_L0+45
	MOVLW      136
	MOVWF      main_notes_L0+46
	MOVLW      1
	MOVWF      main_notes_L0+47
	MOVLW      93
	MOVWF      main_notes_L0+48
	MOVLW      1
	MOVWF      main_notes_L0+49
	MOVLW      1
	MOVWF      main_durations_L0+0
	MOVLW      1
	MOVWF      main_durations_L0+1
	MOVLW      2
	MOVWF      main_durations_L0+2
	MOVLW      2
	MOVWF      main_durations_L0+3
	MOVLW      2
	MOVWF      main_durations_L0+4
	MOVLW      3
	MOVWF      main_durations_L0+5
	MOVLW      1
	MOVWF      main_durations_L0+6
	MOVLW      1
	MOVWF      main_durations_L0+7
	MOVLW      2
	MOVWF      main_durations_L0+8
	MOVLW      2
	MOVWF      main_durations_L0+9
	MOVLW      2
	MOVWF      main_durations_L0+10
	MOVLW      3
	MOVWF      main_durations_L0+11
	MOVLW      1
	MOVWF      main_durations_L0+12
	MOVLW      1
	MOVWF      main_durations_L0+13
	MOVLW      2
	MOVWF      main_durations_L0+14
	MOVLW      2
	MOVWF      main_durations_L0+15
	MOVLW      2
	MOVWF      main_durations_L0+16
	MOVLW      2
	MOVWF      main_durations_L0+17
	MOVLW      2
	MOVWF      main_durations_L0+18
	MOVLW      1
	MOVWF      main_durations_L0+19
	MOVLW      1
	MOVWF      main_durations_L0+20
	MOVLW      2
	MOVWF      main_durations_L0+21
	MOVLW      2
	MOVWF      main_durations_L0+22
	MOVLW      2
	MOVWF      main_durations_L0+23
	MOVLW      3
	MOVWF      main_durations_L0+24
;sound.c,14 :: 		tamanho=sizeof(notes)/sizeof(notes[0]); // tamanho em bytes de notas dividido pelo tamanho de um elemento individual, para encontrar o número de elementos dentro de um array
	MOVLW      25
	MOVWF      main_tamanho_L0+0
;sound.c,15 :: 		ADCON1=0x0E;      //configuração de portas como digitais
	MOVLW      14
	MOVWF      ADCON1+0
;sound.c,16 :: 		Sound_init(&PORTB,4);
	MOVLW      PORTB+0
	MOVWF      FARG_Sound_Init_snd_port+0
	MOVLW      4
	MOVWF      FARG_Sound_Init_snd_pin+0
	CALL       _Sound_Init+0
;sound.c,17 :: 		for (;;){
L_main0:
;sound.c,18 :: 		for (i=0;i<tamanho;i++){
	CLRF       main_i_L0+0
L_main3:
	MOVF       main_tamanho_L0+0, 0
	SUBWF      main_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main4
;sound.c,19 :: 		Sound_play(notes[i],400*durations[i]);
	MOVF       main_i_L0+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      main_notes_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FARG_Sound_Play_freq_in_hz+0
	INCF       FSR, 1
	MOVF       INDF+0, 0
	MOVWF      FARG_Sound_Play_freq_in_hz+1
	MOVF       main_i_L0+0, 0
	ADDLW      main_durations_L0+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      R0+0
	MOVLW      0
	MOVWF      R0+1
	MOVLW      144
	MOVWF      R4+0
	MOVLW      1
	MOVWF      R4+1
	CALL       _Mul_16X16_U+0
	MOVF       R0+0, 0
	MOVWF      FARG_Sound_Play_duration_ms+0
	MOVF       R0+1, 0
	MOVWF      FARG_Sound_Play_duration_ms+1
	CALL       _Sound_Play+0
;sound.c,20 :: 		Delay_ms(100);
	MOVLW      3
	MOVWF      R11+0
	MOVLW      138
	MOVWF      R12+0
	MOVLW      85
	MOVWF      R13+0
L_main6:
	DECFSZ     R13+0, 1
	GOTO       L_main6
	DECFSZ     R12+0, 1
	GOTO       L_main6
	DECFSZ     R11+0, 1
	GOTO       L_main6
	NOP
	NOP
;sound.c,18 :: 		for (i=0;i<tamanho;i++){
	INCF       main_i_L0+0, 1
;sound.c,21 :: 		}
	GOTO       L_main3
L_main4:
;sound.c,22 :: 		Delay_ms(3000);
	MOVLW      77
	MOVWF      R11+0
	MOVLW      25
	MOVWF      R12+0
	MOVLW      79
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	DECFSZ     R12+0, 1
	GOTO       L_main7
	DECFSZ     R11+0, 1
	GOTO       L_main7
	NOP
	NOP
;sound.c,23 :: 		}
	GOTO       L_main0
;sound.c,24 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
