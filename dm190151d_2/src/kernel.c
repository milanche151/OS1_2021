//
// Created by os on 5/20/22.
//

#include "../h/kernel.h"
#include "../h/syscall_c.h"

extern uintptr hstart;
extern uintptr hend;
static uint64 stID=-1;
static thread_t running;
thread_t idle,mainthr,consolethr;
static time_t timeSliceCounter=0;
sem_t ioSem;
sem_t fullPutc;
int stopputc=0;

static inline void w_stvec(uint64 stvec) {
    __asm__ volatile ("csrw stvec, %[stvec]" : : [stvec] "r"(stvec));
}

static inline void ms_sstatus(uint64 mask) {
    __asm__ volatile ("csrs sstatus, %[mask]" : : [mask] "r"(mask));
}

static inline void w_sepc(uint64 sepc) {
    __asm__ volatile ("csrw sepc, %[sepc]" : : [sepc] "r"(sepc));
}

static inline uint64 r_sstatus() {
    uint64 volatile sstatus;
    __asm__ volatile ("csrr %[sstatus], sstatus" : [sstatus] "=r"(sstatus));
    return sstatus;
}

static inline void w_sstatus(uint64 sstatus) {
    __asm__ volatile ("csrw sstatus, %[sstatus]" : : [sstatus] "r"(sstatus));
}

static inline uint64 r_sepc() {
    uint64 volatile sepc;
    __asm__ volatile ("csrr %[sepc], sepc" : [sepc] "=r"(sepc));
    return sepc;
}
static inline void mc_sstatus(uint64 mask)
{
    __asm__ volatile ("csrc sstatus, %[mask]" : : [mask] "r"(mask));
}
static inline void ms_sip(uint64 mask)
{
    __asm__ volatile ("csrs sip, %[mask]" : : [mask] "r"(mask));
}
static inline void mc_sip(uint64 mask)
{
    __asm__ volatile ("csrc sip, %[mask]" : : [mask] "r"(mask));
}
static inline uint64 r_stvec() {
    uint64 volatile stvec;
    __asm__ volatile ("csrr %[stvec], stvec" : [stvec] "=r"(stvec));
    return stvec;
}
enum BitMaskSstatus
{
    SSTATUS_SIE = (1 << 1),
    SSTATUS_SPIE = (1 << 5),
    SSTATUS_SPP = (1 << 8),
};
enum BitMaskSip
{
    SIP_SSIP = (1 << 1),
    SIP_STIP = (1 << 5),
    SIP_SEIP = (1 << 9),
};
void popSppSpie()
{
    __asm__ volatile ("csrw sepc, ra");
    __asm__ volatile ("sret");
}


/*extern void* __mem_alloc (size_t size);
extern int __mem_free (void*);*/

