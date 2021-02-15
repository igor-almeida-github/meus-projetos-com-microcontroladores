// Código para a criação de funções de controle de uma fita led ws2812b
// Ordem dos comandos da fita: GRB do mais significante para o menos significante

//----------------------------Variáveis de escopo global------------------------
unsigned char matriz[450];
unsigned int indice_matriz = 0;

void ledstrip_write0(void){
     // escrever 0
         PORTB.RB2=1; //100ns   1 ciclo de maquina
         asm nop      // desperdiça 100ns
         asm nop      // desperdiça 100ns
         PORTB.RB2=0; //100ns

}
void ledstrip_write1(void){
     // escrever 1
         PORTB.RB2=1; //100ns   1 ciclo de maquina
         asm nop      // desperdiça 100ns
         asm nop      // desperdiça 100ns
         asm nop      // desperdiça 100ns
         asm nop      // desperdiça 100ns
         PORTB.RB2=0; //100ns

}
void ledstrip(unsigned char red, unsigned char green, unsigned char blue){
     short int k;
     
     // green
     for (k=7;k>=0;k--){  // enviando bit mais significante primeiro
         INTCON.GIE = 0;
         if ((green &(0x01<<k))==0){ // green and ( binario 0000 0001 desviado de k unidades para a esquerda). Se o resultado do and for zero, quer dizer que o bit de green na posição k é 0, caso contrário, ele é 1
            ledstrip_write0();
         }
         else{
            ledstrip_write1();
         }
         INTCON.GIE = 1;
     }
     //red
     for (k=7;k>=0;k--){  // enviando bit mais significante primeiro
         INTCON.GIE = 0;
         if ((red &(0x01<<k))==0){  // red and ( binario 0000 0001 desviado de k unidades para a esquerda). Se o resultado do and for zero, quer dizer que o bit de red na posição k é 0, caso contrário, ele é 1
            ledstrip_write0();
         }
         else{
            ledstrip_write1();
         }
         INTCON.GIE = 1;
     }
     //blue
     for (k=7;k>=0;k--){   // enviando bit mais significante primeiro
         INTCON.GIE = 0;
         if ((blue &(0x01<<k))==0){   // blue and ( binario 0000 0001 desviado de k unidades para a esquerda). Se o resultado do and for zero, quer dizer que o bit de blue na posição k é 0, caso contrário, ele é 1
            ledstrip_write0();
         }
         else{
            ledstrip_write1();
         }
         INTCON.GIE = 1;
     }

}

void interrupt(void){
    if(PIR1.RCIF){
        matriz[indice_matriz] = RCREG;
        indice_matriz++;
        TMR0L = 0;
    }
    if(INTCON.TMR0IF){
        INTCON.TMR0IF = 0;
        indice_matriz = 0;
    }
}

void main() {
     //------------------Declaração de Variáveis--------------------------------
     int i;
     int led;
     //------------------Configuração das portas--------------------------------
     ADCON1   =0x0F;                       // Todas as portas são digitais
     TRISB.RB2=0;                          // RB2 é output
     PORTB.RB2=0;                          // RB2 inicia em 0
     TRISD.RD1 = 0;                        // *************** teste
     //------------------Apagando a fita Led------------------------------------
     Delay_ms(1);                                    // reset da fita
     for(led=0; led<150; led++) ledstrip(0,0,0);     // Apaga todos os leds
     Delay_ms(1000);
     //------------------Configuração da serial---------------------------------
     UART1_Init(115200);
     
     //------------------Configuração das Interrupções--------------------------
     INTCON = 0xE0;                                                             // Interrupção global ativada; Interrupções dos periféricos ativadas; Interrupção do timer 0 ativada
     PIE1 = 0x20;                                                               // Interrupção da recepção EUSART ativada
     //------------------Configuração do timer 0--------------------------------
     T0CON = 0xC4;                                                              // Timer 0 no modo 8 bits; habilitado; prescale 32; temporizando 819.2 us
     //*************************************************************************
     
     for(;;){
        PORTD.RD1 = 1;
        while(indice_matriz != 450);
        PORTD.RD1 = 0;
        indice_matriz = 0;
        for(led=0; led<150; led++){
            ledstrip(matriz[3*led], matriz[3*led+1], matriz[3*led+2]);
        }
     }

}