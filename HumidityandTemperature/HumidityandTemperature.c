// Este código para o pic16f877a mede a temperatura e a umidade e mostra em um display LCD, USA O TIMER 2
// When power is supplied to the sensor, do not send any
// instruction to the sensor in within one second in order to pass the unstable status

// Configuração de qual pino do lcd corresponde a qual porta do MCU
sbit LCD_RS at RB4_bit;
sbit LCD_EN at RB5_bit;
sbit LCD_D4 at RB0_bit;
sbit LCD_D5 at RB1_bit;
sbit LCD_D6 at RB2_bit;
sbit LCD_D7 at RB3_bit;
// Configuração de input ou output das portas  conforme lcd
sbit LCD_RS_Direction at TRISB4_bit;
sbit LCD_EN_Direction at TRISB5_bit;
sbit LCD_D7_Direction at TRISB3_bit;
sbit LCD_D6_Direction at TRISB2_bit;
sbit LCD_D5_Direction at TRISB1_bit;
sbit LCD_D4_Direction at TRISB0_bit;
// Configuração do pino do DHT
sbit DHT_pin at RD2_bit;
sbit DHT_Direction at TRISD2_bit;
// Variáveis globais
unsigned char overflow=0;
unsigned char buffer;
void interrupt(){
    PIR1.TMR2IF=0;                                                              // Limpa a flag de interrupção do timer 2
    overflow=1;                                                                 // Sinalizador de ocorrência de overflow
}

void WakeUpDHT(void){                                                           // MCU enviando sinal de start para acordar DHT
        DHT_direction=0;                                                        // Pino de dados é OUTPUT
        DHT_pin=0;                                                              // Nível baixo na linha de dados
        delay_ms(18);                                                           // Delay exigido pelo datasheet para que o DHT reconheça o sinal de start
        DHT_direction=1;                                                        // Pino de dados torna-se INPUT; resistor de pull up faz a linha retornar a HIGH
        delay_us(2);                                                            // Para dar tempo da linha se estabilizar em HIGH
}

void DHTcheck(void){                                                            // Sinal de confirmação enviado pelo sensor
        T2CON.TMR2ON=1;                                                         // Dispara o timer 2
        while(DHT_pin&&!(overflow.b0));                                         // Aguarda a resposta do sensor ou overflow do timer(se demorar de mais para receber resposta)
        T2CON.TMR2ON=0;                                                         // Interrompe contagem do timer 2
        TMR2=0;                                                                 // Reseta o timer 2
        delay_us(2);
        while(!DHT_pin&&!(overflow.b0));                                        // Aguardando inicio da transmissão
        delay_us(2);
        while(DHT_pin&&!(overflow.b0));                                         // Aguardando inicio da transmissão
        delay_us(2);
}

unsigned char ReadByteDHT(void){                                                // Transmissão pelo DHT e recepção pelo MCU iniciada
        int i;
        buffer =0;                                                              // Inicia o buffer de recepção do byte
        for (i=1;i<=8;i++){
            while(!DHT_pin&&!overflow);                                         // tempo em baixo que demarca o início do bit
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
     // Declaração de variáveis locais
     unsigned char TXT[4];
     unsigned char IntegralRH,DecimalRH,IntegralT,DecimalT;
     char*pnt;
     // Configurações iniciais
     ADCON1=0x06;                                                               // Todas as portas são digitais
     DHT_Direction=1;                                                           // Pino do DHT é input
     
     // inicializando display lcd
     Lcd_Init();                                                                // LCD é conectado ao PORTB
     Lcd_Cmd(_LCD_CLEAR);                                                       // Limpa o lcd
     Lcd_Cmd(_LCD_CURSOR_OFF);
     
     // Configurando o timer 2
     T2CON=1;                                                                   // Timer 2 prescale 4; postscale 1; desligado T2CON.TMR2ON(liga o timer); 204.8us para overflow, incremento a cada 0.8us
     PR2=0xFF;                                                                  // Periodo para overflow de 256 contagens do timer 2
     
     // Configuração de interrupções
     INTCON=0xC0;                                                               // Habilita as interrupções globais e as interrupções dos periféricos
     PIE1.TMR2IE=1;                                                             // Habilita a interrupção pelo overflow do timer 2
     
     // Delay exigido pelo datasheet DHT
     delay_ms(2000);                                                            // Delay de 1s exigido pelo datasheet
     for(;;){
        WakeUpDHT();                                                            // MCU enviando sinal de start para acordar DHT
        DHTcheck();                                                             // Verifica sinal de confirmação enviado pelo sensor
        if (!overflow){
            IntegralRH=ReadByteDHT();                                           // Lê a parte integral da umidade
            DecimalRH=ReadByteDHT();                                            // Lê a parte decimal da umidade
            IntegralT=ReadByteDHT();                                            // Lê a parte integral da temperatura
            DecimalT=ReadByteDHT();                                             // Lê a parte decimal da temperatura
            if (!overflow){;
                // Printa a linha da umidade
                Lcd_Out(1,1,"HMTY=    ");
                Lcd_Out(2,1,"TEMP=    ");
                
                ByteTostr(IntegralRH,TXT);
                pnt=ltrim(TXT);                                                 // Remove os espaços a esqueda
                Lcd_Out(1,6,pnt);
                Lcd_Out(1,8,".");
                ByteTostr(DecimalRH,TXT);
                pnt=ltrim(TXT);                                                 // Remove os espaços a esqueda
                Lcd_Out(1,9,pnt);
                Lcd_Out(1,10,"%");

                // Printa a linha da temperatura
                ByteTostr(IntegralT,TXT);
                pnt=ltrim(TXT);                                                 // Remove os espaços a esqueda
                Lcd_Out(2,6,pnt);
                Lcd_Out(2,8,".");
                ByteTostr(DecimalT,TXT);
                pnt=ltrim(TXT);                                                 // Remove os espaços a esqueda
                Lcd_Out(2,9,pnt);
                TXT[0]=0b11011111;                                              // Símbolo º
                TXT[1]='C';
                TXT[2]=' ';
                Lcd_Out(2,10,TXT);
            }
        }
        if (overflow){                                                          // Se ocorreu overflow do timer, resposta do sensor interrompida ou não recebida
        Lcd_Cmd(_LCD_CLEAR);                                                    // Limpa o display LCD
        Lcd_Out(1,1,"ERRO");

        }
        overflow=0;                                                             // Reseta variável que indica que ocorreu overflow para realizar uma nova tentativa de comunicação
        delay_ms(1500);                                                         // Delay necessário para o sensor coletar uma nova amostra

     }

}