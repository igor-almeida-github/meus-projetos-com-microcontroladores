// Código para a criação de funções de controle de uma fita led ws2812b
// Ordem dos comandos da fita: GRB do mais significante para o menos significante
int i;
int j;
float brilho;
float brilho_anterior=0;
// vetores das cores para rotação e animação, respectivamente;
unsigned char rgbrot_full_bright[48]={0,255,0, 10,245,0, 20,235,0,  30,225,0, 50,205,0,  60,195,0,   100,155,0,  160,95,0,  190,65,0,  210,45,0,  225,30,0, 235,20,0,  245,10,0,  255,0,0,  255,0,0, 255,0,0 };
unsigned char rgbrot[48]={0,255,0, 10,245,0, 20,235,0,  30,225,0, 50,205,0,  60,195,0,   100,155,0,  160,95,0,  190,65,0,  210,45,0,  225,30,0, 235,20,0,  245,10,0,  255,0,0,  255,0,0, 255,0,0 };
unsigned char matriz[48]={255,0,0,255,0,0,255,30,0,200,55,0,185,70,0,105,150,0,55,200,0,0,255,0,0,200,55,0,175,80,0,100,155,0,50,205,0,0,255,200,0,55,230,0,25,250,0,5};
unsigned int elapsedTime=0;
unsigned char disp[20]; // ****************************************
float rpm=0;
int nleds=0;// numero de leds a serem acesos
int nleds_anterior=0; // numero de leds já acesos na fita

void ledstrip_write0(void){
     // escrever 0
         PORTB.RB2=1; //200ns   1 ciclo de maquina
         asm nop      // desperdiça 200ns
         PORTB.RB2=0; //200ns

}
void ledstrip_write1(void){
     // escrever 1
         PORTB.RB2=1; //200ns   1 ciclo de maquina
         asm nop      // desperdiça 200ns
         asm nop      // desperdiça 200ns
         asm nop      // desperdiça 200ns
         PORTB.RB2=0; //200ns

}
void ledstrip(unsigned char red, unsigned char green, unsigned char blue){
     short int k;

     // green
     for (k=7;k>=0;k--){  // enviando bit mais significante primeiro

         if ((green &(0x01<<k))==0){ // green and ( binario 0000 0001 desviado de k unidades para a esquerda). Se o resultado do and for zero, quer dizer que o bit de green na posição k é 0, caso contrário, ele é 1
            ledstrip_write0();
         }
         else{
            ledstrip_write1();
         }
     }
     //red
     for (k=7;k>=0;k--){  // enviando bit mais significante primeiro
         if ((red &(0x01<<k))==0){  // red and ( binario 0000 0001 desviado de k unidades para a esquerda). Se o resultado do and for zero, quer dizer que o bit de red na posição k é 0, caso contrário, ele é 1
            ledstrip_write0();
         }
         else{
            ledstrip_write1();
         }
     }
     //blue
     for (k=7;k>=0;k--){   // enviando bit mais significante primeiro
         if ((blue &(0x01<<k))==0){   // blue and ( binario 0000 0001 desviado de k unidades para a esquerda). Se o resultado do and for zero, quer dizer que o bit de blue na posição k é 0, caso contrário, ele é 1
            ledstrip_write0();
         }
         else{
            ledstrip_write1();
         }
     }

}

void acende_rpm_leds(unsigned char n){ // tempo total de execução dessa função é 5.45ms
           int w;
           unsigned char aux;
           aux=3*n;  // variavel auxiliar necessária criada pois calcular 3*n dentro do for demora e portanto a fita reseta
           for(w=0;w<n;w++){ // faça ... para o numero n de leds a serem acendidos
                    ledstrip(rgbrot[aux-3],rgbrot[aux-2],rgbrot[aux-1]);
           }
           n=16-n;
           for(w=0;w<n;w++){    // escreve 0 nos leds restantes
                    ledstrip(0,0,0);
           }
}

