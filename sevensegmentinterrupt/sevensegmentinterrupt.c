// LEMBRE-SE DE COLOCAR O BREAK DENTRO DO SWITCH CASE

// este programa aciona 4 displays de 7 segmentos multiplexados a partir do uso de interrupçãoes
unsigned short int  D1000;
unsigned short int  D100;
unsigned short int  D10;
unsigned short int  D1;
unsigned int cnt=1025;
unsigned short int display=1;

void display7(int x,unsigned short int disp){
  unsigned short int tabela[]={0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F}; // tabela dos valores correspondentes aos numeros 1 a 9, na ordem
  PORTD =  tabela[x];
  if (disp==1) PORTE.RE0=1;// menos significativo
  if (disp==2) PORTE.RE1=1;
  if (disp==3) PORTE.RE2=1;
  if (disp==4) PORTC.RC7=1;// mais significativo
}
void interrupt (void){
     if (INTCON.TMR0IF==1){  // flag que indica overflow do timer 0
       INTCON.TMR0IF=0;
       TMR0L= 158; // reinicia o valor do reg timer 0
        // limpa a flag de overflow do timer 0;
        D1=(((cnt%1000)%100)%10);
        D10=((cnt%1000)%100)/10; 
        D100=(cnt%1000)/100;
        D1000=cnt/1000;
        PORTE.RE0=0; // menos significativo
        PORTE.RE1=0;
        PORTE.RE2=0;
        PORTC.RC7=0; // mais significativo
       switch (display){
           case 1:{
                display7(D1,1);
                break;
           }
           case 2:{
                if(D10!=0||D100!=0||D1000!=0) display7(D10,2);
                break;
           }
           case 3:{
                if(D100!=0||D1000!=0) display7(D100,3);
                break;
           }
           case 4:{
                if(D1000!=0) display7(D1000,4);
                break;
           }
       }
       display++;
       if (display == 5) display =1;


     }

     else if (INTCON.INT0IF==1){
          cnt++;
          INTCON.INT0IF=0;
     }

}


void main()
{

  INTCON.TMR0IE=1;
  ADCON1=0x0F;
  TRISD =0; // Configure PORTD as output
  TRISE.RE0=0; //disp 1
  TRISE.RE1=0;  //disp 2
  TRISE.RE2=0;  //disp 3
  TRISC.RC7=0;  //disp 4
  TRISB.RB0=1;  // INT0 é output
  // configuração das interrupções:
  T0CON = 0xC7;
  TMR0L= 158; // Modifica o valor do registrador  low do timer 0  com 158 para contar aprox 50ms
  INTCON=0xB0; // configuração das interrupções

  for(;;){    // Endless loop

  } // End of loop


}