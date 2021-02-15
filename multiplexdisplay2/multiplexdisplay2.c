// Este programa aciona dois display de 7 segmentos multiplexados

void display7(int x,int disp){
  unsigned short int tabela[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F}; // tabela dos valores correspondentes aos numeros 1 a 9, na ordem
  PORTE.RE0=0; //  display MSD
  PORTE.RE1=0;  //  display LSD
  PORTD =  tabela[x];
  if (disp==2) PORTE.RE0=1;
  if (disp==1) PORTE.RE1=1;

}

void main()
{ 
int i;
unsigned short int  MSD;
unsigned short int  LSD;
unsigned short int  cnt=28;

  ADCON1=0x0F;
  TRISD =0; // Configure PORTB as output
  TRISE.RE0=0;
  TRISE.RE1=0;

  for(;;){    // Endless loop
    LSD=cnt%10;
    MSD=cnt/10;
    display7(LSD,1);
    Delay_ms(10);
    display7(MSD,2);
    Delay_ms(10);

  } // End of loop


}