void __thread_dispatch();
extern sched scheduler;
void thread_wrapper() {
    popSppSpie();
    running->start_routine(running->arg);
    running->state=DEAD;
    thread_dispatch();
}
void system_thread_wrapper() {
    running->start_routine(running->arg);
    running->state=DEAD;
    timeSliceCounter=0;
    __thread_dispatch();
}
void printaddr(uintptr a);
    int __thread_create(
        thread_t* handle,
        void(*start_routine)(void*),
        void* arg
        ){
     if(handle==NULL){

        handle=&mainthr;
        (*handle)= __mem_alloc(sizeof(_thread));
        if((*handle)==NULL) return -1;
         (*handle)->id = ++stID;
         (*handle)->timeslice = DEFAULT_TIME_SLICE;
         (*handle)->state = READY;
         (*handle)->context=__mem_alloc(sizeof(_pcb));
         if ((*handle)->context == NULL) return -1;
         (*handle)->context->ra=(uint64)&thread_wrapper;
         (*handle)->stack = __mem_alloc(DEFAULT_STACK_SIZE * sizeof(uint64));
         if ((*handle)->stack == NULL) return -1;
        // (*handle)->context->sp=0;
         (*handle)->context->sp = (uint64) (&((*handle)->stack[DEFAULT_STACK_SIZE-1]));
         (*handle)->state = RUNNING;
         (*handle)->isPer=0;
         (*handle)->arg=arg;


     }
     else {

         (*handle)= __mem_alloc(sizeof (_thread));
         if((*handle)==NULL)return -1;
         (*handle)->id = ++stID;
         (*handle)->timeslice = DEFAULT_TIME_SLICE;
         (*handle)->start_routine = start_routine;
         (*handle)->stack = __mem_alloc(DEFAULT_STACK_SIZE * sizeof(uint64));
         if ((*handle)->stack == NULL) return -1;
         (*handle)->context=__mem_alloc(sizeof(_pcb));
         if ((*handle)->context == NULL) return -1;
         if(*handle==consolethr)(*handle)->context->ra = (uint64)&system_thread_wrapper;
         else (*handle)->context->ra = (uint64)&thread_wrapper;
         (*handle)->context->sp = (uint64) (&((*handle)->stack[DEFAULT_STACK_SIZE-1]));
         (*handle)->state = READY;
         (*handle)->arg=arg;
         (*handle)->isPer=0;
         if(handle!=&idle)sc_put(*handle);

     }
     return 0;
 }

 void contextSwitch(_pcb* old, _pcb* new);
 void printaddr(uintptr a);
void putc1(char c);
int sc_empty();
int sc_in(uint64 thr);
void printc(char c);
void idle_funct();
void __thread_dispatch(){
    /*for(sched s=scheduler;s;s=s->next){
        printaddr(s->data->id);
        printc('\n');
    }*/
    thread_t old = running;
    //if(old->id>2)
    //printc('0'+old->id);printc('-');printc('>');


    again:
    running = sc_get();
    if(running==NULL){
        //printc('i');
        running=idle;
    }else if((running->state)==CREATED){
        sc_put(running);
        goto  again;
    }
    if (old->state==RUNNING && old!=idle) {
        old->state=READY;
        sc_put(old);
    }
    //if(running->id>2)
   //printc('0'+running->id);printc(' ');
    /*if(old->id==4 && old->state==DEAD){
        putc1('0'+old->id);putc1('-');putc1('>');putc1('0'+running->id);putc1(' ');
    }*/
    running->state=RUNNING;
    contextSwitch(old->context, running->context);

}
void  printc(char c);
void  idle_funct(){
    //printc('i');
    for(;;){
        //printc('i');
      /*  timeSliceCounter=0;*/
        //__thread_dispatch();

    }
}
int sem_open (
        sem_t* handle,
        unsigned init
);
extern int thread_create (
        thread_t* handle,
        void(*start_routine)(void*),
        void* arg
);
extern int thread_exit ();
extern void thread_dispatch ();
extern int sem_close (sem_t handle);
extern int sem_wait (sem_t id);
extern int sem_signal (sem_t id);
extern int time_sleep (time_t);
extern char getc ();
extern void putc (char);
extern void sc_put(thread_t thr);
extern thread_t sc_get();
extern int sc_empty();
void *memset(void *ptr, int b, size_t n) {
    char *t = ptr;
    for (int i = 0; i < n; t[i++] = b);
    return  ptr;
}

void puthexdigit(int a) {
   if (a > 9)
       putc1('a'+ a - 10);
    else
        putc1('0'+ a);

}

void printaddr(uintptr a) {
    for (int i = 7; i >= 0; i--) {
        int bajt = (a >> (i*8)) & 0xff;
        int hi = bajt >> 4;
        int lo = bajt & 0xf;
        puthexdigit(hi);
        puthexdigit(lo);
    }
}

int __thread_exit(){
  if(running->state==DEAD){
      return -1;
  }
    running->state=DEAD;
    __thread_dispatch();
    return 0;
}

extern void *mem_alloc(size_t size);
extern int mem_free(void* p);

