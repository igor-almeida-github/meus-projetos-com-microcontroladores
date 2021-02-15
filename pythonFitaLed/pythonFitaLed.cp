#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/pythonFitaLed/pythonFitaLed.c"




unsigned char matriz[450];
unsigned int indice_matriz = 0;

void ledstrip_write0(void){

 PORTB.RB2=1;
 asm nop
 asm nop
 PORTB.RB2=0;

}
void ledstrip_write1(void){

 PORTB.RB2=1;
 asm nop
 asm nop
 asm nop
 asm nop
 PORTB.RB2=0;

}
void ledstrip(unsigned char red, unsigned char green, unsigned char blue){
 short int k;


 for (k=7;k>=0;k--){
 INTCON.GIE = 0;
 if ((green &(0x01<<k))==0){
 ledstrip_write0();
 }
 else{
 ledstrip_write1();
 }
 INTCON.GIE = 1;
 }

 for (k=7;k>=0;k--){
 INTCON.GIE = 0;
 if ((red &(0x01<<k))==0){
 ledstrip_write0();
 }
 else{
 ledstrip_write1();
 }
 INTCON.GIE = 1;
 }

 for (k=7;k>=0;k--){
 INTCON.GIE = 0;
 if ((blue &(0x01<<k))==0){
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

 int i;
 int led;

 ADCON1 =0x0F;
 TRISB.RB2=0;
 PORTB.RB2=0;
 TRISD.RD1 = 0;

 Delay_ms(1);
 for(led=0; led<150; led++) ledstrip(0,0,0);
 Delay_ms(1000);

 UART1_Init(115200);


 INTCON = 0xE0;
 PIE1 = 0x20;

 T0CON = 0xC4;


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
