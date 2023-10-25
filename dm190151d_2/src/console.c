//
// Created by os on 8/1/22.
//
//
#include "../h/kernel.h"
#include "../h/syscall_c.h"

#define BUFFSIZE 900000

char* uartBuffer1;
char* uartBuffer2;
volatile int bw1=0,br1=0;
volatile int bw2=0,br2=0;
sem_t mutex1,mutex2;
sem_t ioSemEmpty1;
void initBuffers(){
    uartBuffer1= __mem_alloc(BUFFSIZE*sizeof (char));
    uartBuffer2= __mem_alloc(BUFFSIZE*sizeof (char));
    __sem_open(&mutex1,1);
    __sem_open(&mutex2,1);
    __sem_open(&ioSemEmpty1,0);
}
void put_uart1(char c){
    __sem_wait(mutex1);
    uartBuffer1[bw1++]=c;

    __sem_signal(mutex1);
}
char get_uart1(){
    __sem_wait(mutex1);
    if(br1==bw1){
        br1=0;bw1=0;
        __sem_signal(mutex1);
    }
    if(br1<bw1) {
        char c = uartBuffer1[br1++];
        __sem_signal(mutex1);
        return c;
    }
    __sem_signal(mutex1);
    return EOF;
}
void put_uart2(char c){
    __sem_wait(mutex2);
    uartBuffer2[bw2++]=c;
    __sem_signal(mutex2);
}
char get_uart2(){
    __sem_wait(mutex2);
    if(br2<bw2) {
        __sem_signal(mutex2);
        return uartBuffer2[br2++];

    }
    br2=0;bw2=0;
    __sem_signal(mutex2);
    return EOF;

}
int  isEmpty1(){

    if(br1==bw1){
        return 1;
    }
    return 0;
}
int  isEmpty2(){

    if(br2==bw2){

        return 1;
    }
    return 0;
}
int isFull2(){
    if(bw2>=(BUFFSIZE-1)){
        return 1;
    }
    else return 0;
}
int isFull1(){
    if(bw1>=(BUFFSIZE-1)){
        return 1;
    }
    else return 0;
}
char getc (){
    int ret;
    if(!uartBuffer1) return EOF;
    while(isEmpty1()){
        sem_wait(ioSemEmpty1);
    }
    /*while(isEmpty1()){
        __sem_wait(ioSemEmpty1);
    }*/
    asm volatile ("li a0, 0x41\n" // Broj poziva
                  "\tecall\n"
                  "\tmv %0, a0\n" // Povratna vrednost
                    : "=r" (ret)
                    :
                    : "a0");


    return ret;

}
void putc (char c){

    while(isFull2()){}
    asm volatile ("li a0, 0x42\n"// Broj poziva
                 "\tmv a1, %0\n"
                  "\tecall\n"
                  ::"r"(c)
                  :"a0","a1"
            );


}
