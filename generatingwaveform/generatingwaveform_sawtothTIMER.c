  // Este programa gera uma onda utilizando um conversor DAC  spi
sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;

void DAC(unsigned int value){
    char temp;

    Chip_Select=0; //ativa o chip DAC em 0
    temp = (value>>8)&0x0F;  //O conversor é de 12 bits, aqui gravamos os bits D8 a D11 que serão enviados no primeiro byte (high byte)
    temp |=0x30;  // temp | 00110000 -> SHDN =1(output power down mode);    GA=1(gain 1);    BUF=0(input unbuffered);    A/B=0(write do DACa MCP4921 supports only DACa)
    SPI1_Write(temp); // escreve o HIGH BYTE

    temp=value; // LOW byte, bits de D0 a D7 de value
    SPI1_Write(temp); // escreve o LOW byte;
    Chip_Select=1; // desativa o chip DAC em 1
}
void main() {
    float i;
    unsigned int waveValue;
    TRISC.RC5=0;
    TRISC.RC3=0;

    Chip_Select=1; // desativa o chip DAC em 1
    Chip_Select_Direction=0; //CS é output
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