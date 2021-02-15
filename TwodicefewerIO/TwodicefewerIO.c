
// Este programa simula dois dado
#define pressionado 0
#define botao PORTD.RD0
unsigned char jogardado(){
  unsigned char resultado;
  unsigned char tabela[]={0x08,0x01,0x09,0x06,0x0E,0x07}; // Tabela para indicar o que escrever no portB
  int p;
  p=floor((rand()/5462)); // rand gera numero entre 0 e 32767

  resultado = tabela[p];
  return resultado;
}

unsigned int L;
unsigned int H;
void main()
{
  ADCON1=0x0F;
  TRISD.RD0=1; //botao é input
  TRISB =0; // Configure PORTB as output
  srand(1); // semente do rand

  for(;;)          // Endless loop
  {
    if (botao==pressionado){
      L=jogardado();
      H=jogardado();
      PORTB=(H*16+L);
      Delay_Ms(3000); // Wait 3 s
    }
    PORTB=0;
  }
}