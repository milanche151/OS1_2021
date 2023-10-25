//
// Created by os on 8/14/22.
//
extern "C" {
#include "../h/syscall_c.h"

}
#include "../h/syscall_cpp.hpp"

void *operator new(size_t n)
{
    return mem_alloc(n);
}

void *operator new[](size_t n)
{
    return mem_alloc(n);
}

void operator delete(void *p)
{
 mem_free(p);
}

void operator delete[](void *p)
{
 mem_free(p);
}

void Thread::wrapper(void* t) {
    ((Thread*)t)->run();
}
Thread::Thread (void (*body)(void*),void* arg){
    thread_create(&(this->myHandle),body,arg);
    this->myHandle->state=CREATED;
}

Thread::Thread() {
    thread_create(&(this->myHandle),0,this);
    this->myHandle->state=CREATED;
}

int Thread::start() {
    if(this->myHandle->start_routine==0){
       /* asm volatile ("li a0, this\n" // Broj poziva
        );*/
        this->myHandle->start_routine=&Thread::wrapper;
        this->myHandle->arg=this;
    }
    this->myHandle->state=READY;
    return 0;
}

Thread::~Thread() {

    delete this->myHandle->context;
    delete[] this->myHandle->stack;
    delete this->myHandle;

}

void Thread::dispatch() {
    thread_dispatch();
}

int Thread::sleep(time_t time) {
    return time_sleep(time);
}
Semaphore::~Semaphore() {
    sem_close(this->myHandle);
}
Semaphore::Semaphore(unsigned int init) {
    sem_open(&this->myHandle,init);
}

int Semaphore::signal() {
   return sem_signal(this->myHandle);
}

int Semaphore::wait() {
   return sem_wait(this->myHandle);
}

char Console::getc() {

       return ::getc();

}

void Console::putc(char c) {

     ::putc(c);

}
PeriodicThread::PeriodicThread(time_t period):Thread(){
    myHandle->period=period;


}

void PeriodicThread::run() {
    while(1){
        this->periodicActivation();
        this->sleep(myHandle->period);
    }
}