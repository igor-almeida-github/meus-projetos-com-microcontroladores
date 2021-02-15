
_DAC:

;generatingwaveform.c,198 :: 		void DAC(unsigned int value){
;generatingwaveform.c,200 :: 		Chip_Select=0; //ativa o chip DAC em 0
	BCF         RC0_bit+0, BitPos(RC0_bit+0) 
;generatingwaveform.c,201 :: 		temp = (value>>8)&0x0F;  //O conversor é de 12 bits, aqui gravamos os bits D8 a D11 que serão enviados no primeiro byte (high byte)
	MOVF        FARG_DAC_value+1, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       15
	ANDWF       R0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
;generatingwaveform.c,202 :: 		temp |=0x30;  // temp | 00110000 -> SHDN =1(output power down mode);    GA=1(gain 1);    BUF=0(input unbuffered);    A/B=0(write do DACa MCP4921 supports only DACa)
	MOVLW       48
	IORWF       FARG_SPI1_Write_data_+0, 1 
;generatingwaveform.c,203 :: 		SPI1_Write(temp); // escreve o HIGH BYTE
	CALL        _SPI1_Write+0, 0
;generatingwaveform.c,206 :: 		SPI1_Write(temp); // escreve o LOW byte;
	MOVF        FARG_DAC_value+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;generatingwaveform.c,207 :: 		Chip_Select=1; // desativa o chip DAC em 1
	BSF         RC0_bit+0, BitPos(RC0_bit+0) 
;generatingwaveform.c,208 :: 		}
L_end_DAC:
	RETURN      0
; end of _DAC

_interrupt:

;generatingwaveform.c,209 :: 		void interrupt(void){
;generatingwaveform.c,210 :: 		TMR0L=6;
	MOVLW       6
	MOVWF       TMR0L+0 
;generatingwaveform.c,211 :: 		INTCON.TMR0IF=0;
	BCF         INTCON+0, 2 
;generatingwaveform.c,212 :: 		DAC(sinewaveform[i]);
	MOVF        _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _sinewaveform+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_sinewaveform+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	CALL        _double2word+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_DAC_value+0 
	MOVF        R1, 0 
	MOVWF       FARG_DAC_value+1 
	CALL        _DAC+0, 0
;generatingwaveform.c,213 :: 		i++;
	INCF        _i+0, 1 
;generatingwaveform.c,214 :: 		if(i==100) i=0;
	MOVF        _i+0, 0 
	XORLW       100
	BTFSS       STATUS+0, 2 
	GOTO        L_interrupt0
	CLRF        _i+0 
L_interrupt0:
;generatingwaveform.c,216 :: 		}
L_end_interrupt:
L__interrupt9:
	RETFIE      1
; end of _interrupt

_main:

;generatingwaveform.c,218 :: 		void main() {
;generatingwaveform.c,219 :: 		TRISC.RC5=0;
	BCF         TRISC+0, 5 
;generatingwaveform.c,220 :: 		TRISC.RC3=0;
	BCF         TRISC+0, 3 
;generatingwaveform.c,221 :: 		Chip_Select=1; // desativa o chip DAC em 1
	BSF         RC0_bit+0, BitPos(RC0_bit+0) 
;generatingwaveform.c,222 :: 		Chip_Select_Direction=0; //CS é output
	BCF         TRISC0_bit+0, BitPos(TRISC0_bit+0) 
;generatingwaveform.c,223 :: 		ADCON1=0x0F;
	MOVLW       15
	MOVWF       ADCON1+0 
;generatingwaveform.c,225 :: 		for (i=0;i<100;i++) sinewaveform[i]=2048+1638*sin(0.0628*i);
	CLRF        _i+0 
L_main1:
	MOVLW       100
	SUBWF       _i+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_main2
	MOVF        _i+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	MOVLW       _sinewaveform+0
	ADDWF       R0, 0 
	MOVWF       FLOC__main+0 
	MOVLW       hi_addr(_sinewaveform+0)
	ADDWFC      R1, 0 
	MOVWF       FLOC__main+1 
	MOVF        _i+0, 0 
	MOVWF       R0 
	CALL        _byte2double+0, 0
	MOVLW       73
	MOVWF       R4 
	MOVLW       157
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       123
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_sin_f+0 
	MOVF        R1, 0 
	MOVWF       FARG_sin_f+1 
	MOVF        R2, 0 
	MOVWF       FARG_sin_f+2 
	MOVF        R3, 0 
	MOVWF       FARG_sin_f+3 
	CALL        _sin+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       192
	MOVWF       R5 
	MOVLW       76
	MOVWF       R6 
	MOVLW       137
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       0
	MOVWF       R6 
	MOVLW       138
	MOVWF       R7 
	CALL        _Add_32x32_FP+0, 0
	MOVFF       FLOC__main+0, FSR1
	MOVFF       FLOC__main+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVF        R2, 0 
	MOVWF       POSTINC1+0 
	MOVF        R3, 0 
	MOVWF       POSTINC1+0 
	INCF        _i+0, 1 
	GOTO        L_main1
L_main2:
;generatingwaveform.c,227 :: 		T0CON=0xC1;
	MOVLW       193
	MOVWF       T0CON+0 
;generatingwaveform.c,228 :: 		TMR0L=6;
	MOVLW       6
	MOVWF       TMR0L+0 
;generatingwaveform.c,229 :: 		INTCON=0xA0;
	MOVLW       160
	MOVWF       INTCON+0 
;generatingwaveform.c,230 :: 		SPI1_init();
	CALL        _SPI1_Init+0, 0
;generatingwaveform.c,232 :: 		for(;;){
L_main4:
;generatingwaveform.c,233 :: 		}
	GOTO        L_main4
;generatingwaveform.c,235 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
