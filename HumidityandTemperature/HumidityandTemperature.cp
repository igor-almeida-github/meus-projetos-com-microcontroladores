#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/HumidityandTemperature/HumidityandTemperature.c"





sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D7_Direction at TRISB3_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D4_Direction at TRISB0_bit;

sbit DHT_pin at RD2_bit;
sbit DHT_Direction at TRISD2_bit;

unsigned char overflow=0;
unsigned char buffer;
void interrupt(){
 PIR1.TMR2IF=0;
 overflow=1;
}

void WakeUpDHT(void){
 DHT_direction=0;
 DHT_pin=0;
 delay_ms(18);
 DHT_direction=1;
 delay_us(2);
}

void DHTcheck(void){
 T2CON.TMR2ON=1;
 while(DHT_pin&&!(overflow.b0));
 T2CON.TMR2ON=0;
 TMR2=0;
 delay_us(2);
 while(!DHT_pin&&!(overflow.b0));
 delay_us(2);
 while(DHT_pin&&!(overflow.b0));
 delay_us(2);
}

unsigned char ReadByteDHT(void){
 int i;
 buffer =0;
 for (i=1;i<=8;i++){
 while(!DHT_pin&&!overflow);
 T2CON.TMR2ON=1;
 while(DHT_pin&&!overflow);
 T2CON.TMR2ON=0;
 buffer=buffer<<1;
 if (TMR2> 61){
 buffer|=0x01;
 }
 TMR2=0;
 if (overflow) break;
 }
 return buffer;
}


void main() {

 unsigned char TXT[4];
 unsigned char IntegralRH,DecimalRH,IntegralT,DecimalT;
 char*pnt;

 ADCON1=0x06;
 DHT_Direction=1;


 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);


 T2CON=1;
 PR2=0xFF;


 INTCON=0xC0;
 PIE1.TMR2IE=1;


 delay_ms(2000);
 for(;;){
 WakeUpDHT();
 DHTcheck();
 if (!overflow){
 IntegralRH=ReadByteDHT();
 DecimalRH=ReadByteDHT();
 IntegralT=ReadByteDHT();
 DecimalT=ReadByteDHT();
 if (!overflow){;

 Lcd_Out(1,1,"HMTY=    ");
 Lcd_Out(2,1,"TEMP=    ");

 ByteTostr(IntegralRH,TXT);
 pnt=ltrim(TXT);
 Lcd_Out(1,6,pnt);
 Lcd_Out(1,8,".");
 ByteTostr(DecimalRH,TXT);
 pnt=ltrim(TXT);
 Lcd_Out(1,9,pnt);
 Lcd_Out(1,10,"%");


 ByteTostr(IntegralT,TXT);
 pnt=ltrim(TXT);
 Lcd_Out(2,6,pnt);
 Lcd_Out(2,8,".");
 ByteTostr(DecimalT,TXT);
 pnt=ltrim(TXT);
 Lcd_Out(2,9,pnt);
 TXT[0]=0b11011111;
 TXT[1]='C';
 TXT[2]=' ';
 Lcd_Out(2,10,TXT);
 }
 }
 if (overflow){
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"ERRO");

 }
 overflow=0;
 delay_ms(1500);

 }

}
