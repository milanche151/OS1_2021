#include "../h/kernel.h"

void slacquire(spinlock *lk) {
    while(__sync_lock_test_and_set(lk, 1) != 0);
    __sync_synchronize();
}

void slrelease(spinlock *lk) {
    __sync_synchronize();
    __sync_lock_release(lk);
}
