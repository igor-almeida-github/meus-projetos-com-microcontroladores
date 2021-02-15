#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/RFrele/Rfrele.c"

void main() {
 unsigned char receive;
 OSCCON=0x61;
 ANSEL=0x00;
 ANSELH=0x02;
 TRISB=0x1F;
 TRISC.RC2 = 0;
 TRISA.RA1 = 0;
 Delay_ms(100);
 UART1_Init(2400);
 PORTA.RA1 = 1;
 receive = 0;
 for(;;){
 if (UART1_Data_Ready() == 1) {
 receive = UART1_Read();
 }
 if (receive == 1){
 PORTA.RA1 = !PORTA.RA1;
 if (PORTA.RA1){
 UART1_Write_Text("Desligado");
 }
 else{
 UART1_Write_Text("Ligado");
 }
 UART1_Write(0x0D);
 UART1_Write(0x0A);
 }
 receive = 0;
 }
}
