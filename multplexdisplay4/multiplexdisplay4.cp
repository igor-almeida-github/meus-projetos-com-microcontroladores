#line 1 "C:/Users/igor_/Documents/PIC/Mikroc/multplexdisplay4/multiplexdisplay4.c"


void display7(int x,int disp){
 unsigned short int tabela[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
 PORTE.RE0=0;
 PORTE.RE1=0;
 PORTE.RE2=0;
 PORTC.RC7=0;
 PORTD = tabela[x];
 if (disp==1) PORTE.RE0=1;
 if (disp==2) PORTE.RE1=1;
 if (disp==3) PORTE.RE2=1;
 if (disp==4) PORTC.RC7=1;
}

void main()
{
unsigned short int D1000;
unsigned short int D100;
unsigned short int D10;
unsigned short int D1;
unsigned int cnt=1234;

 ADCON1=0x0F;
 TRISD =0;
 TRISE.RE0=0;
 TRISE.RE1=0;
 TRISE.RE2=0;
 TRISC.RC7=0;

 for(;;){
 D1000=cnt/1000;
 D100=(cnt%1000)/100;
 D10=((cnt%1000)%100)/10;
 D1=(((cnt%1000)%100)%10);
 display7(D1,1);
 Delay_ms(40);
 display7(D10,2);
 Delay_ms(40);
 display7(D100,3);
 Delay_ms(40);
 display7(D1000,4);
 Delay_ms(40);
 }


}
