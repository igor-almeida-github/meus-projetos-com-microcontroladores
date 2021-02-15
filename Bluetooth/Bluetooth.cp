#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/Bluetooth/Bluetooth.c"



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


unsigned char flags=0;
unsigned char BUFFER[20];
unsigned char i=0;





void interrupt(void){
 if(PIR1.RCIF){
 PIR1.RCIF=0;
 BUFFER[i]=uart1_read();
 if (i>1){
 if (BUFFER[i-1]==0x0A&&BUFFER[i]==0x0D){
 BUFFER[i+1]='\0';
 PIE1.RCIE=0;
 }
 }
 i++;
 }
}


void Bluetooth_cmd(const unsigned char*cmdPnt, const unsigned char*stopMsgPnt){
 unsigned char k=0;
 unsigned char cmd[15],stopMsg[15];
 while (*(cmdPnt+k)!='\0'){
 cmd[k]=*(cmdPnt+k);
 k++;
 }
 cmd[k]='\0';
 k=0;
 while (*(stopMsgPnt+k)!='\0'){
 stopMsg[k]=*(stopMsgPnt+k);
 k++;
 }
 stopMsg[k]='\0';
 do{
  flags.b0 =0;
 for(k=0;k<20;k++) BUFFER[k]='\0';
 i=0;
 PIE1.RCIE=1;
 Uart1_write_text(cmd);
 Uart1_write(0x0A);
 Delay_ms(200);
 for(k=0;k<(strlen(stopMsg));k++){
 if (BUFFER[k]!=stopMsg[k])  flags.b0 =1;
 }
 }
 while( flags.b0 );
 i=0;
 for(k=0;k<20;k++) BUFFER[k]='\0';
 PIE1.RCIE=1;
}



void main() {

 unsigned char j=0;
 unsigned char txt[]="Initializing 11";

 ADCON1=0x07;
 INTCON=0xC0;
 PIE1=0x20;
 Uart1_Init(9600);
 Lcd_Init();
 Lcd_cmd(_LCD_CLEAR);
 Lcd_cmd(_LCD_CURSOR_OFF);


 Lcd_Out(1,1,txt);
 delay_ms(100);
 Bluetooth_cmd("AT+RESET","OK+RESET");
 txt[14]='0';
 Lcd_Out(1,1,txt);
 Bluetooth_cmd("AT+BAUD2","OK+Set:2");
 txt[14]='9';
 txt[13]=' ';
 Lcd_Out(1,1,txt);
 Bluetooth_cmd("AT+PARI0","OK+Set:0");
 txt[14]='8';
 Lcd_Out(1,1,txt);
 Bluetooth_cmd("AT+STOP0","OK+Set:0");
 txt[14]='7';
 Lcd_Out(1,1,txt);
 Bluetooth_cmd("AT+DELI3","OK+Set:3");
 txt[14]='6';
 Lcd_Out(1,1,txt);
 Bluetooth_cmd("AT+NOTI1","OK+Set:1");
 txt[14]='5';
 Lcd_Out(1,1,txt);
 Bluetooth_cmd("AT+MODE1","OK+Set:1");
 txt[14]='4';
 Lcd_Out(1,1,txt);
 Bluetooth_cmd("AT+ROLE0","OK+Set:0");
 txt[14]='3';
 Lcd_Out(1,1,txt);
 Bluetooth_cmd("AT+TYPE1","OK+Set:1");
 txt[14]='2';
 Lcd_Out(1,1,txt);
 Bluetooth_cmd("AT+PIN184620","OK+Set:184620");
 txt[14]='1';
 Lcd_Out(1,1,txt);
 Bluetooth_cmd("AT+RESET","OK+RESET");


 Lcd_cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Waiting for");
 Lcd_Out(2,1,"Connection");
 Bluetooth_cmd("","OK+CONN");
 Lcd_cmd(_LCD_CLEAR);

 for(;;){
 if(!PIE1.RCIE){
 Lcd_cmd(_LCD_CLEAR);
 Lcd_Out(1,1,"Mensagem:");
 Lcd_Out(2,1,BUFFER);
 i=0;
 for(j=0;j<20;j++) BUFFER[j]='\0';
 PIE1.RCIE=1;
 }
 }


}
