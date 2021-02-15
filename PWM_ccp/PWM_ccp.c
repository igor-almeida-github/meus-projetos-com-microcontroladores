// Este programa produz um pwm de 20khz utilizando o ccp
void main() {
      // Configurações iniciais
      ADCON1=0x0F;                                                              // As referências de tensão do AD são VDD e VSS; Desabilita as portas analógicas
      TRISC.RC2=0;                                                              // CCP1 pin é OUTPUT
      // Configuração do timer 2
      T2CON=0x04;                                                               // Prescale de 1; Timer 2 on
      PR2=0xF9;                                                                 // Carrega 249 no PR2, período de 50us
      // Configuração do CCP1
      CCP1CON=0x0C;                                                             // Modo de PWM, CCP1CON<5:4> = 00
      CCPR1L=0x7D;                                                              // 50% de Duty Cycle
      for (;;){ 
          /*CCP1CON<4>=0;
          CCP1CON<5>=0;
          delay_ms(10);
          CCP1CON<4>=1;
          CCP1CON<5>=0;
          delay_ms(10);
          CCP1CON<4>=0;
          CCP1CON<5>=1;
          delay_ms(10);
          CCP1CON<4>=1;
          CCP1CON<5>=1;
          delay_ms(10);*/
          
          while(CCPR1L<0xF9){                                                                // Loop Infinito
          CCPR1L++;
          delay_ms(5);
          }
          while (CCPR1L>1) {
          CCPR1L--;
          delay_ms(5);
          }
      }
}