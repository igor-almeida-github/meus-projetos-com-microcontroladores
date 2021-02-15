// Este programa aciona um display de 7 segmentos

unsigned short int display7(int x){
  unsigned short int tabela[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
  return tabela[x];
}
int i;
void main()
{  

  ADCON1=0x0F;
  TRISD =0; // Configure PORTB as output

  for(;;){    // Endless loop
      for (i=0;i<10;i++){
          PORTD = display7(i);
          Delay_ms(100);
      }

  } // End of loop


}