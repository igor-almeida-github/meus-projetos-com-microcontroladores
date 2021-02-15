#line 1 "C:/Users/igor_/Documents/PIC/Mikroc/x7segment/x7segment.c"


unsigned short int display7(int x){
 unsigned short int tabela[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F};
 return tabela[x];
}
int i;
void main()
{

 ADCON1=0x0F;
 TRISD =0;

 for(;;){
 for (i=0;i<10;i++){
 PORTD = display7(i);
 Delay_ms(100);
 }

 }


}