int __sem_open (
        sem_t* handle,
        unsigned init
){

    (*handle)= __mem_alloc(sizeof(_sem));
    if(!(*handle)) return -1;
    (*handle)->value=init;
    (*handle)->blocked=NULL;
    (*handle)->blend=NULL;
    return 0;
}
int __sem_close(sem_t handle){
    blist* s;
    while(handle->blocked){
        s=handle->blocked;
        thread_t thr=s->data;
        thr->state=READY;
        sc_put(thr);
        handle->blocked=handle->blocked->next;
        if(__mem_free(s)==-1) return -1;

    }
    if(__mem_free(handle)==-1)return -1;
    return 0;
}
void putc1(char c);
spinlock semlock=INITLOCK;
int __sem_wait (sem_t id){
    //mc_sstatus(SSTATUS_SIE);
    if(id && (--id->value<0)){
        //ms_sstatus(SSTATUS_SIE);
        running->state=BLOCKED;
        int x=b_put(id,running);
        if(x==-1) return -1;
            timeSliceCounter=0;
           // slrelease(&semlock);
            __thread_dispatch();

    }
    //ms_sstatus(SSTATUS_SIE);

    return 0;
}

int __sem_signal (sem_t id){

            //mc_sstatus(SSTATUS_SIE);
            ++id->value;
            //ms_sstatus(SSTATUS_SIE);
            if (id->value <= 0) {
                thread_t thr = b_get(id);

                if (thr) {
                    thr->state = READY;
                    sc_put(thr);
                    return 0;

                }

            }

        //putc1('s');

        return -1;



}
extern int putblocked(thread_t thr,time_t time);
extern blist* blocked;
spinlock block=INITLOCK;
int __time_sleep (time_t time){
        running->state=WAITING;
        running->sleep=time;
       // slacquire(&block);
        int ret=putblocked(running,time);
        //slrelease(&block);
        if(ret==-1) {putc1('G');return -1;}
        timeSliceCounter=0;
        __thread_dispatch();
        return 0;
}
extern void put_uart1(char c);
extern char get_uart1();
extern void put_uart2(char c);
extern char get_uart2();
extern void initBuffers();
extern int isEmpty1();
extern int isEmpty2();
void  printc(char c);
void console_putc(){
    while(1) {
        while((mainthr->state==DEAD) && !isEmpty2()){
            mc_sstatus(SSTATUS_SIE);
            uint8 status = *(uint8*)CONSOLE_STATUS;
            while ((status & CONSOLE_TX_STATUS_BIT) && !isEmpty2()) {

                char c = get_uart2();
                __sem_signal(fullPutc);
                *((char *) (CONSOLE_TX_DATA)) = c;
                status = *(uint8*)CONSOLE_STATUS;

            }
            ms_sstatus(SSTATUS_SIE);
        }

        if((mainthr->state==DEAD) && isEmpty2()) break;
       /* if(isEmpty2()){
            __thread_dispatch();
        }*/
        /*while(isEmpty2()){
           if(sc_in(0) || scheduler->next!=NULL)__thread_dispatch();
           else break;
        }*/
        if(isEmpty2()){
            __sem_wait(ioSem);
        }

            //mc_sstatus(SSTATUS_SIE);
            uint8 status = *(uint8*)CONSOLE_STATUS;
            while ((status & CONSOLE_TX_STATUS_BIT) && !isEmpty2()) {

                char c = get_uart2();
                *((char *) (CONSOLE_TX_DATA)) = c;
                status = *(uint8*)CONSOLE_STATUS;

            }
          // ms_sstatus(SSTATUS_SIE);


    }

}
extern char* uartBuffer2,uartBuffer1;
char getc1 (){
    char c;



    //*(uint8*)CONSOLE_STATUS|=!CONSOLE_RX_STATUS_BIT;
    c=get_uart1();
    //__putc(c);
    return c;
}
extern int isFull2();
extern int isFull1();
void putc1 (char c){
    //popSppSpie();
    /*while(isFull2()){
       // __thread_dispatch();
    }*/
    if(isFull2()){
        __sem_wait(fullPutc);
    }
    __sem_signal(ioSem);
    put_uart2(c);

}
void userMain();
extern blist* blend;
void handleblocked() {

    if (blocked) {
       blist *b , *prev = NULL;

          /*   putc1('\n');
            for (b = blocked; b != NULL; b = b->next) {
                printaddr(b->data->id);
                putc1(' ');

            }
            putc1('\n');
            for (b = blocked; b != NULL; b = b->next) {
                printaddr(b->time);
                putc1(' ');

            }
            putc1('\n');*/
///////////////////////////////////////////////////
       for (b = blocked; b != NULL; b = b->next) {
            if (b->time > 0) b->time--;
        }
       b = blocked;
        while (b) {
            if (b->time == 0) {
                blist* tmp = b;

                if (prev == NULL) {
                    if (b == blend) {
                        blocked = blend = NULL;
                        b = NULL;
                    } else {
                        blocked = blocked->next;
                        b = b->next;
                    }
                } else {
                    if (b == blend) {
                        blend = prev;
                        blend->next=NULL;
                        b = NULL;
                    } else {
                        prev->next = b->next;
                        b = b->next;
                    }
                }
                thread_t data = tmp->data;
                data->state = READY;
                sc_put(data);
                __mem_free(tmp);
            } else {
                prev = b;
                b = b->next;
            }
        }

    }

}
void printc(char c){

    uint8 status = *(uint8*)CONSOLE_STATUS;
    if ((status & CONSOLE_TX_STATUS_BIT)) {

        //char c = get_uart2();
        *((char *) (CONSOLE_TX_DATA)) = c;
        status = *(uint8*)CONSOLE_STATUS;
    }

}
void puthexdigit1(int a) {
    if (a > 9)
        printc('a'+ a - 10);
    else
        printc('0'+ a);

}
void printaddr1(uintptr a) {
    for (int i = 7; i >= 0; i--) {
        int bajt = (a >> (i*8)) & 0xff;
        int hi = bajt >> 4;
        int lo = bajt & 0xf;
        puthexdigit1(hi);
        puthexdigit1(lo);
    }
}
extern sem_t ioSemEmpty1;
uint64 handleSupervisorTrap(args* arg) {
    //putc1('p');
    uint64 scause;
    __asm__ volatile ("csrr %[scause], scause" : [scause] "=r"(scause));
    if (scause == 0x0000000000000008UL || scause == 0x0000000000000009UL) {
        // interrupt: no; cause code: environment call from U-mode(8) or S-mode(9)
         uint64 volatile sepc = r_sepc() + 4;
         uint64  volatile sstatus = r_sstatus();

        uint64 ret = arg->a0;

        switch (arg->a0) {
            case (0x01): {

                size_t velicina = arg->a1;
                ret = (uintptr)__mem_alloc(velicina);
                break;
            }
            case (0x02): {

                void *chunk = (void *) arg->a1;
                ret = (uintptr)__mem_free(chunk);
                break;
            }
            case(0x11):{
               // __putc('U');__putc('s');__putc('a');__putc('o');
                args* arg1=(args*)arg->a3;
                void(*pfunct)(void*)=(void(*)(void*))arg->a2;
                thread_t *thr=(thread_t *)arg->a1;
                ret= __thread_create(thr,pfunct,arg1);
                break;

            }
            case(0x12):{
              ret =  __thread_exit();
              break;
            }
            case(0x13):{
               // __putc('T');__putc('D');__putc('i');__putc('s');

               // mc_sstatus(SSTATUS_SIE);
                timeSliceCounter = 0;
                __thread_dispatch();
                //ms_sstatus(SSTATUS_SIE);
                break;
            }
            case(0x21):{
                ret=__sem_open((sem_t*)arg->a1,(unsigned)arg->a2);
                break;
            }
            case(0x22):{
                ret=__sem_close((sem_t)arg->a1);
                break;
            }
            case(0x23):{
              //  __putc('T');__putc('D');__putc('i');__putc('s');

                ret=__sem_wait((sem_t)arg->a1);
                break;
            }
            case(0x24):{
                ret=__sem_signal((sem_t)arg->a1);
                break;
            }
            case(0x31):{
                ret=__time_sleep((time_t)arg->a1);
                break;
            }
            case(0x42):{
                //__putc((char)arg->a1);
                 putc1((char)arg->a1);
                 //__thread_dispatch();
                 break;
            }
            case(0x41):{

                ret=getc1();
                //__putc(ret);
                break;
            }
            default:{
                break;
            }

        }

        w_sstatus(sstatus);
        w_sepc(sepc);

        return ret;
    } else if (scause == 0x8000000000000001UL) {
        // interrupt: yes; cause code: supervisor software interrupt (CLINT; machine timer interrupt)

        handleblocked();
        timeSliceCounter++;


       if (timeSliceCounter >= running->timeslice)
        {

            uint64 volatile sepc = r_sepc();
            uint64 volatile sstatus = r_sstatus();
            timeSliceCounter = 0;
            __thread_dispatch();
            w_sstatus(sstatus);
            w_sepc(sepc);

        }
        mc_sip(SIP_SSIP);
        return arg->a0;

    } else if (scause == 0x8000000000000009UL) {
        // interrupt: yes; cause code: supervisor external interrupt (PLIC; could be keyboard)

       // console_handler();

        int volatile irq = plic_claim();
        if(irq==CONSOLE_IRQ){
           volatile uint8 status = *(uint8*)CONSOLE_STATUS;
            while (status & CONSOLE_RX_STATUS_BIT){


                volatile char c=*((char*)CONSOLE_RX_DATA);
                status=*(uint8*)CONSOLE_STATUS;
                if(c=='\r') c='\n';
                    put_uart1(c);
                    __sem_signal(ioSemEmpty1);

                //putc1(c);

            }
        }
        plic_complete(irq);


        return 0;
    } else {

        // unexpected trap cause
        uint64 volatile sepc = r_sepc();
        uint64 ra,sp;
        __asm__ volatile ("mv %0, ra" : "=r"(ra));
        __asm__ volatile ("mv %0, sp" : "=r"(sp));
        printc('\n');
        printaddr1(scause);
        printc('\n');
        printaddr1(sepc);
        printc('\n');
        printaddr1(sp);
        printc('\n');
        printaddr1(arg->a0);
        printc('\n');
        printaddr1((uintptr)arg);
        printc('\n');
        printaddr1(running->context->ra);

        for(;;);

    }
    return arg->a0;


}

