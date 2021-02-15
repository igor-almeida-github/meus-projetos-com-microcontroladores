#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/bajaweekend/bajaweekend.c"
unsigned long motor = 0;
unsigned char full, empty = 0;
unsigned char tank = 1;

void interrupt(void){
 if(INTCON.INTF){
 motor++;
 INTCON.INTF = 0;
 }
 if(PIR1.TMR1IF){
 if (PORTB.RB3) full++;
 else empty++;
 if ( empty + full > 77){
 if (empty > full) tank = 0;
 else tank = 1;
 empty = 0;
 full = 0;
 }
 PIR1.TMR1IF = 0;
 }
}

void main() {
 unsigned long motor_2;
 unsigned char anterior = 0;
 unsigned int freio = 0;
 PCON.OSCF = 1;
 OPTION_REG.INTEDG = 0;
 INTCON = 0xD0;
 PIE1 = 0x01;
 T1CON = 0x01;
 UART1_Init(1200);
 for(;;){
 if ((PORTB.RB5 == 1) && (anterior == 0)){
 freio++;
 anterior = 1;
 delay_ms(10);
 }
 if ((PORTB.RB5 == 0) && (anterior == 1)){
 anterior = 0;
 delay_ms(7);
 }
 INTCON.GIE = 0;
 motor_2 = motor;
 INTCON.GIE = 1;


 UART1_Write(*((unsigned char*)&motor_2+3));
 UART1_Write(*((unsigned char*)&motor_2+2));
 UART1_Write(*((unsigned char*)&motor_2+1));
 UART1_Write(*((unsigned char*)&motor_2));

 UART1_Write(*((unsigned char*)&freio+1));
 UART1_Write(*((unsigned char*)&freio));

 UART1_Write(tank);

 UART1_Write(0x0D);
 UART1_Write(0x0A);

 }

}
