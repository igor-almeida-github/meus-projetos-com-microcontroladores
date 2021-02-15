// Este programa pisca um led

void main()
{

  TRISB =0; // Configure PORTB as output

for(;;)          // Endless loop
  {


    PORTB.RB0 = 0;            // RB0 = 0    ou pode ser usado RB0_bit =0;
    Delay_Ms(20); // Wait 1 s
    PORTB.RB0 = 1; // RB0 = 1
    Delay_Ms(20); // Wait 1 s
  }
                       // End of loop

}