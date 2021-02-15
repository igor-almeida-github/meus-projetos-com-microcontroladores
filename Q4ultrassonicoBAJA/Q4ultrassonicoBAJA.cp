#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/Q4ultrassonicoBAJA/Q4ultrassonicoBAJA.c"
#line 13 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/Q4ultrassonicoBAJA/Q4ultrassonicoBAJA.c"
unsigned char flags=0;
unsigned int high_level_time1;
unsigned int high_level_time2;
unsigned int high_level_time3;
unsigned int high_level_time4;







unsigned long timeroverflow=0;

unsigned long millis(){
 unsigned long time;
 INTCON.TMR0IE=0;
 time=TMR0+(timeroverflow<<8);
 INTCON.TMR0IE=1;
 time*=0.0512;
 return time;
}

void interrupt(){
 if (INTCON.RBIF){
 INTCON.RBIF=0;
 if ( PORTB.RB4 ==0 &&  flags.b0 ==1){
  flags.b0 =0;
 T1CON.TMR1ON=0;
 high_level_time1=TMR1L+(TMR1H<<8);
 T1CON.TMR1ON=1;
 }

 if ( PORTB.RB5 ==0 &&  flags.b1 ==1){
  flags.b1 =0;
 T1CON.TMR1ON=0;
 high_level_time2=TMR1L+(TMR1H<<8);
 T1CON.TMR1ON=1;
 }

 if ( PORTB.RB6 ==0 &&  flags.b2 ==1){
  flags.b2 =0;
 T1CON.TMR1ON=0;
 high_level_time3=TMR1L+(TMR1H<<8);
 T1CON.TMR1ON=1;
 }

 if ( PORTB.RB7 ==0 &&  flags.b3 ==1){
  flags.b3 =0;
 T1CON.TMR1ON=0;
 high_level_time4=TMR1L+(TMR1H<<8);
 T1CON.TMR1ON=1;
 }
 }
 else if (PIR1.TMR1IF){
 PIR1.TMR1IF=0;
 if ( flags.b0 ) high_level_time1=0;
 if ( flags.b1 ) high_level_time2=0;
 if ( flags.b2 ) high_level_time3=0;
 if ( flags.b3 ) high_level_time4=0;
 flags=0;
 }
 if(INTCON.TMR0IF){
 INTCON.TMR0IF=0;
 timeroverflow++;
 }
}

void main() {

 unsigned char txt[11];
 float Test_distance_1_Cm=0;
 float Test_distance_2_Cm=0;
 float Test_distance_3_Cm=0;
 float Test_distance_4_Cm=0;
 unsigned long ontime;


 UART1_Init(57600);
 ADCON1=0x0E;
 TRISC.RC0=0;
 TRISB.RB4=1;
 TRISC.RC1=0;
 TRISB.RB5=1;
 TRISC.RC2=0;
 TRISB.RB6=1;
 TRISC.RC3=0;
 TRISB.RB7=1;
 delay_ms(100);
  PORTC.RC0 =0;


 T1CON=0x30;
 OPTION_REG=0xC7;

 INTCON=0xE8;
 PIE1=0x01;

 for (;;){
 flags=0x00;
  PORTC.RC0 =1;
  PORTC.RC1 =1;
  PORTC.RC2 =1;
  PORTC.RC3 =1;
 Delay_us(10);
  PORTC.RC0 =0;
  PORTC.RC1 =0;
  PORTC.RC2 =0;
  PORTC.RC3 =0;
 T1CON.TMR1ON=1;
 while((! PORTB.RB4 ||! PORTB.RB5 ||! PORTB.RB6 ||! PORTB.RB7 )&&(TMR1H<200));
 T1CON.TMR1ON=0;
 TMR1H=0;
 TMR1L=1;
 T1CON.TMR1ON=1;
 flags=0x0F;
 while(flags!=0x00);
 T1CON.TMR1ON=0;
 ontime=millis();
 Test_distance_1_Cm = (high_level_time1*0.0272);
 Test_distance_2_Cm = (high_level_time2*0.0272);
 Test_distance_3_Cm = (high_level_time3*0.0272);
 Test_distance_4_Cm = (high_level_time4*0.0272);
 if (Test_distance_1_Cm>300) Test_distance_1_Cm=0;
 if (Test_distance_2_Cm>300) Test_distance_2_Cm=0;
 if (Test_distance_3_Cm>300) Test_distance_3_Cm=0;
 if (Test_distance_4_Cm>300) Test_distance_4_Cm=0;
 TMR1H=0;
 TMR1L=0;

 floatToStr(Test_distance_1_Cm,txt);
 UART1_Write_Text(txt);
 UART1_Write_Text("     ");
 floatToStr(Test_distance_2_Cm,txt);
 UART1_Write_Text(txt);
 UART1_Write_Text("     ");
 floatToStr(Test_distance_3_Cm,txt);
 UART1_Write_Text(txt);
 UART1_Write_Text("     ");
 floatToStr(Test_distance_4_Cm,txt);
 UART1_Write_Text(txt);
 UART1_Write_Text("     ");
 LongWordToStr(ontime,txt);
 UART1_Write_Text(txt);
 UART1_Write(0x0D);
 UART1_Write(0x0A);
 while( PORTB.RB4 || PORTB.RB5 || PORTB.RB6 || PORTB.RB7 );
 }
}
