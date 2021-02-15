#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/fitaledtest/fitaledtest.c"


int i;
int j;
float brilho;
float brilho_anterior=0;

unsigned char rgbrot_full_bright[48]={0,255,0, 10,245,0, 20,235,0, 30,225,0, 50,205,0, 60,195,0, 100,155,0, 160,95,0, 190,65,0, 210,45,0, 225,30,0, 235,20,0, 245,10,0, 255,0,0, 255,0,0, 255,0,0 };
unsigned char rgbrot[48]={0,255,0, 10,245,0, 20,235,0, 30,225,0, 50,205,0, 60,195,0, 100,155,0, 160,95,0, 190,65,0, 210,45,0, 225,30,0, 235,20,0, 245,10,0, 255,0,0, 255,0,0, 255,0,0 };
unsigned char matriz[48]={255,0,0,255,0,0,255,30,0,200,55,0,185,70,0,105,150,0,55,200,0,0,255,0,0,200,55,0,175,80,0,100,155,0,50,205,0,0,255,200,0,55,230,0,25,250,0,5};
unsigned int elapsedTime=0;
unsigned char disp[20];
float rpm=0;
int nleds=0;
int nleds_anterior=0;

void ledstrip_write0(void){

 PORTB.RB2=1;
 asm nop
 PORTB.RB2=0;

}
void ledstrip_write1(void){

 PORTB.RB2=1;
 asm nop
 asm nop
 asm nop
 PORTB.RB2=0;

}
void ledstrip(unsigned char red, unsigned char green, unsigned char blue){
 short int k;


 for (k=7;k>=0;k--){

 if ((green &(0x01<<k))==0){
 ledstrip_write0();
 }
 else{
 ledstrip_write1();
 }
 }

 for (k=7;k>=0;k--){
 if ((red &(0x01<<k))==0){
 ledstrip_write0();
 }
 else{
 ledstrip_write1();
 }
 }

 for (k=7;k>=0;k--){
 if ((blue &(0x01<<k))==0){
 ledstrip_write0();
 }
 else{
 ledstrip_write1();
 }
 }

}

void acende_rpm_leds(unsigned char n){
 int w;
 unsigned char aux;
 aux=3*n;
 for(w=0;w<n;w++){
 ledstrip(rgbrot[aux-3],rgbrot[aux-2],rgbrot[aux-1]);
 }
 n=16-n;
 for(w=0;w<n;w++){
 ledstrip(0,0,0);
 }
}

void animacaoInicial(){
 unsigned char lastrow[3];
 for(i=0;i<147;i++){

 lastrow[0]=matriz[45];
 lastrow[1]=matriz[46];
 lastrow[2]=matriz[47];

 for(j=0;j<45;j++){
 matriz[47-j]=matriz[44-j];
 }
 matriz[0]=lastrow[0];
 matriz[1]=lastrow[1];
 matriz[2]=lastrow[2];

 for(j=0;j<48;j=j+3){
 ledstrip(matriz[j],matriz[j+1],matriz[j+2]);
 }
 Delay_ms(40);

 }
 for(i=1;i<17;i++){
 for(j=0;j<3*i;j=j+3){
 ledstrip(0,0,0);
 }
 Delay_ms(20);
 }
 Delay_ms(350);

 for(i=1;i<17;i++){
 acende_rpm_leds(i);
 Delay_ms(90);
 }
 Delay_ms(1000);

 for(i=15;i>-1;i--){
 acende_rpm_leds(i);
 Delay_ms(90);
 }

}

void interrupt(void){

 if ( INTCON.TMR0IF){
 elapsedTime=0;
 T0CON.TMR0ON=0;
 }
 if( INTCON.INT0IF){
 T0CON.TMR0ON=1;
 elapsedTime=TMR0L;
 elapsedTime+=(TMR0H<<8);
 }
 asm{
 CLRF 0xFD7
 CLRF 0xFD6
 BCF 0xFF2,1
 BCF 0xFF2,2
 }
}
void main() {
 ADCON1=0x0E;
 TRISA.RA0=1;
 TRISB.RB2=0;
 PORTB.RB2=0;
 TRISB.RB0=1;
 Delay_ms(1);
 for(i=1;i<17;i++) ledstrip(0,0,0);
 Delay_ms(1);


 brilho=(1.0*Adc_Read(0))/1023.0;
 for(i=0;i<48;i++){
 rgbrot[i]=brilho*rgbrot_full_bright[i];
 }

 animacaoInicial();

 RCSTA<7>=1;
 TRISC.RC7=1;
 TRISC.RC6=1;
 UART1_Init(9600);
 Delay_ms(100);





 INTCON=0xF0;
 INTCON2.INTEDG0=1;
 T0CON=0x06;
 T0CON.TMR0ON=1;



 for(;;){

 if ( elapsedTime!=0){
 rpm=(1000000/(25.6*elapsedTime))*60;
 }
 else rpm=0;


 brilho=(1.0*Adc_Read(0))/1023.0;
 for(i=0;i<48;i++){
 rgbrot[i]=brilho*rgbrot_full_bright[i];
 }


 nleds = rpm/250;
 if (nleds>16) nleds=16;
 if ((nleds!=nleds_anterior)||(brilho-brilho_anterior>0.1)||(brilho_anterior-brilho>0.1)) {
 acende_rpm_leds(nleds);
 nleds_anterior= nleds;
 brilho_anterior=brilho;
 }

 }
}
