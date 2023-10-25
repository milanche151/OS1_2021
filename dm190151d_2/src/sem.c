//
// Created by os on 7/28/22.
//
#include "../h/syscall_c.h"
#include "../lib/hw.h"
int sem_close (sem_t handle){
    int ret;

    asm volatile ("li a0, 0x22\n" // Broj poziva
                  "\tmv a1, %1\n"
                  "\tecall\n"
                  "\tmv %0, a0\n" // Povratna vrednost
            : "=r" (ret)
            : "r" (handle)
    , "r" (handle)
            : "a0", "a1");

    return ret;
}
int sem_wait (sem_t id){
    int ret;

    asm volatile ("li a0, 0x23\n" // Broj poziva
                  "\tmv a1, %1\n"
                  "\tecall\n"
                  "\tmv %0, a0\n" // Povratna vrednost
            : "=r" (ret)
            : "r" (id)
            : "a0", "a1");

    return ret;
}
int sem_signal (sem_t id){
    int ret;

    asm volatile ("li a0, 0x24\n" // Broj poziva
                  "\tmv a1, %1\n"
                  "\tecall\n"
                  "\tmv %0, a0\n" // Povratna vrednost
            : "=r" (ret)
            : "r" (id)
            : "a0", "a1");

    return ret;
}
int sem_open (
        sem_t* handle,
        unsigned init
){
    int ret;

    asm volatile ("li a0, 0x21\n" // Broj poziva
                  "\tmv a1, %1\n"
                  "\tmv a2, %2\n"
                  "\tecall\n"
                  "\tmv %0, a0\n" // Povratna vrednost
            : "=r" (ret)
            :"r" (handle), "r" (init)
            : "a0", "a1","a2");

    return ret;
}
int time_sleep (time_t time){
    int ret;

    asm volatile ("li a0, 0x31\n" // Broj poziva
                  "\tmv a1, %1\n"
                  "\tecall\n"
                  "\tmv %0, a0\n" // Povratna vrednost
            : "=r" (ret)
            :"r" (time)
            : "a0", "a1");

    return ret;
}