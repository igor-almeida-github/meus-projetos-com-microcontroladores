#line 1 "C:/Users/igor_/Documents/PIC/Mikroc/generatingwaveform/generatingwaveform_sawtothTIMER.c"

sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;

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
void main() {
 float i;
 unsigned int waveValue;
 TRISC.RC5=0;
 TRISC.RC3=0;

 Chip_Select=1;
 Chip_Select_Direction=0;
 ADCON1=0x0F;
 SPI1_init();
 for(;;){
 for (i=0;i<=1;i+=0.1){
 waveValue=i*4095;
 DAC(waveValue);
 Delay_us(909);
 }

 }

}
