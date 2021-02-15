#line 1 "C:/Users/igor_/Documents/PIC/Mikroc/generatingwaveform/generatingwaveform_sawtoth.c"
#line 51 "C:/Users/igor_/Documents/PIC/Mikroc/generatingwaveform/generatingwaveform_sawtoth.c"
sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;
float i=0;

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
 TMR0L=185;
 INTCON.TMR0IF=0;
 DAC(i*4095);
 i+=0.1;
 if (i>1.0) i=0;


}

void main() {
 TRISC.RC5=0;
 TRISC.RC3=0;

 Chip_Select=1;
 Chip_Select_Direction=0;
 ADCON1=0x0F;

 INTCON=0xA0;
 T0CON=0xC5;
 TMR0L=185;

 SPI1_init();
 for(;;){
 }

}
