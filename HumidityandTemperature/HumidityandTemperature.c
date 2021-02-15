// Este c�digo para o pic16f877a mede a temperatura e a umidade e mostra em um display LCD, USA O TIMER 2
// When power is supplied to the sensor, do not send any
// instruction to the sensor in within one second in order to pass the unstable status

// Configura��o de qual pino do lcd corresponde a qual porta do MCU
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;
// Configura��o de input ou output das portas  conforme lcd
sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D7_Direction at TRISB3_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D4_Direction at TRISB0_bit;
// Configura��o do pino do DHT
sbit DHT_pin at RD2_bit;
sbit DHT_Direction at TRISD2_bit;
// Vari�veis globais
unsigned char overflow=0;
unsigned char buffer;
void interrupt(){
    PIR1.TMR2IF=0;                                                              // Limpa a flag de interrup��o do timer 2
    overflow=1;                                                                 // Sinalizador de ocorr�ncia de overflow
}

void WakeUpDHT(void){                                                           // MCU enviando sinal de start para acordar DHT
        DHT_direction=0;                                                        // Pino de dados � OUTPUT
        DHT_pin=0;                                                              // N�vel baixo na linha de dados
        delay_ms(18);                                                           // Delay exigido pelo datasheet para que o DHT reconhe�a o sinal de start
        DHT_direction=1;                                                        // Pino de dados torna-se INPUT; resistor de pull up faz a linha retornar a HIGH
        delay_us(2);                                                            // Para dar tempo da linha se estabilizar em HIGH
}

void DHTcheck(void){                                                            // Sinal de confirma��o enviado pelo sensor
        T2CON.TMR2ON=1;                                                         // Dispara o timer 2
        while(DHT_pin&&!(overflow.b0));                                         // Aguarda a resposta do sensor ou overflow do timer(se demorar de mais para receber resposta)
        T2CON.TMR2ON=0;                                                         // Interrompe contagem do timer 2
        TMR2=0;                                                                 // Reseta o timer 2
        delay_us(2);
        while(!DHT_pin&&!(overflow.b0));                                        // Aguardando inicio da transmiss�o
        delay_us(2);
        while(DHT_pin&&!(overflow.b0));                                         // Aguardando inicio da transmiss�o
        delay_us(2);
}

unsigned char ReadByteDHT(void){                                                // Transmiss�o pelo DHT e recep��o pelo MCU iniciada
        int i;
        buffer =0;                                                              // Inicia o buffer de recep��o do byte
        for (i=1;i<=8;i++){
            while(!DHT_pin&&!overflow);                                         // tempo em baixo que demarca o in�cio do bit
            T2CON.TMR2ON=1;                                                     // Dispara o timer 2
            while(DHT_pin&&!overflow);                                          // Conta o tempo em alto
            T2CON.TMR2ON=0;                                                     // Interrompe contagem do timer 2
            buffer=buffer<<1;                                                   // Move os bits para a esquerda
            if (TMR2> 61){                                                      // maior que 48.8us
               buffer|=0x01;                                                    // Bit 1 recebido
            }
            TMR2=0;                                                             // Reseta o timer 0;
            if (overflow) break;
        }
        return buffer;
}


void main() {
     // Declara��o de vari�veis locais
     unsigned char TXT[4];
     unsigned char IntegralRH,DecimalRH,IntegralT,DecimalT;
     char*pnt;
     // Configura��es iniciais
     ADCON1=0x06;                                                               // Todas as portas s�o digitais
     DHT_Direction=1;                                                           // Pino do DHT � input
     
     // inicializando display lcd
     Lcd_Init();                                                                // LCD � conectado ao PORTB
     Lcd_Cmd(_LCD_CLEAR);                                                       // Limpa o lcd
     Lcd_Cmd(_LCD_CURSOR_OFF);
     
     // Configurando o timer 2
     T2CON=1;                                                                   // Timer 2 prescale 4; postscale 1; desligado T2CON.TMR2ON(liga o timer); 204.8us para overflow, incremento a cada 0.8us
     PR2=0xFF;                                                                  // Periodo para overflow de 256 contagens do timer 2
     
     // Configura��o de interrup��es
     INTCON=0xC0;                                                               // Habilita as interrup��es globais e as interrup��es dos perif�ricos
     PIE1.TMR2IE=1;                                                             // Habilita a interrup��o pelo overflow do timer 2
     
     // Delay exigido pelo datasheet DHT
     delay_ms(2000);                                                            // Delay de 1s exigido pelo datasheet
     for(;;){
        WakeUpDHT();                                                            // MCU enviando sinal de start para acordar DHT
        DHTcheck();                                                             // Verifica sinal de confirma��o enviado pelo sensor
        if (!overflow){
            IntegralRH=ReadByteDHT();                                           // L� a parte integral da umidade
            DecimalRH=ReadByteDHT();                                            // L� a parte decimal da umidade
            IntegralT=ReadByteDHT();                                            // L� a parte integral da temperatura
            DecimalT=ReadByteDHT();                                             // L� a parte decimal da temperatura
            if (!overflow){;
                // Printa a linha da umidade
                Lcd_Out(1,1,"HMTY=    ");
                Lcd_Out(2,1,"TEMP=    ");
                
                ByteTostr(IntegralRH,TXT);
                pnt=ltrim(TXT);                                                 // Remove os espa�os a esqueda
                Lcd_Out(1,6,pnt);
                Lcd_Out(1,8,".");
                ByteTostr(DecimalRH,TXT);
                pnt=ltrim(TXT);                                                 // Remove os espa�os a esqueda
                Lcd_Out(1,9,pnt);
                Lcd_Out(1,10,"%");

                // Printa a linha da temperatura
                ByteTostr(IntegralT,TXT);
                pnt=ltrim(TXT);                                                 // Remove os espa�os a esqueda
                Lcd_Out(2,6,pnt);
                Lcd_Out(2,8,".");
                ByteTostr(DecimalT,TXT);
                pnt=ltrim(TXT);                                                 // Remove os espa�os a esqueda
                Lcd_Out(2,9,pnt);
                TXT[0]=0b11011111;                                              // S�mbolo �
                TXT[1]='C';
                TXT[2]=' ';
                Lcd_Out(2,10,TXT);
            }
        }
        if (overflow){                                                          // Se ocorreu overflow do timer, resposta do sensor interrompida ou n�o recebida
        Lcd_Cmd(_LCD_CLEAR);                                                    // Limpa o display LCD
        Lcd_Out(1,1,"ERRO");

        }
        overflow=0;                                                             // Reseta vari�vel que indica que ocorreu overflow para realizar uma nova tentativa de comunica��o
        delay_ms(1500);                                                         // Delay necess�rio para o sensor coletar uma nova amostra

     }

}