
_DAC:

;generatingwaveform_sawtothTIMER.c,5 :: 		void DAC(unsigned int value){
;generatingwaveform_sawtothTIMER.c,8 :: 		Chip_Select=0; //ativa o chip DAC em 0
	BCF         RC0_bit+0, BitPos(RC0_bit+0) 
;generatingwaveform_sawtothTIMER.c,9 :: 		temp = (value>>8)&0x0F;  //O conversor é de 12 bits, aqui gravamos os bits D8 a D11 que serão enviados no primeiro byte (high byte)
	MOVF        FARG_DAC_value+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       15
	ANDWF       R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
;generatingwaveform_sawtothTIMER.c,10 :: 		temp |=0x30;  // temp | 00110000 -> SHDN =1(output power down mode);    GA=1(gain 1);    BUF=0(input unbuffered);    A/B=0(write do DACa MCP4921 supports only DACa)
	MOVLW       48
	IORWF       FARG_SPI1_Write_data_+0, 1 
;generatingwaveform_sawtothTIMER.c,11 :: 		SPI1_Write(temp); // escreve o HIGH BYTE
	CALL        _SPI1_Write+0, 0
;generatingwaveform_sawtothTIMER.c,14 :: 		SPI1_Write(temp); // escreve o LOW byte;
	MOVF        FARG_DAC_value+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;generatingwaveform_sawtothTIMER.c,15 :: 		Chip_Select=1; // desativa o chip DAC em 1
	BSF         RC0_bit+0, BitPos(RC0_bit+0) 
;generatingwaveform_sawtothTIMER.c,16 :: 		}
L_end_DAC:
	RETURN      0
; end of _DAC

_main:

;generatingwaveform_sawtothTIMER.c,17 :: 		void main() {
;generatingwaveform_sawtothTIMER.c,20 :: 		TRISC.RC5=0;
	BCF         TRISC+0, 5 
;generatingwaveform_sawtothTIMER.c,21 :: 		TRISC.RC3=0;
	BCF         TRISC+0, 3 
;generatingwaveform_sawtothTIMER.c,23 :: 		Chip_Select=1; // desativa o chip DAC em 1
	BSF         RC0_bit+0, BitPos(RC0_bit+0) 
;generatingwaveform_sawtothTIMER.c,24 :: 		Chip_Select_Direction=0; //CS é output
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;generatingwaveform_sawtothTIMER.c,25 :: 		ADCON1=0x0F;
	MOVLW       15
	MOVWF       ADCON1+0 
;generatingwaveform_sawtothTIMER.c,26 :: 		SPI1_init();
	CALL        _SPI1_Init+0, 0
;generatingwaveform_sawtothTIMER.c,27 :: 		for(;;){
L_main0:
;generatingwaveform_sawtothTIMER.c,28 :: 		for (i=0;i<=1;i+=0.1){
	CLRF        main_i_L0+0 
	CLRF        main_i_L0+1 
	CLRF        main_i_L0+2 
	CLRF        main_i_L0+3 
L_main3:
	MOVF        main_i_L0+0, 0 
	MOVWF       R4 
	MOVF        main_i_L0+1, 0 
	MOVWF       R5 
	MOVF        main_i_L0+2, 0 
	MOVWF       R6 
	MOVF        main_i_L0+3, 0 
	MOVWF       R7 
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	MOVWF       R2 
	MOVLW       127
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       0
	BTFSC       STATUS+0, 0 
	MOVLW       1
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_main4
;generatingwaveform_sawtothTIMER.c,29 :: 		waveValue=i*4095;
	MOVF        main_i_L0+0, 0 
	MOVWF       R0 
	MOVF        main_i_L0+1, 0 
	MOVWF       R1 
	MOVF        main_i_L0+2, 0 
	MOVWF       R2 
	MOVF        main_i_L0+3, 0 
	MOVWF       R3 
	MOVLW       0
	MOVWF       R4 
	MOVLW       240
	MOVWF       R5 
	MOVLW       127
	MOVWF       R6 
	MOVLW       138
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	CALL        _double2word+0, 0
;generatingwaveform_sawtothTIMER.c,30 :: 		DAC(waveValue);
	MOVF        R0, 0 
	MOVWF       FARG_DAC_value+0 
	MOVF        R1, 0 
	MOVWF       FARG_DAC_value+1 
	CALL        _DAC+0, 0
;generatingwaveform_sawtothTIMER.c,31 :: 		Delay_us(909);
	MOVLW       6
	MOVWF       R12, 0
	MOVLW       230
	MOVWF       R13, 0
L_main6:
	DECFSZ      R13, 1, 1
	BRA         L_main6
	DECFSZ      R12, 1, 1
	BRA         L_main6
;generatingwaveform_sawtothTIMER.c,28 :: 		for (i=0;i<=1;i+=0.1){
	MOVF        main_i_L0+0, 0 
	MOVWF       R0 
	MOVF        main_i_L0+1, 0 
	MOVWF       R1 
	MOVF        main_i_L0+2, 0 
	MOVWF       R2 
	MOVF        main_i_L0+3, 0 
	MOVWF       R3 
	MOVLW       205
	MOVWF       R4 
	MOVLW       204
	MOVWF       R5 
	MOVLW       76
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       main_i_L0+0 
	MOVF        R1, 0 
	MOVWF       main_i_L0+1 
	MOVF        R2, 0 
	MOVWF       main_i_L0+2 
	MOVF        R3, 0 
	MOVWF       main_i_L0+3 
;generatingwaveform_sawtothTIMER.c,32 :: 		}
	GOTO        L_main3
L_main4:
;generatingwaveform_sawtothTIMER.c,34 :: 		}
	GOTO        L_main0
;generatingwaveform_sawtothTIMER.c,36 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
