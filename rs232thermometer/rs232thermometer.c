// Este programa é um termometro serial que usa um lm35 para medir temperatura e envia pela porta serial
#define LM35 0
void newline(){                                                                 // Nova linha no monitor serial
  UART1_Write(0x0D);
  UART1_Write(0x0A);
}
void main() {
    // Declaração de variáveis locais
    float temp;
    unsigned char txt[8];
    char*pnt;
    // Configurações iniciais
    ADCON1=0x0E;                                                                // Porta RA0/AN0 é analógica, todo o resto é digital
    UART1_Init(9600);                                                           // Inicializa UART em boud rate 9600
    // Texto de apresentação
    UART_Write_Text("TERMOMETRO SERIAL");
    newline();
    delay_ms(500);
    UART_Write_Text("TEMPERATURA:");
    newline();
    delay_ms(500);
    for(;;){
         temp=(ADC_Read(LM35)*(5000.0/1024))/10;                                // Temperatura em C, 10mv/C.
         floatTostr(temp,txt);                                                  // Converte para string
         pnt=strchr(txt,'.');                                                   // procura o endereço do '.' na string txt, para saber onde o ponto decimal se encontra
         *(pnt+3)='\0';                                                         // Insere o caracter NULL na posição de mémoria referente ao ponto mais 3, para que o valor float só seja mostrado com duas casas decimais
         UART_Write_Text(txt);
         UART_Write_Text("C");
         newline();
         delay_ms(500);
    }
}