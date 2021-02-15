#line 1 "C:/Users/igor_/Documents/PIC/Mikroc/sound/sound.c"

void main() {
 unsigned char i;
 unsigned char tamanho;
 unsigned int notes[]={
 262, 262, 294, 262,349, 330, 262, 262, 294, 262, 392,
 349, 262, 262, 524, 440, 349, 330, 294, 466, 466, 440,
 349, 392, 349
 };
 unsigned char durations[]={
 1, 1, 2, 2, 2, 3, 1, 1, 2, 2, 2, 3, 1, 1, 2, 2, 2, 2,
 2, 1, 1, 2, 2, 2, 3
 };
 tamanho=sizeof(notes)/sizeof(notes[0]);
 ADCON1=0x0E;
 Sound_init(&PORTB,4);
 for (;;){
 for (i=0;i<tamanho;i++){
 Sound_play(notes[i],400*durations[i]);
 Delay_ms(100);
 }
 Delay_ms(3000);
 }
}
