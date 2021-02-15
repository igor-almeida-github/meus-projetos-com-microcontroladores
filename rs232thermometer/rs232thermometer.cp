#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/rs232thermometer/rs232thermometer.c"


void newline(){
 UART1_Write(0x0D);
 UART1_Write(0x0A);
}
void main() {

 float temp;
 unsigned char txt[8];
 char*pnt;

 ADCON1=0x0E;
 UART1_Init(9600);

 UART_Write_Text("TERMOMETRO SERIAL");
 newline();
 delay_ms(500);
 UART_Write_Text("TEMPERATURA:");
 newline();
 delay_ms(500);
 for(;;){
 temp=(ADC_Read( 0 )*(5000.0/1024))/10;
 floatTostr(temp,txt);
 pnt=strchr(txt,'.');
 *(pnt+3)='\0';
 UART_Write_Text(txt);
 UART_Write_Text("C");
 newline();
 delay_ms(500);
 }
}
