#line 1 "C:/Users/igor_/Documents/PIC/Mikroc/advancedlogicprobe/advancedlogicprobe.c"





bit leitura1;
bit leitura0;
void main() {

 ADCON1=0x0F;
 TRISA.RA0 = 0;
 TRISA.RA1 = 0;
 TRISB.RB4 = 0;
 TRISB.RB2 = 1;

 for (;;){
  PORTB.RB4 =1;
 Delay_ms(1);
 leitura1= PORTB.RB2 ;
  PORTB.RB4 =0;
 Delay_ms(1);
 leitura0= PORTB.RB2 ;
 if (leitura1==0 && leitura0==0){
  PORTA.RA0 =1;
  PORTA.RA1 =0;
 }
 else if (leitura1==1 && leitura0==1){
  PORTA.RA0 =0;
  PORTA.RA1 =1;
 }
 else {
  PORTA.RA0 =0;
  PORTA.RA1 =0;
 }

 }
}
