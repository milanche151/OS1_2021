//
// Created by os on 6/21/22.
//
#include "../h/syscall_c.h"
#include "../h/kernel.h"

//#include "console.h"
enum BitMaskSstatus
{
    SSTATUS_SIE = (1 << 1),
    SSTATUS_SPIE = (1 << 5),
    SSTATUS_SPP = (1 << 8),
};
static inline void mc_sstatus(uint64 mask)
{
    __asm__ volatile ("csrc sstatus, %[mask]" : : [mask] "r"(mask));
}
static inline void ms_sstatus(uint64 mask) {
    __asm__ volatile ("csrs sstatus, %[mask]" : : [mask] "r"(mask));
}
volatile sched scheduler=0,schend=0;
volatile blist *blocked = 0,*blend = NULL;
extern void printc(char c);
void sc_put(thread_t thr){
    //printc('u');
    //mc_sstatus(SSTATUS_SIE);
    sched pom=__mem_alloc(sizeof(_scheduler));
    if(pom==NULL) {
        printc('g');
        return;
    }
    if(!scheduler){
        scheduler= pom;
        scheduler->data=thr;
        scheduler->next=NULL;
        schend=scheduler;
        return;
    }
    schend->next=pom;
    schend=schend->next;
    schend->data=thr;
    schend->next=NULL;
    //printc('p');
    //ms_sstatus(SSTATUS_SIE);
}
thread_t sc_get(){
    //mc_sstatus(SSTATUS_SIE);
    sched s=scheduler;
    if(s==NULL){
        schend=NULL;
        return NULL;
    }
    thread_t t=s->data;
    if(scheduler)scheduler=scheduler->next;
    __mem_free(s);
    //ms_sstatus(SSTATUS_SIE);
    return t;
}
int sc_empty(){
    if(scheduler==NULL){
        return 1;
    }
    else return 0;
}
extern void printaddr(uintptr a);
int b_put(sem_t sem ,thread_t thr){
    blist* pom=__mem_alloc(sizeof(blist));
    if(pom==NULL)return -1;
    pom->data=thr;
    pom->next=NULL;
    if(!sem->blocked){
        sem->blocked= pom;
        sem->blend=sem->blocked;
        return 0;
    }
    sem->blend->next=pom;
    sem->blend= sem->blend->next;
    return 0;
}

thread_t b_get(sem_t sem){
    blist* s=sem->blocked;
    if(s==NULL){
        sem->blend=NULL;
        return NULL;
    }
    thread_t thr=s->data;
    sem->blocked=sem->blocked->next;
    __mem_free(s);
    return thr;

}
extern void putc1(char c);
int putblocked(thread_t thr,time_t time){
    blist* pom=__mem_alloc(sizeof(blist));
    if(!pom)return -1;
    pom->data=thr;
    pom->time=time;
    pom->next=NULL;
    if(!blocked){

        blocked= pom;
        blend=blocked;
        return 0;
    }
    blend->next=pom;
    blend=blend->next;

    return 0;
}
int sc_in(uint64 id){
    for(sched s=scheduler;s;s=s->next){
        if(s->data->id==id) return 1;
    }
    return 0;
}

