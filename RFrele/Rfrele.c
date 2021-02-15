
void main() {
    unsigned char receive;
    OSCCON=0x61;                                                                // HFINTOSC habilitado, frequ�ncia de clock de 4mhz
    ANSEL=0x00;                                                                 // Todas as portas s�o digitais AN0 at� AN7
    ANSELH=0x02;                                                                // AN8, AN10, AN11, AN12, AN13 s�o digitais, AN9 � anal�gica (LDR)
    TRISB=0x1F;                                                                 // SER(dados), SRCLK(clock do SR) e RCLK(clock do latch) s�o OUTPUT, o resto � input
    TRISC.RC2 = 0;                                                              // Pino de pwm para o transistor de controle do brilho dos leds
    TRISA.RA1 = 0;
    Delay_ms(100);                  // Wait for UART module to stabilize
    UART1_Init(2400);               // Initialize UART module at 9600 bps
    PORTA.RA1 = 1;
    receive = 0;
    for(;;){
         if (UART1_Data_Ready() == 1) {
         receive = UART1_Read();
         }
         if (receive == 1){
              PORTA.RA1 = !PORTA.RA1;
              if (PORTA.RA1){
                 UART1_Write_Text("Desligado");
              }
              else{
                 UART1_Write_Text("Ligado");
              }
              UART1_Write(0x0D);
              UART1_Write(0x0A);
         }
         receive = 0;
    }
}