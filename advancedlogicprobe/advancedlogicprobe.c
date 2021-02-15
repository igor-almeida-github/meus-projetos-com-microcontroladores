// Este programa usa uma logic probe para avaliar o estado lógico de um pino digital e também detecta quando ele está em alta impedância
#define PROBEOUT PORTB.RB4
#define PROBEIN  PORTB.RB2
#define RED_LED PORTA.RA0
#define GREEN_LED PORTA.RA1
bit leitura1;
bit leitura0;
void main() {

     ADCON1=0x0F;      //para fazer que todas as portas sejam digitais
     TRISA.RA0 = 0;    //RED_LED é output
     TRISA.RA1 = 0;    //GREEN_LED é OUTPUT
     TRISB.RB4 = 0;    //PROBEOUT é OUTPUT
     TRISB.RB2 = 1;    //PROBEIN é INPUT

     for (;;){
       PROBEOUT=1;
       Delay_ms(1); // Para esperar o transistor chavear
       leitura1=PROBEIN;
       PROBEOUT=0;
       Delay_ms(1); // Para esperar o transistor chavear
       leitura0=PROBEIN;
       if  (leitura1==0 && leitura0==0){ // ponta de prova em nivel baixo
           RED_LED=1;
           GREEN_LED=0;
       }
       else if  (leitura1==1 && leitura0==1){ // ponta de prova em nivel alto
           RED_LED=0;
           GREEN_LED=1;
       }
       else {
           RED_LED=0;
           GREEN_LED=0;
       }

     }
}
