// Este programa para o PIC16F877A � um comunicador bluetooh, que mostra em um display lcd uma mensagem enviada (MODO SLAVE);

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

//Vari�veis_globais
unsigned char flags=0;
unsigned char BUFFER[20];
unsigned char i=0;


//Defini��es
#define WRONG_MSG flags.b0

void interrupt(void){
     if(PIR1.RCIF){                                                             // Buffer de recep��o cheio
        PIR1.RCIF=0;                                                            // Limpa a flag
        BUFFER[i]=uart1_read();                                                 // L� o caracter recebido
        if (i>1){
            if (BUFFER[i-1]==0x0A&&BUFFER[i]==0x0D){
               BUFFER[i+1]='\0';                                                // Caracter null
               PIE1.RCIE=0;                                                     // Mensagem Recebida
            }
        }
        i++;
     }
}


void Bluetooth_cmd(const unsigned char*cmdPnt, const unsigned char*stopMsgPnt){ // Envia o comando cmd para o m�dulo bluetooth at� ele transmitir a resposta esperada stopMsg, esta fun��o compara somente os caracteres de stopMsg com os do BUFFER na mesma posi��o, assim, uma string recebida que comece com os caracteres de stopMsg mas que tamb�m possua ao final outros caracteres que n�o perten�am a msg tamb�m seria reconhecida resposta v�lida (intencionalmente)
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
         Delay_ms(200);
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
    //*****************Vari�veis_locais*****************************************
    unsigned char j=0;
    unsigned char txt[]="Initializing 11";
    //*****************Configura��es_iniciais***********************************
    ADCON1=0x07;                                                                // Todas as portas s�o digitais
    INTCON=0xC0;                                                                // Interrup��es gerais e interrup��es do perif�ricos habilitadas
    PIE1=0x20;                                                                  // Interrup��o pela recep��o serial UART habilitada
    Uart1_Init(9600);                                                           // Inicializa a UART
    Lcd_Init();                                                                 // Inicializa o display LCD
    Lcd_cmd(_LCD_CLEAR);                                                        // Limpa o LCD
    Lcd_cmd(_LCD_CURSOR_OFF);                                                   // Desliga o cursor do LCD
    
    //****************Configura��es_do_m�dulo_bluetooth*************************
    Lcd_Out(1,1,txt);                                                           // Contagem regressiva que mostra o andamento das configura��es
    delay_ms(100);
    Bluetooth_cmd("AT+RESET","OK+RESET");                                       // Reseta o m�dulo
    txt[14]='0';
    Lcd_Out(1,1,txt);
    Bluetooth_cmd("AT+BAUD2","OK+Set:2");                                       // Baud rate 9600
    txt[14]='9';
    txt[13]=' ';
    Lcd_Out(1,1,txt);
    Bluetooth_cmd("AT+PARI0","OK+Set:0");                                       // Nenhum bit de paridade
    txt[14]='8';
    Lcd_Out(1,1,txt);
    Bluetooth_cmd("AT+STOP0","OK+Set:0");                                       // Um stop Bit
    txt[14]='7';
    Lcd_Out(1,1,txt);
    Bluetooth_cmd("AT+DELI3","OK+Set:3");                                       // Delimitador de campo de resposta 0x0A 0x0D
    txt[14]='6';
    Lcd_Out(1,1,txt);
    Bluetooth_cmd("AT+NOTI1","OK+Set:1");                                       // Ativa notifica��o de conex�o e desconex�o via bluetooth
    txt[14]='5';
    Lcd_Out(1,1,txt);
    Bluetooth_cmd("AT+MODE1","OK+Set:1");                                       // Modo de aquisi��o
    txt[14]='4';
    Lcd_Out(1,1,txt);
    Bluetooth_cmd("AT+ROLE0","OK+Set:0");                                       // Modo slave
    txt[14]='3';
    Lcd_Out(1,1,txt);
    Bluetooth_cmd("AT+TYPE1","OK+Set:1");                                       // Ativa o pin
    txt[14]='2';
    Lcd_Out(1,1,txt);
    Bluetooth_cmd("AT+PIN184620","OK+Set:184620");                              // Define Pin para conectar ao m�dulo bluetooth
    txt[14]='1';
    Lcd_Out(1,1,txt);
    Bluetooth_cmd("AT+RESET","OK+RESET");                                       // Reseta o m�dulo

    //Esperando conex�o do master
    Lcd_cmd(_LCD_CLEAR);
    Lcd_Out(1,1,"Waiting for");
    Lcd_Out(2,1,"Connection");
    Bluetooth_cmd("","OK+CONN");
    Lcd_cmd(_LCD_CLEAR);
    
    for(;;){
         if(!PIE1.RCIE){                                                        // Se mensagem recebida
               Lcd_cmd(_LCD_CLEAR);
               Lcd_Out(1,1,"Mensagem:");
               Lcd_Out(2,1,BUFFER);
               i=0;
               for(j=0;j<20;j++) BUFFER[j]='\0';
               PIE1.RCIE=1;                                                     //Reabilita a grava��o de mensagens no Buffer
         }
    }       


}