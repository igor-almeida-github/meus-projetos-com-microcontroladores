#line 1 "C:/Users/igor_/Documents/PIC/Mikroc/ledcflash/ledflash.c"


void main()
{

 TRISB =0;

for(;;)
 {


 PORTB.RB0 = 0;
 Delay_Ms(20);
 PORTB.RB0 = 1;
 Delay_Ms(20);
 }


}
