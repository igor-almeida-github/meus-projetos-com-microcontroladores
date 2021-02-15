// Este programa usa uma logic probe para avaliar o estado logico de um pino digital
#define PROBE PORTA.RA0
#define RED_LED PORTB.RB0
#define GREEN_LED PORTB.RB1

void main() {

     ADCON1=0x0F;      // para fazer ra0 ser porta digital
     TRISA.RA0 = 1;    //PROBE2 é INPUT
     TRISB.RB0 = 0;    //RED_LED é OUTPUT
     TRISB.RB1 = 0;    //GREEN_LED é OUTPUT
     for (;;){
       if  (PROBE==0 ){
           RED_LED=1;
           GREEN_LED=0;
       }

       else {
           RED_LED=0;
           GREEN_LED=1;
       }
     }
}