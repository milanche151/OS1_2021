//
// Created by os on 5/20/22.
//

#ifndef PROJECT_BASE_V1_0_KERNEL_H
#define PROJECT_BASE_V1_0_KERNEL_H


#include "../lib/hw.h"
#include "syscall_c.h"

#define NULL ((void*)0)

typedef uint64 uintptr;
typedef long int64;
typedef int64 ssize_t;

typedef uint spinlock;
#define INITLOCK 0

void slacquire(spinlock *lk);
void slrelease(spinlock *lk);

void initmem();


void * __mem_alloc(size_t);
int __mem_free(void*);
int __sem_open (
        sem_t* handle,
        unsigned init
);
int __sem_close (sem_t handle);
int __sem_wait (sem_t id);
int __sem_signal (sem_t id);

void *memset(void *ptr, int b, size_t n);
typedef struct args{
    uint64 a0;
    uint64 a1;
    uint64 a2;
    uint64 a3;
    /*uint64 a4;
    uint64 a5;
    uint64 a6;
    uint64 a7;*/
}args;
uint64 handleSupervisorTrap(args* arg);



#endif //PROJECT_BASE_V1_0_KERNEL_H
