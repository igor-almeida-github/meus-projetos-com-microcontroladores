
// Este programa simula um dado
#define pressionado 0
#define botao PORTD.RD0
unsigned char jogardado(){
  unsigned char resultado;
  unsigned char tabela[]={0x08,0x41,0x1C,0x55,0x5D,0x77}; // Tabela para indicar o que escrever no portB
  int p;
  p=floor((rand()/5462)); // rand gera numero entre 0 e 32767

  resultado = tabela[p];
  return resultado;
}

void main()
{  
  ADCON1=0x0F;
  TRISD.RD0=1; //botao é input
  TRISB =0; // Configure PORTB as output
  srand(1); // semente do rand

  for(;;)          // Endless loop
  { 
    if (botao==pressionado){
      PORTB=jogardado();
      Delay_Ms(3000); // Wait 3 s
    }
    PORTB=0;
  
  }
}