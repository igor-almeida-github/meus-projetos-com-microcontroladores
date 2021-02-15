const unsigned long NUM_OF_SAMPLES = 256;// 256 pairs of [Re, Im] values
const unsigned long SAMPLE_FREQ  = 70000;// kHz

  unsigned Samples[NUM_OF_SAMPLES * 2] ;
  unsigned InputSamples[NUM_OF_SAMPLES * 2];  // Y data space is required by FFT routine
                                           //   See datasheet for your dsPIC to see Y data space limits.
  unsigned freq;                           // Auxiliary variables
  char txt[10];
  unsigned Written[128];
  unsigned globali;
  char doDraw;

// Glcd module connections
  sbit GLCD_D7 at RD7_bit;
  sbit GLCD_D6 at RD6_bit;
  sbit GLCD_D5 at RD5_bit;
  sbit GLCD_D4 at RD4_bit;
  sbit GLCD_D3 at RD3_bit;
  sbit GLCD_D2 at RD2_bit;
  sbit GLCD_D1 at RD1_bit;
  sbit GLCD_D0 at RD0_bit;
  sbit GLCD_D7_Direction at TRISD7_bit;
  sbit GLCD_D6_Direction at TRISD6_bit;
  sbit GLCD_D5_Direction at TRISD5_bit;
  sbit GLCD_D4_Direction at TRISD4_bit;
  sbit GLCD_D3_Direction at TRISD3_bit;
  sbit GLCD_D2_Direction at TRISD2_bit;
  sbit GLCD_D1_Direction at TRISD1_bit;
  sbit GLCD_D0_Direction at TRISD0_bit;

  sbit GLCD_CS1 at LATB2_bit;
  sbit GLCD_CS2 at LATB3_bit;
  sbit GLCD_RS  at LATB4_bit;
  sbit GLCD_RW  at LATB5_bit;
  sbit GLCD_EN  at LATB6_bit;
  sbit GLCD_RST at LATB7_bit;
  sbit GLCD_CS1_Direction at TRISB2_bit;
  sbit GLCD_CS2_Direction at TRISB3_bit;
  sbit GLCD_RS_Direction  at TRISB4_bit;
  sbit GLCD_RW_Direction  at TRISB5_bit;
  sbit GLCD_EN_Direction  at TRISB6_bit;
  sbit GLCD_RST_Direction at TRISB7_bit;
// End Glcd module connections

//-------------- Initialization of AD converter
void InitAdc() {

  ADPCFG = 0x00FF; // PORTB<8:15> is analog, PORTB<0:7> is digital
  TRISB.F8 = 1;    // RB8 as input pin

  ADCHS  = 8;      // Connect RBxx/ANxx as CH8 input. RB8 is input pin
  ADCSSL = 0;      //
  ADCON3 = 0x001F; // sample time = 31 Tad.
  ADCON2 = 0;
  ADCON1 = 0x8304; // turn ADC ON, fractional result, manual conversion start, auto sampling

}//~

//-------------- Initialize GLCD for dsPICPRO board
void InitGlcd() {
  Glcd_Init();
  delay_ms(100);
  Glcd_Fill(0xAA); // Show stripes on GLCD to signalize startup
  Delay_ms(500);   // Wait for a while
  Glcd_Fill(0x00); // Clear screen
}//~

//-------------- Main Initialization
void MainInit() {
  globali = 0;
  DoDraw = 0;
  TRISF = 0;
  LATF  = 0;
  memset(InputSamples, 0, 1024); // Clear samples
  InitAdc();
  InitGlcd();
  Vector_Set(Written, 128, 0xFFFF);  // Fill "Written" with $FFFF
  Glcd_Write_Text(" Hz", 100, 0, 1);

  // prescaler 1:1
  T1CON.B5 = 0;
  T1CON.B4 = 0;
  PR1 = (unsigned long)(Get_Fosc_kHz()) * 1000 / (4 * SAMPLE_FREQ);
  TON_bit = 1; // start timer1
  IEC0.T1IE = 1; // enable T1 interrupt
}//~


//-------------- Auxiliary function for converting 1.15 radix point to
//               IEEE floating point variable (needed for sqrt).
float Fract2Float(int input) {

   if (input < 0)
     input = - input;
   return (input / 32768.);
}//~