void animacaoInicial(){
    unsigned char lastrow[3];
    for(i=0;i<147;i++){  // for para o inicio da animação, cores girando
           // salva a ultima linha da matriz de cores dos leds para depois enviar para a primeira posição
           lastrow[0]=matriz[45];
           lastrow[1]=matriz[46];
           lastrow[2]=matriz[47];
           // arrasta todos os elementos da matriz de cores 3 unidades para a direita
           for(j=0;j<45;j++){
              matriz[47-j]=matriz[44-j];
           }
           matriz[0]=lastrow[0];
           matriz[1]=lastrow[1];
           matriz[2]=lastrow[2];

           for(j=0;j<48;j=j+3){
                    ledstrip(matriz[j],matriz[j+1],matriz[j+2]);
           }
           Delay_ms(40); //CONTROLE DA VELOCIDADE DE ROTAÇÃO DA ANIMAÇÃO

     }
     for(i=1;i<17;i++){  // for para o final da animação, desligando os leds progressivamente
        for(j=0;j<3*i;j=j+3){
                        ledstrip(0,0,0);
               }
               Delay_ms(20); //CONTROLE DA VELOCIDADE DE ROTAÇÃO DA ANIMAÇÃO
    }
    Delay_ms(350);
    // animação das cores do rpm aumentando
    for(i=1;i<17;i++){
        acende_rpm_leds(i);
        Delay_ms(90);
    }
    Delay_ms(1000);
    // animação das cores do rpm diminuindo
    for(i=15;i>-1;i--){
        acende_rpm_leds(i);
        Delay_ms(90);
    }
    
}

void interrupt(void){

   if ( INTCON.TMR0IF){ // ocorreu overflow do timer 0
      elapsedTime=0;
      T0CON.TMR0ON=0;
   }
   if( INTCON.INT0IF){ // borda de subida no pino INT0
      T0CON.TMR0ON=1;
      elapsedTime=TMR0L;
      elapsedTime+=(TMR0H<<8);
   }
   asm{ 
        CLRF 0xFD7        //TMR0H=0; //reseta high byte do timer 0 //   assembly para evitar demorar na interrupção
        CLRF 0xFD6        //TMR0L=0;//reseta low byte do timer 0  //   assembly para evitar demorar na interrupção
        BCF  0xFF2,1      //INTCON.INT0IF=0;
        BCF  0xFF2,2      //INTCON.TMR0IF=0;
    }
}
void main() {
     ADCON1=0x0E;  // porta RA0 é analógica, todas as outras são digitais
     TRISA.RA0=1; //AN0 é input para medir luminosidade
     TRISB.RB2=0; //RB0 é output
     PORTB.RB2=0; //RB0 inicia em 0
     TRISB.RB0=1; // Int 0 é INPUT
     Delay_ms(1);  // reset da fita
     for(i=1;i<17;i++) ledstrip(0,0,0); // Apaga todos os leds
     Delay_ms(1); // reset da fita
     
     // determina o brilho dos leds do rpm
     brilho=(1.0*Adc_Read(0))/1023.0;
     for(i=0;i<48;i++){  // CONTROLE DA INTENSIDADE DE TODOS OS LEDS DO RPM
         rgbrot[i]=brilho*rgbrot_full_bright[i];
     }
     
     animacaoInicial(); // vai para a animação inicial, pode ser removida sem alterar o funcionamento do código principal

     RCSTA<7>=1;  //**************************
     TRISC.RC7=1;//**************************
     TRISC.RC6=1;//**************************
     UART1_Init(9600);//**************************
     Delay_ms(100); //**************************
     //***********configurações de interrupções***************
     //lembrete das flags:
     //INTCON.TMR0IF flag overflow do timer 0
     //INTCON.INT0IF flag ocorrencia de evento no pino INT0
     //configurações:
     INTCON=0xF0; // habilita a interrupção do pino INT0 e a interrupção pelo overflow do timer 0
     INTCON2.INTEDG0=1;//Interrupção na borda de subida do pino INT0
     T0CON=0x06; //timer0 no modo de 16 bits, prescale 128  //fazer T0CON.TMR0ON=1 para disparar o timer
     T0CON.TMR0ON=1; //dispara o timer0
     //*******************************************************
     
     
     for(;;){
          // calcula rpm
          if ( elapsedTime!=0){
              rpm=(1000000/(25.6*elapsedTime))*60;
              }
              else rpm=0;
              
            // determina o brilho dos leds do rpm
           brilho=(1.0*Adc_Read(0))/1023.0;
           for(i=0;i<48;i++){  // CONTROLE DA INTENSIDADE DE TODOS OS LEDS DO RPM
               rgbrot[i]=brilho*rgbrot_full_bright[i];
           }
         
          // atualiza mostrador rpm
          nleds = rpm/250;
          if (nleds>16) nleds=16; // maximo de 4000 rpm para 16 leds, se passar disso, o numero de leds acesos é 16
          if ((nleds!=nleds_anterior)||(brilho-brilho_anterior>0.1)||(brilho_anterior-brilho>0.1)) {// só atualiza a fita quando o numero de leds a serem acesos mudar em relação ao que já está aceso na fita ou então se o brilho tiver que mudar
            acende_rpm_leds(nleds);// 1 led a cada 250 rpm, variando de 250 até 4000 rpm
            nleds_anterior= nleds;
            brilho_anterior=brilho;
          }
          
       }
}