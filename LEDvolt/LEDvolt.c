  //CUIDADO, SE MULTIPLICAR DUAS VARIAVEIS INTEIRAS O RESULTADO É SEMPRE UM INTEIRO DE 16 BITS, PORTANTO DEPENDENDO DO VALOR PODE DAR OVERFLOW
 // este programa implementa um voltimetro led
 #define LED01V PORTB.RB0
 #define LED12V PORTB.RB1
 #define LED23V PORTB.RB2
 #define LED34V PORTB.RB3
 #define LED45V PORTB.RB4
 


void main() { 
     //char txt[32];
     unsigned long mV;
     TRISB=0xE0;        // Os 5 primeiros bits do PORTB são OUTPUT, os demais são input
     ADCON1=0x0E;       // Todas as portas são dgitais exceto AN0(RA0)
     TRISA.RA0=1;       // A porta do AN0 é input
     ADCON2=0x80;     // Resultado justificado a direita
     //RCSTA<7>=1;  //**************************
     //TRISC.RC7=1;//**************************
     //TRISC.RC6=1;//**************************

     UART1_Init(4800);//**************************
     Delay_ms(100); //**************************
     for (;;){

        mV= Adc_Read(0); // multiplicado por 5000mv e dividido por 1024: deslocado 10 bits para a direita, o que é o mesmo que dividir por 1024
        mV=(mV*4760)>>10; // CUIDADO, SE MULTIPLICAR DUAS VARIAVEIS INTEIRAS O RESULTADO É SEMPRE UM INTEIRO DE 16 BITS, PORTANTO DEPENDENDO DO VALOR PODE DAR OVERFLOW
        //LongToStr(mV,txt);
        //UART1_Write_Text(txt);  //**************************
        if (mV>0) LED01V=1; else LED01V=0;
        if (mV>=1000) LED12V=1 ; else LED12V=0;
        if (mV>=2000) LED23V=1;  else LED23V=0;
        if (mV>=3000) LED34V=1;  else LED34V=0;
        if (mV>=4000) LED45V=1; else LED45V=0;
        Delay_ms(10);

     }
}