//-------------- Data output procedure. It draws FFT components on GLCD.
//               GLCD coordinate system starts at top left corner. Therefore,
//               line drawing had to be modified in order to achieve
//               a viewable spectrum on screen.
//               "Samples" at this moment contains DFT of the signal in the manner Re, Im, Re, Im...
void WriteData() {

  unsigned Re, Im, tmpw,
           j, k, l, max;
  float    Rer, Imr, tmpR;


  j      = 0;                      // If you want to skip DC component then make j >= 1
  k      = 0;
  max    = 0;
  freq = 0;                        // Reset current max. frequency for new reading




  while (k <= 127)   {
      Re = InputSamples[j++];      // Real part of DFT sample

      Im = InputSamples[j++];      // Imaginary part of DFT sample

      Rer = Fract2Float(Re);       // conversion to IEEE floating point
      Imr = Fract2Float(Im);       // conversion to IEEE floating point

      tmpR = Rer * Rer;            // Re^2
      Rer  = tmpR;
      tmpR = Imr * Imr;            // Im^2
      Imr  = tmpR;
      tmpR = sqrt(Rer + Imr);      // Amplitude of current DFT sample
      Rer  = tmpR * 512.;          // DFT is scaled down by 1/N, we need to
                                   //   take it back in order to have visible
                                   //   components on GLCD
      Re = Rer;                    // Truncate to nearest integer

      if (Re > 63)
        if(k != 0)
          //--- NOTE: rejecting values for k=0 removes strong DC component
          Re = Written[k-1];       // k = 0? beware of the glitch
        else
          Re = 0;

      if (Re > max) {
          max = Re;
          freq = k;                // This should be the center frequency of the signal
      }

      tmpw = Written[k];
      if (tmpw != Re) {            // Draw only those components that changed
          l = 64 - tmpw;           // 64 lines on GLCD on Y axis
          while (l <= 63) {        // Clear line to the bottom of the screen
             Glcd_Dot(k, l, 0);
             l++;
          }

           l = 64 - Re;           // Draw line to the bottom of the screen
           while (l <= 63) {
               Glcd_Dot(k, l, 1);
               l++;
           }
           Written[k] = Re;       // Mark that the current sample has been drawn
      }
      k++;                      // Move current X coordinate
   }

   //--- Write the frequency of max. amplitude sample
   freq *= (SAMPLE_FREQ / NUM_OF_SAMPLES);
   WordToStr(freq, txt);
   Glcd_Write_Text(txt, 70, 0, 1);
}//~

//-------------- Takes current sample
unsigned ReadAdc() {
  LATF = ~ PORTF;               // you can put osciloscope on PORTF to check the sampling frequency
  SAMP_bit = 0;                    // Start conversion
  while (DONE_bit == 0)            // Wait for ADC to finish
    asm nop;
  return ADCBUF0;                   // Get ADC value
}//~


//-------------- Fills "Samples" with input samples in manner Re, Im, Re, Im... where Im = 0
void SampleInput()
 {
   Samples[globali++] = ReadAdc();   // Re
   Samples[globali++] = 0;            // Im
   if (globali >= 511)
     {   globali = 0;
         if (!doDraw)
         { //do not overwrite non processed
           memcpy(InputSamples, Samples, 1024);
           DoDraw = 1;
         }
     }
  // "Samples" now contains 128 pairs of <Re, Im> samples
}//~


void Timer1Int() iv IVT_ADDR_T1INTERRUPT{ // sample with 20kHz
  SampleInput();              // Sample input signal
  LATF = ~PORTF;
  IFS0.T1IF = 0; // clear interrupt flag
 }

//-------------- Main program starts here
void main()
 {
  MainInit();                     // Initialize all
  while (1)                      // Infinite loop
  {
     if (doDraw) {
      // Perform FFT (DFT), 7 stages, 128 samples of complex pairs
      // Twiddle factors are taken from the <TwiddleFactors.dpas> unit
      FFT(8, TwiddleCoeff_256, InputSamples);
      // DFT butterfly algorythm bit-reverses output samples.
      // We have to restore them in natural order.
      BitReverseComplex(8, InputSamples);
      // Draw DFT samples on GLCD
      WriteData();
      doDraw = 0;
     }
  }
 }//~!
