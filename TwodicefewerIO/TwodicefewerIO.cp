#line 1 "C:/Users/igor_/Documents/PIC/Mikroc/TwodicefewerIO/TwodicefewerIO.c"




unsigned char jogardado(){
 unsigned char resultado;
 unsigned char tabela[]={0x08,0x01,0x09,0x06,0x0E,0x07};
 int p;
 p=floor((rand()/5462));

 resultado = tabela[p];
 return resultado;
}

unsigned int L;
unsigned int H;
void main()
{
 ADCON1=0x0F;
 TRISD.RD0=1;
 TRISB =0;
 srand(1);

 for(;;)
 {
 if ( PORTD.RD0 == 0 ){
 L=jogardado();
 H=jogardado();
 PORTB=(H*16+L);
 Delay_Ms(3000);
 }
 PORTB=0;
 }
}
