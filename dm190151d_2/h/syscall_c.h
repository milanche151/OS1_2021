//
// Created by os on 5/14/22.
//
#include"../lib/hw.h"
#ifndef PROJECT_BASE_V1_0_SYSCALL_C_H
#define PROJECT_BASE_V1_0_SYSCALL_C_H
#define EOF  (char)-1
typedef struct _pcb{
    uint64 ra;
    uint64 sp;
}_pcb;
typedef enum thread_state{
    CREATED,READY,RUNNING,BLOCKED,WAITING,DEAD,SUSPENDED
}thread_state;
typedef struct _thread{
    uint64 id;
    _pcb* context;
    uint64* stack;
    thread_state state;
    void(*start_routine)(void*);
    void* arg;
    time_t timeslice;
    time_t period;
    time_t sleep;
    uint64 isPer;

}_thread;
typedef _thread* thread_t;
typedef struct blist{
    thread_t data;
    time_t time;
    struct blist* next;
}blist;
typedef struct _sem{
    int value;
    blist* blocked;
    blist* blend;
}_sem;
typedef struct _scheduler{
    thread_t data;
    struct _scheduler* next;
}_scheduler;
typedef _scheduler* sched;
void sc_put(thread_t thr);
thread_t sc_get();
typedef _sem* sem_t;
typedef unsigned long time_t;

void *mem_alloc (size_t size);
int mem_free (void*);
int thread_create (
        thread_t* handle,
        void(*start_routine)(void*),
        void* arg
);
int thread_exit ();
void thread_dispatch ();
int sem_open (
        sem_t* handle,
        unsigned init
);
int sem_close (sem_t handle);
int sem_wait (sem_t id);
int sem_signal (sem_t id);
int time_sleep (time_t);
char getc ();
void putc (char);
int b_put(sem_t sem,thread_t);
thread_t b_get(sem_t sem);
#endif //PROJECT_BASE_V1_0_SYSCALL_C_H