uint64 supervisorTrap();
sem_t sem1;
void semTest(){

    //sem_open(&sem1,0);
    for(int i = 0;i<3;i++){
        sem_wait(sem1);
    }
}

extern int sc_in(uint64 thr);
extern void userMain();
int main(){

      mc_sip(SIP_SSIP);
      initmem();
      initBuffers();
      int ret;
      thread_t uthr;
      ret=__thread_create(&uthr,&userMain,NULL);
      if(ret==-1){
        // putc('G');
        return -1;
      }
      ret=__thread_create(&consolethr,&console_putc,NULL);
      if(ret==-1){
        //__putc('G');
        return -1;
      }
      ret=__thread_create(NULL,NULL,NULL);
      if(ret==-1) {
         // __putc('G');
          return -1;
      }
      running=mainthr;
      ret=__thread_create(&idle,&idle_funct,NULL);
      if(ret==-1){
         // __putc('G');
          return -1;
      }

        __sem_open(&ioSem,0);
        __sem_open(&fullPutc,900000);
        __sem_open(&sem1,0);
        w_stvec((uintptr)supervisorTrap);
        ms_sstatus(SSTATUS_SIE);

       __thread_dispatch();
        while (uthr->state!=DEAD){
        //ms_sstatus(SSTATUS_SIE);
            __sem_signal(sem1);
            __thread_dispatch();

        }

    while(!isEmpty2()){
        __sem_signal(ioSem);

        __thread_dispatch();
    }


 return 0;
}


