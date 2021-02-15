// Este programa para o pic16f877a adquire as coordenadas a partir de um modulo gps e as exibe em um display lcd
// Coordenadas validas recebidas: $GPGLL,2045.42830,S,04252.63039,W,215440.00,A,A*60
// Coordenadas inválidas recebidas $GPGLL,,,,,,V,N*64
// Forma aceita no google maps: 20º45.42830'S042º52.63039'W
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


void main() {
    //*****************Declaração_de_variáveis_locais***************************
    unsigned char txt[]="$GPGLL,";
    unsigned char LAT[12],LON[13],UTC[10],ack[4],GoogleMapstext[30];
    unsigned short int i=0;

    //*****************Configurações_iniciais***********************************
    ADCON1=0x07;                                                                // Todas as portas são digitais
    UART1_Init(9600);                                                           // Inicia a comunicação serial com 9600 de baud rate
    Lcd_Init();                                                                 // LCD inicializa o lcd conectado ao PORTB
    Lcd_Cmd(_LCD_CLEAR);                                                        // Limpa o lcd
    Lcd_Cmd(_LCD_CURSOR_OFF);                                                   // Deliga o cursor
    delay_ms(100);                                                              // Espera módulo UART se estabilizar
    Lcd_Cmd(_LCD_CLEAR);
    Lcd_out(1,1,"GPS...");
    delay_ms(2000);
    uart1_write(0x0F);
    for(;;){                                                                    // Loop infinito
        //**********************Procurando_GPGLL********************************
        i=0;
        while(i<7){                                                             // Enquanto a mensagem $GPGLL não for recebida por completo
            if(UART1_Data_Ready()){                                             // Se houver dados disponíveis para a leitura na uart
                if (UART1_Read()==txt[i]){                                      // Se um caracter recebido for igual a sequência "$GPGLL"
                    i++;                                                        // Incrementa para testar novo caracter da sequência
                }
                else i=0;                                                       // Se um caracter recebido for diferente da sequência de caracteres na string "$GPGLL", inicia-se novamente a busca desde o '$'
            }
        }
        //**********************Gravando_as_coordenadas*************************
        UART1_Read_Text(LAT, ",", 255);                                         // Latitude
        while(!UART1_Data_Ready());
        LAT[10]=UART1_Read();                                                   // N ou S
        while(!UART1_Data_Ready());
        UART1_Read();                                                           // ,
        while(!UART1_Data_Ready());
        UART1_Read_Text(LON, ",", 255);                                         // Longitude
        while(!UART1_Data_Ready());
        LON[11]=UART1_Read();                                                   // E ou W
        while(!UART1_Data_Ready());
        UART1_Read();                                                           // ,
        UART1_Read_Text(UTC, ",", 255);                                         // Coordinated Universal Time
        UART1_Read_Text(ack, "*", 255);                                         // Para verificar se os dados são válidos
        if(ack[0]=='A'&&ack[2]=='A'){                                           // Se as coordenadas são válidas
              GoogleMapstext[0]=LAT[0];
              GoogleMapstext[1]=LAT[1];
              GoogleMapstext[2]=0xB0;                                           // Símbolo de graus º
              for (i=2;i<10;i++)GoogleMapstext[i+1]=LAT[i];
              GoogleMapstext[11]=0x27;                                          // Símbolo de minutos '
              GoogleMapstext[12]=LAT[10];
              GoogleMapstext[13]=LON[0];
              GoogleMapstext[14]=LON[1];
              GoogleMapstext[15]=LON[2];
              GoogleMapstext[16]=0xB0;                                          // Símbolo de graus º
              for(i=3;i<11;i++)GoogleMapstext[i+14]=LON[i];
              GoogleMapstext[25]=0x27;                                          // Símbolo de minutos '
              GoogleMapstext[26]=LON[11];
              GoogleMapstext[27]=0x0D;                                          // CR
              GoogleMapstext[28]=0x0A;                                          // LF
              GoogleMapstext[29]='\0';
              UART1_Write_Text(GoogleMapstext);
              GoogleMapstext[2]=0xDF;
              GoogleMapstext[16]=0xDF;
              // printar no display
              Lcd_Cmd(_LCD_CLEAR);
              Lcd_Cmd(_LCD_RETURN_HOME);
              for (i=0;i<13;i++) Lcd_Chr_Cp(GoogleMapstext[i]);
              Lcd_Cmd(_LCD_RETURN_HOME);
              Lcd_Cmd(_LCD_SECOND_ROW);
              for (i=13;i<27;i++) Lcd_Chr_Cp(GoogleMapstext[i]);
        }
        else {
            Lcd_Cmd(_LCD_CLEAR);
            Lcd_out(1,1,"No Signal");
        }

     }
}


// for debug

/*uart1_write_text(LAT);
        uart1_write(0x0D);
        uart1_write(0x0A);
        uart1_write_text(LON);
        uart1_write(0x0D);
        uart1_write(0x0A);
        uart1_write_text(UTC);
        uart1_write(0x0D);
        uart1_write(0x0A);
        uart1_write_text(ack);                                                          // Se as coordenadas não são válidas
        uart1_write(0x0D);
        uart1_write(0x0A);*/