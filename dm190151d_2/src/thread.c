//
// Created by os on 7/27/22.
//
//#include "../h/kernel.h"
#include "../h/syscall_c.h"
#include "../lib/hw.h"


void thread_dispatch (){
    asm volatile ("li a0, 0x13\n" // Broj poziva
                  "\tecall\n");
}
int thread_create(thread_t* handle,
                  void(*start_routine)(void*),
                  void* arg) {
    void *ret=(void*)0;

    asm volatile ("li a0, 0x11\n" // Broj poziva
                  "\tmv a1, %1\n"
                  "\tmv a2, %2\n"
                  "\tmv a3, %3\n"
                  "\tecall\n"
                  "\tmv %0, a0\n" // Povratna vrednost
            : "=r" (ret)
            : "r" (handle)
    , "r" (start_routine)
    , "r" (arg)
            : "a0", "a1","a2","a3");

    return (uint64)ret;
}
int thread_exit (){

    int ret;

    asm volatile ("li a0, 0x12\n" // Broj poziva
                  "\tecall\n"
                  "\tmv %0, a0\n" // Povratna vrednost
            :"=r" (ret)
            :
            : "a0");

    return ret;
}