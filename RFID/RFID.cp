#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/RFID/RFID.c"



sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;

sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D4_Direction at TRISB0_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D7_Direction at TRISB3_bit;



void mssp_SPI_init(){






 TRISC.RC5 = 0;
 TRISC.RC3 = 0;
 SSPSTAT.SMP = 0;
 SSPSTAT.CKE = 0;
 SSPCON = 0x32;
}

void SpiWrite(unsigned char SPIData){
 while(! PORTD.RD0 );
  PORTD.RD0 =0;
 SSPBUF=SPIData;
}

void interrupt (void){
 if (PIR1.SSPIF){
 PIR1.SSPIF = 0;
  PORTD.RD0  = 1;
 }
}


void main() {

 Lcd_Init();
 TRISD.RD0 = 0;
  PORTD.RD0  = 1;
 ADCON1 = 0x07;
 mssp_SPI_init();
 Uart1_init(9600);

 INTCON = 0xC0;
 PIE1.SSPIE = 1;

 delay_ms(2000);

 for(;;){
 while(!UART1_Data_Ready());
 SpiWrite(UART1_Read());
 while(! PORTD.RD0 );
 UART1_Write(SSPBUF);
 }

}
