#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/gps/gps.c"





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


void main() {

 unsigned char txt[]="$GPGLL,";
 unsigned char LAT[12],LON[13],UTC[10],ack[4],GoogleMapstext[30];
 unsigned short int i=0;


 ADCON1=0x07;
 UART1_Init(9600);
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);
 delay_ms(100);
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_out(1,1,"GPS...");
 delay_ms(2000);
 uart1_write(0x0F);
 for(;;){

 i=0;
 while(i<7){
 if(UART1_Data_Ready()){
 if (UART1_Read()==txt[i]){
 i++;
 }
 else i=0;
 }
 }

 UART1_Read_Text(LAT, ",", 255);
 while(!UART1_Data_Ready());
 LAT[10]=UART1_Read();
 while(!UART1_Data_Ready());
 UART1_Read();
 while(!UART1_Data_Ready());
 UART1_Read_Text(LON, ",", 255);
 while(!UART1_Data_Ready());
 LON[11]=UART1_Read();
 while(!UART1_Data_Ready());
 UART1_Read();
 UART1_Read_Text(UTC, ",", 255);
 UART1_Read_Text(ack, "*", 255);
 if(ack[0]=='A'&&ack[2]=='A'){
 GoogleMapstext[0]=LAT[0];
 GoogleMapstext[1]=LAT[1];
 GoogleMapstext[2]=0xB0;
 for (i=2;i<10;i++)GoogleMapstext[i+1]=LAT[i];
 GoogleMapstext[11]=0x27;
 GoogleMapstext[12]=LAT[10];
 GoogleMapstext[13]=LON[0];
 GoogleMapstext[14]=LON[1];
 GoogleMapstext[15]=LON[2];
 GoogleMapstext[16]=0xB0;
 for(i=3;i<11;i++)GoogleMapstext[i+14]=LON[i];
 GoogleMapstext[25]=0x27;
 GoogleMapstext[26]=LON[11];
 GoogleMapstext[27]=0x0D;
 GoogleMapstext[28]=0x0A;
 GoogleMapstext[29]='\0';
 UART1_Write_Text(GoogleMapstext);
 GoogleMapstext[2]=0xDF;
 GoogleMapstext[16]=0xDF;

 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_RETURN_HOME);
 for (i=0;i<13;i++) Lcd_Chr_Cp(GoogleMapstext[i]);
 Lcd_Cmd(_LCD_RETURN_HOME);
 Lcd_Cmd(_LCD_SECOND_ROW);
 for (i=13;i<27;i++) Lcd_Chr_Cp(GoogleMapstext[i]);
 }
 else {
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_out(1,1,"No Signal");
 }

 }
}
