#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/LEDvolt/LEDvolt.c"










void main() {

 unsigned long mV;
 TRISB=0xE0;
 ADCON1=0x0E;
 TRISA.RA0=1;
 ADCON2=0x80;




 UART1_Init(4800);
 Delay_ms(100);
 for (;;){

 mV= Adc_Read(0);
 mV=(mV*4760)>>10;


 if (mV>0)  PORTB.RB0 =1; else  PORTB.RB0 =0;
 if (mV>=1000)  PORTB.RB1 =1 ; else  PORTB.RB1 =0;
 if (mV>=2000)  PORTB.RB2 =1; else  PORTB.RB2 =0;
 if (mV>=3000)  PORTB.RB3 =1; else  PORTB.RB3 =0;
 if (mV>=4000)  PORTB.RB4 =1; else  PORTB.RB4 =0;
 Delay_ms(10);

 }
}
