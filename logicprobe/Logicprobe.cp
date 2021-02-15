#line 1 "C:/Users/igor_/Documents/PIC/Mikroc/logicprobe/Logicprobe.c"




void main() {

 ADCON1=0x0F;
 TRISA.RA0 = 1;
 TRISB.RB0 = 0;
 TRISB.RB1 = 0;
 for (;;){
 if ( PORTA.RA0 ==0 ){
  PORTB.RB0 =1;
  PORTB.RB1 =0;
 }

 else {
  PORTB.RB0 =0;
  PORTB.RB1 =1;
 }
 }
}
