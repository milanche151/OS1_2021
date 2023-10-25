#include "../h/syscall_cpp.hpp"
#include "../h/printing.hpp"
extern void* operator new (size_t size);
extern void operator delete(void* ptr);
extern "C" {


#include "../h/syscall_c.h"

    class Pthread:public PeriodicThread{
    public: Pthread(time_t time): PeriodicThread(time){}
    private: void periodicActivation() override{
            printString("Periodic action\n");
        }
    };
    class RunThread:public Thread{
    public:RunThread():Thread(){}
    private: void run() override{
            printString("Action\n");
    }

    };
class RunThread1:public Thread{
public:RunThread1():Thread(){}
private: void run() override{
        printString("Action1\n");
    }

};

void userMain() {
   // Pthread* p = new Pthread(20);
    RunThread* r = new RunThread();
    RunThread1* r1 = new RunThread1();
    r->start();
    r1->start();
    while(1){

    }
}
}
