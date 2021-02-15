#line 1 "C:/Users/igor_/Documents/PIC/Mikroc/generatingwaveform/generatingwaveform.c"
#line 194 "C:/Users/igor_/Documents/PIC/Mikroc/generatingwaveform/generatingwaveform.c"
sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;
float sinewaveform[100];
unsigned char i=0;
void DAC(unsigned int value){
 char temp;
 Chip_Select=0;
 temp = (value>>8)&0x0F;
 temp |=0x30;
 SPI1_Write(temp);

 temp=value;
 SPI1_Write(temp);
 Chip_Select=1;
}
void interrupt(void){
 TMR0L=6;
 INTCON.TMR0IF=0;
 DAC(sinewaveform[i]);
 i++;
 if(i==100) i=0;

}

void main() {
 TRISC.RC5=0;
 TRISC.RC3=0;
 Chip_Select=1;
 Chip_Select_Direction=0;
 ADCON1=0x0F;

 for (i=0;i<100;i++) sinewaveform[i]=2048+1638*sin(0.0628*i);

 T0CON=0xC1;
 TMR0L=6;
 INTCON=0xA0;
 SPI1_init();

 for(;;){
 }

}
