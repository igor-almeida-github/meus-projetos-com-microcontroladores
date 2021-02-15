// Este programa para o pic 16f877a l� uma tag RFID e exibe em um display lcd

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

void mssp_SPI_init(){                                                           // Fun��o que inicializa a mssp pra trabalhar com comunica��o SPI
    //*******************Informa��o_ importante_do_datasheet********************
    // Data on both MOSI and MISO lines must be stable on the rising edge of the
    // clock and can be changed on the falling edge. Data is provided by the 
    // MFRC522 on the falling clock edge and is stable during the rising clock
    // edge.
    // *************************************************************************
    TRISC.RC5   = 0;                                                            // SDO � OUTPUT
    TRISC.RC3   = 0;                                                            // SCK � OUTPUT
    SSPSTAT.SMP = 0;                                                            // Dados de entrada s�o amostrados no meio do tempo dos dados de sa�da
    SSPSTAT.CKE = 0;                                                            // A transmiss�o ocorre na transi��o do estado do clock ocioso para ativo
    SSPCON      = 0x32;                                                         // Habilita os pinos da SSP, clock ocioso em HIGH level, Master Mode Fosc/64
}

void SpiWrite(unsigned char SPIData){
    while(!SS);                                                                 // Aguarda enquanto a transmiss�o/recep��o anterior n�o tiver terminado
    SS=0;                                                                       // Slave selecionado
    SSPBUF=SPIData;                                                             // Inicia nova transmiss�o/Recep��o
}

void interrupt (void){
     if (PIR1.SSPIF){
        PIR1.SSPIF = 0;                                                         // Limpa a flag de interrup��o da SSP
        SS         = 1;                                                         // Slave n�o selecionado
     }
}


void main() {
     //****************Configura��es_iniciais***********************************
     Lcd_Init();                                                                // Inicializa o LCD
     TRISD.RD0  = 0;                                                            // SS � OUTPUT
     SS         = 1;                                                            // Slave n�o selecionado
     ADCON1     = 0x07;                                                         // Todas as portas s�o digitais
     mssp_SPI_init();                                                           // Inicializa a mssp para comunica��o SPI
     Uart1_init(9600);                                                          // Inicializa o m�dulo UART com 9600 de baud rate
     //***************Configura��o_das_interrup��es*****************************
     INTCON     = 0xC0;                                                         // Interrup��es globais habilitadas, Interrup��es dos perif�ricos habilitadas
     PIE1.SSPIE = 1;                                                            // Habilita interru��o do m�dulo MSSP
     //*************************************************************************
     delay_ms(2000);

     for(;;){                                                                   // Loop infinito
         while(!UART1_Data_Ready());                                            // Espera um byte chegar na UART
         SpiWrite(UART1_Read());
         while(!SS);
         UART1_Write(SSPBUF);
     }
     
}