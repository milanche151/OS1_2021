#include "../h/kernel.h"


uint8 *bitmap;
void *heapstart;
size_t heapsz;
uintptr hstart;
uintptr hend;

spinlock memlock = INITLOCK;

#define ROUNDUP(x, n) ((x) % (n) ? ((x) / (n) + 1) * (n) : (x))
#define ROUNDDOWN(x, n) ((x) % (n) ? ((x) / (n)) * (n) : (x))

extern void printaddr(uintptr a);


void initmem() {
    hstart = ROUNDUP((uintptr)HEAP_START_ADDR, MEM_BLOCK_SIZE);
    hend = ROUNDDOWN((uintptr)(HEAP_END_ADDR-1), MEM_BLOCK_SIZE);

    size_t heapsize = hend - hstart;
    size_t blocknum = heapsize / MEM_BLOCK_SIZE;

    size_t bitmapsz = blocknum / 8;

    bitmap = (void*)hstart;
    heapstart = (void*)ROUNDUP(hstart + bitmapsz, MEM_BLOCK_SIZE);
    heapsz = ((uintptr)heapstart - hend) / MEM_BLOCK_SIZE;

    memset(bitmap, 0, bitmapsz);
}

extern void putc1(char c);

void* __mem_alloc(size_t size){
    void *ret = NULL;

   slacquire(&memlock);

    size_t numblock = ROUNDUP(size, MEM_BLOCK_SIZE) / MEM_BLOCK_SIZE + 1;



    for (size_t i = 0; i < heapsz; i++) {

        if (bitmap[i/8] & (1<<(i%8)))
            continue;

        for (size_t j = 0; j < numblock; j++) {
            if (bitmap[(i + j) / 8] & (1 << ((i + j) % 8))){

                goto petlja;
            }

        }
        for (size_t j = 0; j < numblock; j++)
            bitmap[(i+j)/8] |= 1<<((i+j)%8);

        *(size_t*)((uintptr)heapstart + i*MEM_BLOCK_SIZE) = numblock;
        //printaddr((uintptr)numblock);
        ret = (void*)((uintptr)heapstart + (i + 1)*MEM_BLOCK_SIZE);
        goto retuwurn;

        petlja:
        (void)1;//putc1('?');
    }

    retuwurn:
    slrelease(&memlock);
    return ret;
}
int __mem_free(void *p){
    slacquire(&memlock);
    // ret = (void*)((uintptr)heapstart + i*MEM_BLOCK_SIZE + 1);
    size_t ind = ((uintptr)p - (uintptr)heapstart) / MEM_BLOCK_SIZE - 1;
    size_t numblock = *(size_t *)((uintptr)p - MEM_BLOCK_SIZE);
    size_t i = ind;
    for (; i < ind + numblock; i++) {
        if (((bitmap[i / 8] >> (i % 8)) & 1) == 0) return -1;
        bitmap[i / 8] &= ~(1 << (i % 8));
    }
    slrelease(&memlock);
    return 0;
}
void *mem_alloc(size_t size) {
    void *ret;

    asm volatile ("li a0, 1\n" // Broj poziva
                  "\tmv a1, %1\n"
                  "\tecall\n"
                  "\tmv %0, a0\n" // Povratna vrednost
            : "=r" (ret)
            : "r" (size)
            : "a0", "a1");

    return ret;
}
int mem_free(void* p) {
    void *ret;

    asm volatile ("li a0, 2\n" // Broj poziva
                  "\tmv a1, %1\n"
                  "\tecall\n"
                  "\tmv %0, a0\n" // Povratna vrednost
            : "=r" (ret)
            : "r" (p)
            : "a0", "a1");

    return (uint64)ret;
}

