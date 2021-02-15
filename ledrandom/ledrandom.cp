#line 1 "C:/Users/igor_/Documents/PIC/Mikroc/ledrandom/ledrandom.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic/include/stdlib.h"







 typedef struct divstruct {
 int quot;
 int rem;
 } div_t;

 typedef struct ldivstruct {
 long quot;
 long rem;
 } ldiv_t;

 typedef struct uldivstruct {
 unsigned long quot;
 unsigned long rem;
 } uldiv_t;

int abs(int a);
float atof(char * s);
int atoi(char * s);
long atol(char * s);
div_t div(int number, int denom);
ldiv_t ldiv(long number, long denom);
uldiv_t uldiv(unsigned long number, unsigned long denom);
long labs(long x);
int max(int a, int b);
int min(int a, int b);
void srand(unsigned x);
int rand();
int xtoi(char * s);
#line 3 "C:/Users/igor_/Documents/PIC/Mikroc/ledrandom/ledrandom.c"
void main()
{
 unsigned int p;
 TRISC =0;
 srand(10);

 for(;;)
 {
 p=rand()/128;
 RC1_bit=1;
 Delay_Ms(100);
 }
}
