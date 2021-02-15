// Este programa gera varias formas de onda utilizando um conversor DAC  spi de varias maneira diferentes
// diversos codigos estão ao final, nos comentarios

/*
//*******************************************************************************************
//***********************************Sawtooth************************************************
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
//*************************************************************************

*/




//*******************************************************************************************
//***********************************Sawtooth usando timer************************************************
/*
sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;
float i=0;

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
    Chip_Select=1; // desativa o chip DAC em 1
    Chip_Select_Direction=0; //CS é output
    ADCON1=0x0F;
    //  Configuração de interrupção por overflow do timer 0
    INTCON=0xA0;
    T0CON=0xC5;
    TMR0L=185;
    
    SPI1_init();
    for(;;){
    }

}
*/
//*************************************************************************


//*******************************************************************************************
//***********************************Triangle wave************************************************
/*
sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;
float i=0;
float inc=0.1;
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
void interrupt(void){
    TMR0L=185;
    INTCON.TMR0IF=0;
    DAC(i*4095);

}

void main() {
    TRISC.RC5=0;
    TRISC.RC3=0;
    Chip_Select=1; // desativa o chip DAC em 1
    Chip_Select_Direction=0; //CS é output
    ADCON1=0x0F;
    //  Configuração de interrupção por overflow do timer 0
    T0CON=0xC4;
    TMR0L=185;
    INTCON=0xA0;

    SPI1_init();
    for(;;){
    }

}
*/
//*************************************************************************


//*******************************************************************************************
//***********************************Arbitrary waveform generation************************************************
/*
sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;
float waveform[]={0,0.625,1.250,1.875,2.5,3.125,3.750,4.375,5.000,5.000,5.000,5.000,5.000,4.364,3.750,3.125,2.500,1.875,1.250,0.625};
unsigned char i=0;
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
void interrupt(void){
    TMR0L=217;
    INTCON.TMR0IF=0;
    DAC(waveform[i]*4095/5.0);
    i++;
    if(i==20) i=0;

}

void main() {
    TRISC.RC5=0;
    TRISC.RC3=0;
    Chip_Select=1; // desativa o chip DAC em 1
    Chip_Select_Direction=0; //CS é output
    ADCON1=0x0F;
    //  Configuração de interrupção por overflow do timer 0
    T0CON=0xC6;
    TMR0L=217;
    INTCON=0xA0;

    SPI1_init();
    for(;;){
    }

}
*/
//*************************************************************************


//*******************************************************************************************
//***********************************sine waveform generation************************************************

sbit Chip_Select at RC0_bit;
sbit Chip_Select_Direction at TRISC0_bit;
float sinewaveform[100];
unsigned char i=0;
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
    Chip_Select=1; // desativa o chip DAC em 1
    Chip_Select_Direction=0; //CS é output
    ADCON1=0x0F;
    // criação da função seno, antes da interrupção
    for (i=0;i<100;i++) sinewaveform[i]=2048+1638*sin(0.0628*i);
    //  Configuração de interrupção por overflow do timer 0
    T0CON=0xC1;
    TMR0L=6;
    INTCON=0xA0;
    SPI1_init();
    
    for(;;){
    }

}

//*************************************************************************