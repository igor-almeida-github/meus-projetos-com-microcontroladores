#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/PWM_ccp/PWM_ccp.c"
void main() {

 ADCON1=0x0F;
 TRISC.RC2=0;

 T2CON=0x04;
 PR2=0xF9;

 CCP1CON=0x0C;
 CCPR1L=0x7D;
 for (;;){
#line 25 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/PWM_ccp/PWM_ccp.c"
 while(CCPR1L<0xF9){
 CCPR1L++;
 delay_ms(5);
 }
 while (CCPR1L>1) {
 CCPR1L--;
 delay_ms(5);
 }
 }
}
