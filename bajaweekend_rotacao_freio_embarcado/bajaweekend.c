// Envia o n�mero total de giro do motor e a quantidade de vezes que o freio foi acionado para a telemetria
// Projeto desenvolvido para a equipe UFV baja

unsigned long motor = 0;
unsigned char full, empty = 0;
unsigned char tank = 1;

void interrupt(void){
     if(INTCON.INTF){
         motor++;                                                               // Conta o n�mero de voltas do motor
         INTCON.INTF = 0;
     }
     if(PIR1.TMR1IF){                                                           // L� o estado do tanque 1 vez a cada 65.536 ms
         if (PORTB.RB3) full++;
         else empty++;
         if ( empty + full > 77){                                               // Ap�s 77 amostras (aproximadamente 5 segundos)
             if (empty > full) tank = 0;                                        // Se a maior parte das amstras indicar que est� vazio, ent�o o tanque est� vazio
             else tank = 1;                                                     // Caso contr�rio, est� cheio
             empty = 0;
             full = 0;
         }
         PIR1.TMR1IF = 0;
     }
}

void main() {
       unsigned long motor_2;
       unsigned char anterior = 0;
       unsigned int freio = 0;
       PCON.OSCF = 1;                                                           // 4 MHZ interno
       OPTION_REG.INTEDG = 0;
       INTCON = 0xD0;                                                           // Gie habilitado, Interrup��es dos perif�ricos habilitadas, INT habilitado
       PIE1 = 0x01;                                                             // Habilita interrup��o pelo overflow do timer 1
       T1CON = 0x01;                                                            // Dispara o timer 1 com prescale de 1, overflow a cada 65.536 ms
       UART1_Init(1200);
       for(;;){
           if ((PORTB.RB5 == 1) && (anterior == 0)){                            // Borda de subida do freio detectada, switch debounce
                freio++;
                anterior = 1;
                delay_ms(10);
           }
           if ((PORTB.RB5 == 0) && (anterior == 1)){                            // Borda de descida do freio detectada, switch debounce
                anterior = 0;
                delay_ms(7);
           }
           INTCON.GIE = 0;
           motor_2 = motor;                                                     // Vari�vel buffer, para n�o ocorrer mudan�a na vari�vel que conta o numero de giros durante a transmiss�o, uma vez que a vari�vel motor pode ser alterada a qualquer momento
           INTCON.GIE = 1;
           
           // Envia o n�mero total de giros do motor
           UART1_Write(*((unsigned char*)&motor_2+3));
           UART1_Write(*((unsigned char*)&motor_2+2));
           UART1_Write(*((unsigned char*)&motor_2+1));
           UART1_Write(*((unsigned char*)&motor_2));
           // Envia o n�mero de vezes que o freio foi pressionado
           UART1_Write(*((unsigned char*)&freio+1));
           UART1_Write(*((unsigned char*)&freio));
           // Envia o estado do tanque de combust�vel
           UART1_Write(tank);
           // Envia finaliza��o do pacote de dados
           UART1_Write(0x0D);
           UART1_Write(0x0A);

       }
       
}
