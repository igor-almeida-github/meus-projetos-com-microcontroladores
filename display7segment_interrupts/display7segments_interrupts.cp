#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/display7segment_interrupts/display7segments_interrupts.c"
const unsigned long NUM_OF_SAMPLES = 256;
const unsigned long SAMPLE_FREQ = 70000;

 unsigned Samples[NUM_OF_SAMPLES * 2] ;
 unsigned InputSamples[NUM_OF_SAMPLES * 2];

 unsigned freq;
 char txt[10];
 unsigned Written[128];
 unsigned globali;
 char doDraw;


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
 sbit GLCD_RS at LATB4_bit;
 sbit GLCD_RW at LATB5_bit;
 sbit GLCD_EN at LATB6_bit;
 sbit GLCD_RST at LATB7_bit;
 sbit GLCD_CS1_Direction at TRISB2_bit;
 sbit GLCD_CS2_Direction at TRISB3_bit;
 sbit GLCD_RS_Direction at TRISB4_bit;
 sbit GLCD_RW_Direction at TRISB5_bit;
 sbit GLCD_EN_Direction at TRISB6_bit;
 sbit GLCD_RST_Direction at TRISB7_bit;



void InitAdc() {

 ADPCFG = 0x00FF;
 TRISB.F8 = 1;

 ADCHS = 8;
 ADCSSL = 0;
 ADCON3 = 0x001F;
 ADCON2 = 0;
 ADCON1 = 0x8304;

}


void InitGlcd() {
 Glcd_Init();
 delay_ms(100);
 Glcd_Fill(0xAA);
 Delay_ms(500);
 Glcd_Fill(0x00);
}


void MainInit() {
 globali = 0;
 DoDraw = 0;
 TRISF = 0;
 LATF = 0;
 memset(InputSamples, 0, 1024);
 InitAdc();
 InitGlcd();
 Vector_Set(Written, 128, 0xFFFF);
 Glcd_Write_Text(" Hz", 100, 0, 1);


 T1CON.B5 = 0;
 T1CON.B4 = 0;
 PR1 = (unsigned long)(Get_Fosc_kHz()) * 1000 / (4 * SAMPLE_FREQ);
 TON_bit = 1;
 IEC0.T1IE = 1;
}




float Fract2Float(int input) {

 if (input < 0)
 input = - input;
 return (input / 32768.);
}







void WriteData() {

 unsigned Re, Im, tmpw,
 j, k, l, max;
 float Rer, Imr, tmpR;


 j = 0;
 k = 0;
 max = 0;
 freq = 0;




 while (k <= 127) {
 Re = InputSamples[j++];

 Im = InputSamples[j++];

 Rer = Fract2Float(Re);
 Imr = Fract2Float(Im);

 tmpR = Rer * Rer;
 Rer = tmpR;
 tmpR = Imr * Imr;
 Imr = tmpR;
 tmpR = sqrt(Rer + Imr);
 Rer = tmpR * 512.;


 Re = Rer;

 if (Re > 63)
 if(k != 0)

 Re = Written[k-1];
 else
 Re = 0;

 if (Re > max) {
 max = Re;
 freq = k;
 }

 tmpw = Written[k];
 if (tmpw != Re) {
 l = 64 - tmpw;
 while (l <= 63) {
 Glcd_Dot(k, l, 0);
 l++;
 }

 l = 64 - Re;
 while (l <= 63) {
 Glcd_Dot(k, l, 1);
 l++;
 }
 Written[k] = Re;
 }
 k++;
 }


 freq *= (SAMPLE_FREQ / NUM_OF_SAMPLES);
 WordToStr(freq, txt);
 Glcd_Write_Text(txt, 70, 0, 1);
}


unsigned ReadAdc() {
 LATF = ~ PORTF;
 SAMP_bit = 0;
 while (DONE_bit == 0)
 asm nop;
 return ADCBUF0;
}



void SampleInput()
 {
 Samples[globali++] = ReadAdc();
 Samples[globali++] = 0;
 if (globali >= 511)
 { globali = 0;
 if (!doDraw)
 {
 memcpy(InputSamples, Samples, 1024);
 DoDraw = 1;
 }
 }

}


void Timer1Int() iv IVT_ADDR_T1INTERRUPT{
 SampleInput();
 LATF = ~PORTF;
 IFS0.T1IF = 0;
 }


void main()
 {
 MainInit();
 while (1)
 {
 if (doDraw) {


 FFT(8, TwiddleCoeff_256, InputSamples);


 BitReverseComplex(8, InputSamples);

 WriteData();
 doDraw = 0;
 }
 }
 }
