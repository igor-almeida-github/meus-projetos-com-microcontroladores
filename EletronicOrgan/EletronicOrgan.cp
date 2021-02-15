#line 1 "C:/Users/igor_/Documents/Microcontroladores/PIC/Mikroc/EletronicOrgan/EletronicOrgan.c"
char keypadPort at PORTD;
unsigned int Notas[]={0,262,294,330,349,392,440,494,524,277,311,370,415};
unsigned short int Index[]={0, 1, 2, 3, 0, 4, 5, 6, 0, 7, 8, 9, 0, 10, 11, 12};
void main() {
 unsigned short int key;
 ADCON1=0x0F;
 Keypad_Init();
 Sound_Init(&PORTC, 3);
 for(;;){
 do
 key = Keypad_Key_Press();
 while(key==0);
 Sound_play(Notas[Index[key]],500);
 }
}
