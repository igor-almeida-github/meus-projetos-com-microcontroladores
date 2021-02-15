#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/aceleracao_velocidade_rpm/aceleracao_velocidade_rpm.c"



unsigned int elapsedTimeVel=0;
unsigned int elapsedTimeRpm=0;
unsigned long timeroverflow=0;

unsigned long millis(){
 unsigned long time;
 PIE1.TMR1IE=0;
 time=TMR1L;
 time+=(TMR1H<<8);
 time+=(timeroverflow<<16);
 PIE1.TMR1IE=1;
 time*=0.0016;
 return time;
}

void interrupt(void){

 if ( INTCON.TMR0IF){
 elapsedTimeVel=0;
 T0CON.TMR0ON=0;
 asm{
 CLRF 0xFD7
 CLRF 0xFD6
 BCF 0xFF0,1
 BCF 0xFF2,2
 }
 }
 if( INTCON3.INT2IF){
 T0CON.TMR0ON=1;
 elapsedTimeVel=TMR0L;
 elapsedTimeVel+=(TMR0H<<8);
 asm{
 CLRF 0xFD7
 CLRF 0xFD6
 BCF 0xFF0,1
 BCF 0xFF2,2
 }
 }
 if(PIR1.TMR1IF){
 timeroverflow++;
 PIR1.TMR1IF=0;
 }

 if ( PIR2.TMR3IF){
 elapsedTimeRpm=0;
 T3CON.TMR3ON=0;
 INTCON3.INT1IF=0;
 TMR3H=0;
 TMR3L=0;
 PIR2.TMR3IF=0;
 }

 if(INTCON3.INT1IF){
 T3CON.TMR3ON=1;
 elapsedTimeRpm=TMR3L;
 elapsedTimeRpm+=(TMR3H<<8);
 INTCON3.INT1IF=0;
 TMR3H=0;
 TMR3L=0;
 PIR2.TMR3IF=0;
 }


}

void main() {

 int ACCEL_XOUT,ACCEL_YOUT,ACCEL_ZOUT;
 unsigned char txt[8];
 unsigned char kmh;
 unsigned long ontime=0;
 unsigned char *pnt;
 float rpm=0;
 pnt = &ontime;

 ADCON1=0x0F;
 UART1_Init(57600);
 TRISB.RB2=1;
 TRISB.RB1=1;
 Delay_ms(400);








 INTCON=0xE0;
 INTCON2.INTEDG2=1;
 INTCON.INTEDG1=1;
 PIE1.TMR1IE=1;
 INTCON3.INT2IE=1;
 INTCON3.INT1IE=1;
 PIE2.TMR3IE=1;

 T0CON=0x06;
 T0CON.TMR0ON=1;
 T1CON=0xB5;
 T3CON=0xBD;
 for(;;){


 ontime=millis();



 if ( elapsedTimeVel!=0){
 kmh=elapsedTimeVel;
 }
 else kmh=0;

 if ( elapsedTimeRpm!=0){
 rpm=(elapsedTimeRpm);
 }
 else rpm=0;


 UART1_Write(*(&rpm+1));
 UART1_Write(*(&rpm));
 UART1_Write(*(&kmh+1));
 UART1_Write(*(&kmh));
 UART1_Write(*(pnt+3));
 UART1_Write(*(pnt+2));
 UART1_Write(*(pnt+1));
 UART1_Write(*pnt);
 UART1_Write(0x0D);
 UART1_Write(0x0A);
 }

}
