// Este programa aciona leds no PORTC em sequencia
void main()
{
  unsigned char j=0b00000001;    // aparentemente todas as variaveis devem ser declaradas no inicio da main ou do lado de fora, antes da main,
  // se colocar depois de alguma coisa, nao compila.
  TRISC =0; // Configure PORTB as output


  for(;;)          // Endless loop
  {
    PORTC=j;
    Delay_Ms(1000); // Wait 1 s
    j=j<<1;
    if(j==0)j=1;
  }
/*PORTC=j;
  for(;;)          // Endless loop
  {

    Delay_Ms(100);
    if (PORTC==0xFF)  PORTC=j;
    asm {
    MOVLW 0b00000011
    ADDWF PORTC
  }*/

/*// End of loop
}*/
}