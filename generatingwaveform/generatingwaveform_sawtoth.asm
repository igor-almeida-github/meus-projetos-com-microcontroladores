
_DAC:

;generatingwaveform_sawtoth.c,55 :: 		void DAC(unsigned int value){
;generatingwaveform_sawtoth.c,58 :: 		Chip_Select=0; //ativa o chip DAC em 0
	BCF         RC0_bit+0, BitPos(RC0_bit+0) 
;generatingwaveform_sawtoth.c,59 :: 		temp = (value>>8)&0x0F;  //O conversor é de 12 bits, aqui gravamos os bits D8 a D11 que serão enviados no primeiro byte (high byte)
	MOVF        FARG_DAC_value+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       15
	ANDWF       R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
;generatingwaveform_sawtoth.c,60 :: 		temp |=0x30;  // temp | 00110000 -> SHDN =1(output power down mode);    GA=1(gain 1);    BUF=0(input unbuffered);    A/B=0(write do DACa MCP4921 supports only DACa)
	MOVLW       48
	IORWF       FARG_SPI1_Write_data_+0, 1 
;generatingwaveform_sawtoth.c,61 :: 		SPI1_Write(temp); // escreve o HIGH BYTE
	CALL        _SPI1_Write+0, 0
;generatingwaveform_sawtoth.c,64 :: 		SPI1_Write(temp); // escreve o LOW byte;
	MOVF        FARG_DAC_value+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;generatingwaveform_sawtoth.c,65 :: 		Chip_Select=1; // desativa o chip DAC em 1
	BSF         RC0_bit+0, BitPos(RC0_bit+0) 
;generatingwaveform_sawtoth.c,66 :: 		}
L_end_DAC:
	RETURN      0
; end of _DAC

_interrupt:

;generatingwaveform_sawtoth.c,67 :: 		void interrupt(void){
;generatingwaveform_sawtoth.c,68 :: 		TMR0L=185;
	MOVLW       185
	MOVWF       TMR0L+0 
;generatingwaveform_sawtoth.c,69 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;generatingwaveform_sawtoth.c,70 :: 		DAC(i*4095);
	MOVF        _i+0, 0 
	MOVWF       R0 
	MOVF        _i+1, 0 
	MOVWF       R1 
	MOVF        _i+2, 0 
	MOVWF       R2 
	MOVF        _i+3, 0 
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
	MOVF        R0, 0 
	MOVWF       FARG_DAC_value+0 
	MOVF        R1, 0 
	MOVWF       FARG_DAC_value+1 
	CALL        _DAC+0, 0
;generatingwaveform_sawtoth.c,71 :: 		i+=0.1;
	MOVF        _i+0, 0 
	MOVWF       R0 
	MOVF        _i+1, 0 
	MOVWF       R1 
	MOVF        _i+2, 0 
	MOVWF       R2 
	MOVF        _i+3, 0 
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
	MOVWF       _i+0 
	MOVF        R1, 0 
	MOVWF       _i+1 
	MOVF        R2, 0 
	MOVWF       _i+2 
	MOVF        R3, 0 
	MOVWF       _i+3 
;generatingwaveform_sawtoth.c,72 :: 		if (i>1.0) i=0;
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
	MOVLW       0
	MOVWF       R1 
	MOVLW       0
	MOVWF       R2 
	MOVLW       127
	MOVWF       R3 
	CALL        _Compare_Double+0, 0
	MOVLW       1
	BTFSC       STATUS+0, 0 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_interrupt0
	CLRF        _i+0 
	CLRF        _i+1 
	CLRF        _i+2 
	CLRF        _i+3 
L_interrupt0:
;generatingwaveform_sawtoth.c,75 :: 		}
L_end_interrupt:
L__interrupt6:
	RETFIE      1
; end of _interrupt

_main:

;generatingwaveform_sawtoth.c,77 :: 		void main() {
;generatingwaveform_sawtoth.c,78 :: 		TRISC.RC5=0;
	BCF         TRISC+0, 5 
;generatingwaveform_sawtoth.c,79 :: 		TRISC.RC3=0;
	BCF         TRISC+0, 3 
;generatingwaveform_sawtoth.c,81 :: 		Chip_Select=1; // desativa o chip DAC em 1
	BSF         RC0_bit+0, BitPos(RC0_bit+0) 
;generatingwaveform_sawtoth.c,82 :: 		Chip_Select_Direction=0; //CS é output
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;generatingwaveform_sawtoth.c,83 :: 		ADCON1=0x0F;
	MOVLW       15
	MOVWF       ADCON1+0 
;generatingwaveform_sawtoth.c,85 :: 		INTCON=0xA0;
	MOVLW       160
	MOVWF       INTCON+0 
;generatingwaveform_sawtoth.c,86 :: 		T0CON=0xC5;
	MOVLW       197
	MOVWF       T0CON+0 
;generatingwaveform_sawtoth.c,87 :: 		TMR0L=185;
	MOVLW       185
	MOVWF       TMR0L+0 
;generatingwaveform_sawtoth.c,89 :: 		SPI1_init();
	CALL        _SPI1_Init+0, 0
;generatingwaveform_sawtoth.c,90 :: 		for(;;){
L_main1:
;generatingwaveform_sawtoth.c,91 :: 		}
	GOTO        L_main1
;generatingwaveform_sawtoth.c,93 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
