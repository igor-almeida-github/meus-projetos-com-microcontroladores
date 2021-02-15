// Este programa mostra um numero aleatorio no portC
#include <stdlib.h>
void main()
{
  unsigned int p;
  TRISC =0; // Configure PORTC as output
  srand(10);
  
  for(;;)          // Endless loop
  {
    p=rand()/128;
    PORTC=p;
    Delay_Ms(100); // Wait 1 s
  }
}