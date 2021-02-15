#line 1 "C:/Users/igor_/Documents/PIC/Mikroc/ledchase/ledchase.c"

void main()
{
 unsigned char j=0b00000001;

 TRISC =0;


 for(;;)
 {
 PORTC=j;
 Delay_Ms(1000);
 j=j<<1;
 if(j==0)j=1;
 }
#line 29 "C:/Users/igor_/Documents/PIC/Mikroc/ledchase/ledchase.c"
}
