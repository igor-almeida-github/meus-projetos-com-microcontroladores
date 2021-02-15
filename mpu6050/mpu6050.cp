#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/mpu6050/mpu6050.c"
#line 20 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/mpu6050/mpu6050.c"
unsigned int elapsedTime=0;
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
 elapsedTime=0;
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
 elapsedTime=TMR0L;
 elapsedTime+=(TMR0H<<8);
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


}

void main() {

 int ACCEL_XOUT,ACCEL_YOUT,ACCEL_ZOUT;
 unsigned char txt[8];
 unsigned char kmh;
 unsigned long ontime=0;
 unsigned int volantePot;
 unsigned char *pnt;
 pnt = &ontime;

 ADCON1=0x0E;
 ADC_Init();
 I2C1_Init(100000);
 UART1_Init(57600);
 TRISB.RB2=1;
 Delay_ms(400);


 I2C1_Start();
 I2C1_Wr(( 0x68 <<1)|0);
 I2C1_Wr(0x6B);
 I2C1_Wr(0x02);
 I2C1_Stop();

 I2C1_Start();
 I2C1_Wr(( 0x68 <<1)|0);
 I2C1_Wr(0x1C);
 I2C1_Wr((0)<<3);
 I2C1_Stop();






 INTCON=0xE0;
 INTCON2.INTEDG2=1;
 PIE1.TMR1IE=1;
 INTCON3.INT2IE=1;

 T0CON=0x06;
 T0CON.TMR0ON=1;
 T1CON=0xB5;
 for(;;){

 I2C1_Start();
 I2C1_Wr(( 0x68 <<1)|0);
 I2C1_Wr(0x3B);
 I2C1_Repeated_Start();
 I2C1_Wr(( 0x68 <<1)|1);

 ACCEL_XOUT=(I2C1_Rd(1)<<8)|I2C1_Rd(1);
 ACCEL_YOUT=(I2C1_Rd(1)<<8)|I2C1_Rd(1);
 ACCEL_ZOUT=(I2C1_Rd(1)<<8)|I2C1_Rd(0);
 I2C1_Stop();
 ontime=millis();

 ACCEL_XOUT-=643;
 ACCEL_YOUT+=463;
 ACCEL_ZOUT-=1764;

 if ( elapsedTime!=0){
 kmh=(59238/elapsedTime);
 }
 else kmh=0;
 volantePot=ADC_Read(0);
#line 161 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/mpu6050/mpu6050.c"
 UART1_Write(ACCEL_XOUT>>8);
 UART1_Write(ACCEL_XOUT);
 UART1_Write(ACCEL_YOUT>>8);
 UART1_Write(ACCEL_YOUT);
 UART1_Write(ACCEL_ZOUT>>8);
 UART1_Write(ACCEL_ZOUT);
 UART1_Write(kmh);
 UART1_Write(volantePot>>8);
 UART1_Write(volantePot);
 UART1_Write(*(pnt+3));
 UART1_Write(*(pnt+2));
 UART1_Write(*(pnt+1));
 UART1_Write(*pnt);
 UART1_Write(0x0D);
 UART1_Write(0x0A);
 }

}
