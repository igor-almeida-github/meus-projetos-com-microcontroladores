#line 1 "C:/Users/igor_/Documents/PIC/Mikroc/Leddice/Leddice.c"




unsigned char jogardado(){
 unsigned char resultado;
 unsigned char tabela[]={0x08,0x41,0x1C,0x55,0x5D,0x77};
 int p;
 p=floor((rand()/5462));

 resultado = tabela[p];
 return resultado;
}

void main()
{
 ADCON1=0x0F;
 TRISD.RD0=1;
 TRISB =0;
 srand(1);

 for(;;)
 {
 if ( PORTD.RD0 == 0 ){
 PORTB=jogardado();
 Delay_Ms(3000);
 }
 PORTB=0;

 }
}
