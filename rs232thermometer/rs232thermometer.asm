
_newline:

;rs232thermometer.c,3 :: 		void newline(){                                                                 // Nova linha no monitor serial
;rs232thermometer.c,4 :: 		UART1_Write(0x0D);
	MOVLW       13
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs232thermometer.c,5 :: 		UART1_Write(0x0A);
	MOVLW       10
	MOVWF       FARG_UART1_Write_data_+0 
	CALL        _UART1_Write+0, 0
;rs232thermometer.c,6 :: 		}
L_end_newline:
	RETURN      0
; end of _newline

_main:

;rs232thermometer.c,7 :: 		void main() {
;rs232thermometer.c,13 :: 		ADCON1=0x0E;                                                                // Porta RA0/AN0 é analógica, todo o resto é digital
	MOVLW       14
	MOVWF       ADCON1+0 
;rs232thermometer.c,14 :: 		UART1_Init(9600);                                                           // Inicializa UART em boud rate 9600
	BSF         BAUDCON+0, 3, 0
	MOVLW       2
	MOVWF       SPBRGH+0 
	MOVLW       8
	MOVWF       SPBRG+0 
	BSF         TXSTA+0, 2, 0
	CALL        _UART1_Init+0, 0
;rs232thermometer.c,16 :: 		UART_Write_Text("TERMOMETRO SERIAL");
	MOVLW       ?lstr1_rs232thermometer+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr1_rs232thermometer+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
;rs232thermometer.c,17 :: 		newline();
	CALL        _newline+0, 0
;rs232thermometer.c,18 :: 		delay_ms(500);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main0:
	DECFSZ      R13, 1, 1
	BRA         L_main0
	DECFSZ      R12, 1, 1
	BRA         L_main0
	DECFSZ      R11, 1, 1
	BRA         L_main0
	NOP
;rs232thermometer.c,19 :: 		UART_Write_Text("TEMPERATURA:");
	MOVLW       ?lstr2_rs232thermometer+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr2_rs232thermometer+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
;rs232thermometer.c,20 :: 		newline();
	CALL        _newline+0, 0
;rs232thermometer.c,21 :: 		delay_ms(500);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main1:
	DECFSZ      R13, 1, 1
	BRA         L_main1
	DECFSZ      R12, 1, 1
	BRA         L_main1
	DECFSZ      R11, 1, 1
	BRA         L_main1
	NOP
;rs232thermometer.c,22 :: 		for(;;){
L_main2:
;rs232thermometer.c,23 :: 		temp=(ADC_Read(LM35)*(5000.0/1024))/10;                                // Temperatura em C, 10mv/C.
	CLRF        FARG_ADC_Read_channel+0 
	CALL        _ADC_Read+0, 0
	CALL        _word2double+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       64
	MOVWF       R5 
	MOVLW       28
	MOVWF       R6 
	MOVLW       129
	MOVWF       R7 
	CALL        _Mul_32x32_FP+0, 0
	MOVLW       0
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVLW       32
	MOVWF       R6 
	MOVLW       130
	MOVWF       R7 
	CALL        _Div_32x32_FP+0, 0
;rs232thermometer.c,24 :: 		floatTostr(temp,txt);                                                  // Converte para string
	MOVF        R0, 0 
	MOVWF       FARG_FloatToStr_fnum+0 
	MOVF        R1, 0 
	MOVWF       FARG_FloatToStr_fnum+1 
	MOVF        R2, 0 
	MOVWF       FARG_FloatToStr_fnum+2 
	MOVF        R3, 0 
	MOVWF       FARG_FloatToStr_fnum+3 
	MOVLW       main_txt_L0+0
	MOVWF       FARG_FloatToStr_str+0 
	MOVLW       hi_addr(main_txt_L0+0)
	MOVWF       FARG_FloatToStr_str+1 
	CALL        _FloatToStr+0, 0
;rs232thermometer.c,25 :: 		pnt=strchr(txt,'.');                                                   // procura o endereço do '.' na string txt, para saber onde o ponto decimal se encontra
	MOVLW       main_txt_L0+0
	MOVWF       FARG_strchr_ptr+0 
	MOVLW       hi_addr(main_txt_L0+0)
	MOVWF       FARG_strchr_ptr+1 
	MOVLW       46
	MOVWF       FARG_strchr_chr+0 
	CALL        _strchr+0, 0
;rs232thermometer.c,26 :: 		*(pnt+3)='\0';                                                         // Insere o caracter NULL na posição de mémoria referente ao ponto mais 3, para que o valor float só seja mostrado com duas casas decimais
	MOVLW       3
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;rs232thermometer.c,27 :: 		UART_Write_Text(txt);
	MOVLW       main_txt_L0+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(main_txt_L0+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
;rs232thermometer.c,28 :: 		UART_Write_Text("C");
	MOVLW       ?lstr3_rs232thermometer+0
	MOVWF       FARG_UART_Write_Text_uart_text+0 
	MOVLW       hi_addr(?lstr3_rs232thermometer+0)
	MOVWF       FARG_UART_Write_Text_uart_text+1 
	CALL        _UART_Write_Text+0, 0
;rs232thermometer.c,29 :: 		newline();
	CALL        _newline+0, 0
;rs232thermometer.c,30 :: 		delay_ms(500);
	MOVLW       13
	MOVWF       R11, 0
	MOVLW       175
	MOVWF       R12, 0
	MOVLW       182
	MOVWF       R13, 0
L_main5:
	DECFSZ      R13, 1, 1
	BRA         L_main5
	DECFSZ      R12, 1, 1
	BRA         L_main5
	DECFSZ      R11, 1, 1
	BRA         L_main5
	NOP
;rs232thermometer.c,31 :: 		}
	GOTO        L_main2
;rs232thermometer.c,32 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
