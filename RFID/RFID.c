// Este programa para o pic 16f877a lê uma tag RFID e exibe em um display lcd

// LCD module connections
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

#define SS PORTD.RD0

void mssp_SPI_init(){                                                           // Função que inicializa a mssp pra trabalhar com comunicação SPI
    //*******************Informação_ importante_do_datasheet********************
    // Data on both MOSI and MISO lines must be stable on the rising edge of the
    // clock and can be changed on the falling edge. Data is provided by the 
    // MFRC522 on the falling clock edge and is stable during the rising clock
    // edge.
    // *************************************************************************
    TRISC.RC5   = 0;                                                            // SDO é OUTPUT
    TRISC.RC3   = 0;                                                            // SCK é OUTPUT
    SSPSTAT.SMP = 0;                                                            // Dados de entrada são amostrados no meio do tempo dos dados de saída
    SSPSTAT.CKE = 0;                                                            // A transmissão ocorre na transição do estado do clock ocioso para ativo
    SSPCON      = 0x32;                                                         // Habilita os pinos da SSP, clock ocioso em HIGH level, Master Mode Fosc/64
}

void SpiWrite(unsigned char SPIData){
    while(!SS);                                                                 // Aguarda enquanto a transmissão/recepção anterior não tiver terminado
    SS=0;                                                                       // Slave selecionado
    SSPBUF=SPIData;                                                             // Inicia nova transmissão/Recepção
}

void interrupt (void){
     if (PIR1.SSPIF){
        PIR1.SSPIF = 0;                                                         // Limpa a flag de interrupção da SSP
        SS         = 1;                                                         // Slave não selecionado
     }
}


void main() {
     //****************Configurações_iniciais***********************************
     Lcd_Init();                                                                // Inicializa o LCD
     TRISD.RD0  = 0;                                                            // SS é OUTPUT
     SS         = 1;                                                            // Slave não selecionado
     ADCON1     = 0x07;                                                         // Todas as portas são digitais
     mssp_SPI_init();                                                           // Inicializa a mssp para comunicação SPI
     Uart1_init(9600);                                                          // Inicializa o módulo UART com 9600 de baud rate
     //***************Configuração_das_interrupções*****************************
     INTCON     = 0xC0;                                                         // Interrupções globais habilitadas, Interrupções dos periféricos habilitadas
     PIE1.SSPIE = 1;                                                            // Habilita interrução do módulo MSSP
     //*************************************************************************
     delay_ms(2000);

     for(;;){                                                                   // Loop infinito
         while(!UART1_Data_Ready());                                            // Espera um byte chegar na UART
         SpiWrite(UART1_Read());
         while(!SS);
         UART1_Write(SSPBUF);
     }
     
}