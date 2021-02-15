// Este programa para o PIC16F877A é um comunicador bluetooh, que se conecta e envia uma mensagem para um dispositivo slave (MODO MASTER)

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

//Variáveis_globais
unsigned char flags=0;
unsigned char BUFFER[20];
unsigned char i=0;


//Definições
#define WRONG_MSG flags.b0

void interrupt(void){
     if(PIR1.RCIF){                                                             // Buffer de recepção cheio
        PIR1.RCIF=0;                                                            // Limpa a flag
        BUFFER[i]=uart1_read();                                                 // Lê o caracter recebido
        if (i>1){
            if (BUFFER[i-1]==0x0A&&BUFFER[i]==0x0D){
               BUFFER[i+1]='\0';                                                // Caracter null
               PIE1.RCIE=0;                                                     // Mensagem Recebida
            }
        }
        i++;
     }
}


void Bluetooth_cmd(const unsigned char*cmdPnt, const unsigned char*stopMsgPnt){ // Envia o comando cmd para o módulo bluetooth até ele transmitir a resposta esperada stopMsg, esta função compara somente os caracteres de stopMsg com os do BUFFER na mesma posição, assim, uma string recebida que comece com os caracteres de stopMsg mas que também possua ao final outros caracteres que não pertençam a msg também seria reconhecida resposta válida (intencionalmente)
     unsigned char k=0;
     unsigned char cmd[15],stopMsg[15];
     while (*(cmdPnt+k)!='\0'){
        cmd[k]=*(cmdPnt+k);
        k++;
     }
     cmd[k]='\0';
     k=0;
     while (*(stopMsgPnt+k)!='\0'){
        stopMsg[k]=*(stopMsgPnt+k);
        k++;
     }
     stopMsg[k]='\0';
     do{
         WRONG_MSG=0;
         for(k=0;k<20;k++) BUFFER[k]='\0';
         i=0;
         PIE1.RCIE=1;
         Uart1_write_text(cmd);
         Uart1_write(0x0A);
         Delay_ms(500);
         for(k=0;k<(strlen(stopMsg));k++){
             if (BUFFER[k]!=stopMsg[k]) WRONG_MSG=1;
         }
     }
     while(WRONG_MSG);
     i=0;
     for(k=0;k<20;k++) BUFFER[k]='\0';
     PIE1.RCIE=1;
}



void main() {
    //*****************Variáveis_locais*****************************************
    unsigned char j=0;
    unsigned char txt[]="Initializing";
    //*****************Configurações_iniciais***********************************
    ADCON1=0x07;                                                                // Todas as portas são digitais
    INTCON=0xC0;                                                                // Interrupções gerais e interrupções do periféricos habilitadas
    PIE1=0x20;                                                                  // Interrupção pela recepção serial UART habilitada
    Uart1_Init(9600);                                                           // Inicializa a UART
    Lcd_Init();                                                                 // Inicializa o display LCD
    Lcd_cmd(_LCD_CLEAR);                                                        // Limpa o LCD
    Lcd_cmd(_LCD_CURSOR_OFF);                                                   // Desliga o cursor do LCD

    //****************Configurações_do_módulo_bluetooth*************************
    Lcd_Out(1,1,txt);                                                           // Contagem regressiva que mostra o andamento das configurações
    delay_ms(100);
    Bluetooth_cmd("AT+ROLE1","OK+Set:1");                                       // Modo Master
    Bluetooth_cmd("AT+RESET","OK+RESET");                                       // Reseta o módulo
    delay_ms(2000);
    Bluetooth_cmd("AT+DROP","");                                                // Derruba possível conecção
    Bluetooth_cmd("AT+SAVE0","OK+Set:0");                                       // Não tenta reconectar ao ultimo dispositivo conectado
    Bluetooth_cmd("AT+BAUD2","OK+Set:2");                                       // Baud rate 9600
    Bluetooth_cmd("AT+PARI0","OK+Set:0");                                       // Nenhum bit de paridade
    Bluetooth_cmd("AT+STOP0","OK+Set:0");                                       // Um stop Bit
    Bluetooth_cmd("AT+DELI3","OK+Set:3");                                       // Delimitador de campo de resposta 0x0A 0x0D
    Bluetooth_cmd("AT+NOTI1","OK+Set:1");                                       // Ativa notificação de conexão e desconexão via bluetooth
    Bluetooth_cmd("AT+MODE1","OK+Set:1");                                       // Modo de aquisição
    Bluetooth_cmd("AT+ROLE1","OK+Set:1");                                       // Modo Master
    Bluetooth_cmd("AT+TYPE1","OK+Set:1");                                       // Ativa o pin
    Bluetooth_cmd("AT+PIN184620","OK+Set:184620");                              // Define Pin para conectar ao módulo bluetooth
    Bluetooth_cmd("AT+IMME1","OK+Set:1");                                       // Quando o módulo é alimentado começa a funcionar imediatamente
    Bluetooth_cmd("AT+ALLO0","OK+Set:0");                                       // Lista de endereços permitidos (whitelist) desativada
    Bluetooth_cmd("AT+SCAN9","OK+Set:9");                                       // A busca ficara ativa por 9s
    Bluetooth_cmd("AT+SHOW0","OK+Set:0");                                       // Não mostrar informação adicional do discovey
    Bluetooth_cmd("AT+RESET","OK+RESET");                                       // Reseta o módulo
    Lcd_cmd(_LCD_CLEAR);
    Lcd_Out(1,1,"Searching...");
    Bluetooth_cmd("AT+DISC?","OK+DISCS");                                       // Executa o discovery
    delay_ms(9000);
    Bluetooth_cmd("","OK+DISCE");
    //Esperando conexão do master
    Lcd_cmd(_LCD_CLEAR);
    Lcd_Out(1,1,"Waiting for");
    Lcd_Out(2,1,"Connection");
    Bluetooth_cmd("AT+CONN0","OK+CONN");
    Lcd_cmd(_LCD_CLEAR);

    for(;;){
           uart1_write_text("Hello world");
           uart1_write(0x0D);
           uart1_write(0x0A);
           Lcd_Out(1,1,"Hello world");
           delay_ms(1000);
           Lcd_cmd(_LCD_CLEAR);

    }


}